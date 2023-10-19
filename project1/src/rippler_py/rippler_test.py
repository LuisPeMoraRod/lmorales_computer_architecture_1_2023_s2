import cv2
import numpy as np
import sys
import os
import getopt
import subprocess
import math

CLI_ERROR_CODE = 2
FRAMES_NUM = 40
SIZE_X = 640
SIZE_Y = 480
FPS = 4.0  # frames per second
AMPLITUDE = 5 # first value of signal amplitude


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


def rippler_fun(x, y, A, L):
    return round(x + A * math.sin(2 * math.pi * y / L))
    

def rippler_effect(input_file, output_file, frames, A, L):
    img = cv2.imread(input_file)  # parse image pixels to array
    (m, n, o) = img.shape  # (480, 640, 3)
    print(img.shape)
    images = []
    images.append(img)
    for i in range(frames):
        new_img = np.zeros((m, n, o), dtype=np.uint8)
        A_i = i * A
        for x in range(m - 1):
            for y in range(n - 1):
                x_aux = rippler_fun(x, y, A_i, L)
                x_new = x_aux % m

                y_aux = rippler_fun(y, x, A_i, L)
                y_new = y_aux % n

                if x_new == x_aux and y_new == y_aux:
                    if x_new < (SIZE_Y - 1) and y_new < (SIZE_X - 1):
                        new_img[x_new + 1, y_new + 1] = img[x, y]
        images.append(new_img)

    frame_size = (SIZE_X, SIZE_Y)
    video_name = f'{output_file}.avi'
    video = cv2.VideoWriter(video_name, cv2.VideoWriter_fourcc(*'DIVX'), FPS, frame_size)

    for img_data in images:
        video.write(img_data)

    video.release()


if __name__ == "__main__":
    try:
        input_file, output_file = get_args(sys.argv[1:])
        if input_file == '' or output_file == '':
            raise Exception("Missing argument(s).\nCorrect command format is:\n\tpython rippler.py -i <inputfile> -o <outputfile>")
        else:
            rippler_effect(input_file, output_file, 40, 5, 75)

    except Exception as e:
        print(e)
