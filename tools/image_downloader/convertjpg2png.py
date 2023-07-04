'''
The prompt that I gave to ChatGPT:
I have a list of directories as shown below. I want to convert 
every jpg image file in these directories to the PNG format. 
Please provide Python code to do so.
directories =["人物", "食物", "動物", "植物"]
'''
from PIL import Image
import os

# Define the list of directories
directories = ["人物", "食物", "動物", "植物"]

# Iterate over each directory
for directory in directories:
    # Iterate over each file in the directory
    for filename in os.listdir(directory):
        # If the file is a .jpg file
        if filename.endswith(".jpg"):
            # Open the image file
            img = Image.open(os.path.join(directory, filename))
            # Change the file extension to .png
            new_filename = os.path.splitext(filename)[0] + ".png"
            # Save the image as a .png file
            img.save(os.path.join(directory, new_filename), "PNG")
            # Optional: remove the original .jpg file
            # os.remove(os.path.join(directory, filename))

print("Done!")
