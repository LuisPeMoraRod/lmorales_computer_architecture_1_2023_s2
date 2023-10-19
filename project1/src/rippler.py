import cv2
import numpy as np
import sys
import os
import getopt
import subprocess

CLI_ERROR_CODE = 2
FRAMES_NUM = 40
SIZE_X = 640
SIZE_Y = 480
FPS = 4.0  # frames per second
AMPLITUDE = 5 # first value of signal amplitude


class ImgFrameLinkedList:
    """
    Linked List class to store image frames that will make up the animation
    """
    def __init__(self, root_img_name: str, output_name: str):
        self.o_name = output_name
        self.head = None
        self.tail = None
        self.size = 0
        
        self.root_img_data = self.parse_image(root_img_name)  # image format to list
        self.create_dir()  # directory that will contain image frames
        self.create_bin_file(self.root_img_data)  # create first binary file for root image

    def push(self, new_frame):
        if self.size == 0:
            self.head = new_frame
            self.tail = new_frame
        else:
            aux = self.tail
            aux.next = new_frame
            self.tail = new_frame
            new_frame.last = aux
        self.size += 1

    def parse_image(self, name: str) -> list:
        """
        Convert image format to array of integers with pixels gray-scale values
        """
        try:
            img = cv2.imread(name)  # parse image pixels to array
            pixels_list = np.concatenate(img, axis=0)
            return pixels_list[:, 0]  # use only one integer to describe RGB pixel (gray scale)
        except Exception as e:
            print(e)

    def create_dir(self):
        """
        Create a directory where all ouput files will be stored
        """
        if not os.path.isdir(self.o_name):
            os.mkdir(self.o_name)
            os.mkdir(f'{self.o_name}/bin')
            os.mkdir(f'{self.o_name}/images')
        else:
            raise Exception('Error: output file name already exists.')

    def create_bin_file(self, data: np.ndarray):
        """
        Create first binary file for root image
        """
        try:
            data = np.insert(data, 0, AMPLITUDE)
            data = bytearray(data)
            name = f'{self.o_name}/bin/{self.o_name}_0.bin'
            with open(name, 'wb') as f:
                f.write(data)
            f.close()
        except Exception as e:
            print(e)

    def update_amplitude(self, inc):
        file_name = self.head.bin_file_name
        try:
            with open(file_name, mode="rb") as f:
                raw_data = []
                while (byte := f.read(1)):
                    int_byte = int.from_bytes(byte, byteorder="big")
                    raw_data.append(int_byte)  # read bytes from file
                first_byte = raw_data[0]
                raw_data[0] = first_byte + inc
                f.close()
            with open(file_name, "wb") as f: 
                data = bytearray(raw_data)
                f.write(data)
                f.close()
        except Exception as e:
            print(e)


class ImageFrame:
    def __init__(self, id: int, base_file_name: str):
        self.id = id

        self.bin_file_name = self.set_bin_file_name(base_file_name, id)
        self.img_file_name = self.set_img_file_name(base_file_name, id)
        
        self.img_data = self.encode_binary()  # retrieve and parse data from .bin file 
        cv2.imwrite(self.img_file_name, self.img_data)  # create .jpg file
        
        self.next = None
        self.last = None

    def set_bin_file_name(self, base_name: str, id: int) -> str:
        return f'{base_name}/bin/{base_name}_{id}.bin'

    def set_img_file_name(self, base_name: str, id: int) -> str:
        return f'{base_name}/images/{base_name}_{id}.jpg'

    def encode_binary(self) -> np.ndarray:
        """
        Encode binary file data into an image usable format
        """
        try:
            with open(self.bin_file_name, mode="rb") as f:
                raw_data = []
                while (byte := f.read(1)):
                    int_byte = int.from_bytes(byte, byteorder="big")
                    raw_data.append(int_byte)  # read bytes from file

                raw_data = np.array(raw_data, dtype=np.uint8)  # convert to numpy array
                raw_data = raw_data[1:]
                img_data = raw_data.reshape(SIZE_Y, SIZE_X)
                img_data = np.repeat(img_data[:, :, np.newaxis], 3, axis=2)
                return img_data
        except Exception as e:
            print(e)


def get_args(argv: list) -> tuple:
    """
    Returns command-line arguments with options:
        -i,--ifile : input file name
        -o,--ofile : output file name
    """
    input_file = ''
    output_file = ''
    try:
        opts, _ = getopt.getopt(argv, "hi:o:", ["ifile=", "ofile="])
    except getopt.GetoptError:
        print('Command line argument syntax error.\nCorrect command format is:\n\tpython rippler.py -i <inputfile> -o <outputfile>')
        sys.exit(CLI_ERROR_CODE)
    for opt, arg in opts:
        if opt == '-h':
            print('python rippler.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            input_file = arg
        elif opt in ("-o", "--ofile"):
            output_file = arg.split('.', maxsplit=2)
            output_file = output_file[0]
    return input_file, output_file


def rippler(linked_list: ImgFrameLinkedList):
    """
    Execute arm script to process and generate 40 image frames
    """
    base_name = linked_list.o_name

    head_frame = ImageFrame(0, base_name)  # allocate first frame
    linked_list.push(head_frame)  # push to linked list

    cont = 0
    while (cont < FRAMES_NUM):

        command = f"rv-jit rippler < {base_name}/bin/{base_name}_0.bin > {base_name}/bin/{base_name}_{cont+1}.bin" 
        result = subprocess.run(command, shell=True)
        if result.returncode != 0:
            raise Exception(result.stderr)

        cont += 1

        new_frame = ImageFrame(cont, base_name)  # allocate new frame
        linked_list.push(new_frame)  # push to linked list
        linked_list.update_amplitude(AMPLITUDE)  # increment amplitude by 5


def create_video(linked_list: ImgFrameLinkedList):
    frame_size = (SIZE_X, SIZE_Y)
    video_name = f'{linked_list.o_name}/{linked_list.o_name}.avi'
    video = cv2.VideoWriter(video_name, cv2.VideoWriter_fourcc(*'DIVX'), FPS, frame_size)

    node_iter = linked_list.head
    while node_iter is not None:
        img = node_iter.img_data
        #  img = cv2.imread(img_name)
        video.write(img)
        node_iter = node_iter.next

    video.release()


if __name__ == "__main__":
    try:
        input_file, output_file = get_args(sys.argv[1:])
        if input_file == '' or output_file == '':
            raise Exception("Missing argument(s).\nCorrect command format is:\n\tpython rippler.py -i <inputfile> -o <outputfile>")
        else:
            linked_list = ImgFrameLinkedList(input_file, output_file)
            rippler(linked_list)
            create_video(linked_list)

    except Exception as e:
        print(e)
