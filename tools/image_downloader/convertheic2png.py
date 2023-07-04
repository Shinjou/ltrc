# Not working because I can not install pyheif 

import os
import pyheif
from PIL import Image

def heic_to_png(directory):
    # list all files in the directory
    files = os.listdir(directory)

    # filter .heic files
    heic_files = [f for f in files if f.lower().endswith('.heic')]

    # convert only first 5 files
    for f in heic_files[:5]:
        heif_file = pyheif.read(os.path.join(directory, f))
        image = Image.frombytes(
            heif_file.mode, 
            heif_file.size, 
            heif_file.data,
            "raw",
            heif_file.mode,
            heif_file.stride,
        )

        # remove '.heic' from filename
        filename_without_extension = os.path.splitext(f)[0]

        # save as .png
        image.save(os.path.join(directory, filename_without_extension + '.png'), format="PNG")

if __name__ == "__main__":
    heic_to_png('your_directory_path')  # Replace with your directory path
