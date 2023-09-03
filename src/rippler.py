import cv2
import numpy as np
import sys
import os
import getopt

CLI_ERROR_CODE = 2


class ImgFrameLinkedList:
    """
    Linked List class to store image frames that will make up the animation
    """
    def __init__(self, root_img_name: str, output_name: str):
        self.root_img_data = self.parse_image(root_img_name)  # image format to list
        self.o_name = output_name
        self.head = None
        self.tail = None
        self.size = 0
        self.create_dir()  # directory that will contain image frames
        breakpoint()
        self.create_bin_file(self.root_img_data)

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
        else:
            raise Exception('Error: output file name already exists.')

    def create_bin_file(self, data: np.ndarray):
        """
        Create first binary file for root image
        """
        try:
            data = bytearray(data)
            name = f'{self.o_name}/bin/{self.o_name}_0.bin'
            with open(name, 'wb') as f:
                f.write(data)
            f.close()
        except Exception as e:
            print(e)


class ImageFrame:
    def __init__(self, id: int, base_file_name: str):
        self.id = id
        self.bin_file_name = self.set_bin_file_name(base_file_name, id)
        self.next = None
        self.last = None

    def set_bin_file_name(self, base_name: str, id: int) -> str:
        return f'{base_name}_{id}.bin'

    def set_img_file_name(self, base_name: str, id: int) -> str:
        return f'{base_name}_{id}.jpg'


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
            print('sm_codes_parser.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            input_file = arg
        elif opt in ("-o", "--ofile"):
            output_file = arg.split('.', maxsplit=2)
            output_file = output_file[0]
    return input_file, output_file


if __name__ == "__main__":
    try:
        input_file, output_file = get_args(sys.argv[1:])
        if input_file == '' or output_file == '':
            raise Exception("Missing argument(s).\nCorrect command format is:\n\tpython rippler.py -i <inputfile> -o <outputfile>")
        else:
            linked_list = ImgFrameLinkedList(input_file, output_file)
    except Exception as e:
        print(e)
