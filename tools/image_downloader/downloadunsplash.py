'''
import requests
import shutil

# Replace with your Unsplash API access key
access_key = "Z-w14cqJ_VBTjvJSoMlgq4k2NYxAgODO4pPAzpVj1k8"

# The search query
query = "dog"

# URL for the Unsplash API
url = f"https://api.unsplash.com/photos/random?query={query}&client_id={access_key}"

# Send a GET request to the API
response = requests.get(url)
response.raise_for_status()  # Raise an exception if the request was unsuccessful

# Get the URL of the actual photo from the JSON response
photo_url = response.json()["urls"]["full"]
print('photo_url =', photo_url)

# Send a GET request to download the photo
photo_response = requests.get(photo_url, stream=True)
photo_response.raise_for_status()  # Raise an exception if the request was unsuccessful

# Save the photo to a file
with open("photo.jpg", "wb") as file:
    photo_response.raw.decode_content = True
    shutil.copyfileobj(photo_response.raw, file)

print("Downloaded photo.jpg")

'''
import requests
import shutil
import os

current_directory = os.getcwd()
# Replace with your Unsplash API access key
access_key = "Z-w14cqJ_VBTjvJSoMlgq4k2NYxAgODO4pPAzpVj1k8"

# Your list of objects
'''
objects = [("人物", "mom"), ("人物", "dad"), ("人物", "elder brother"), ("人物", "elder sister"), 
           ("人物", "younger brother"), ("人物", "younger sister"), ("人物", "grandfather"), 
           ("人物", "grandmother"), ("人物", "grandpa"), ("人物", "grandma"), ("人物", "uncle"), 
           ("人物", "aunt"), ("人物", "teacher"), ("人物", "classmate"), ("人物", "boy"), 
           ("人物", "girl"), ("人物", "adult"), ("人物", "child"), ("食物", "soy milk"), 
           ("食物", "milk"), ("食物", "sesame flatbread"), ("食物", "rice ball"), 
           ("食物", "toast"), ("食物", "bread"), ("食物", "porridge"), ("食物", "sweet potato leaves"), 
           ("食物", "cabbage"), ("食物", "cauliflower"), ("食物", "fried rice"), 
           ("食物", "scrambled eggs with tomatoes"), ("食物", "chicken steak"), 
           ("食物", "hamburger"), ("食物", "corn soup"), ("食物", "dumplings"), 
           ("食物", "beef noodles"), ("動物", "puppy"), ("動物", "kitten"), ("動物", "bird"), 
           ("動物", "dragonfly"), ("動物", "butterfly"), ("動物", "fish"), ("動物", "turtle"), 
           ("動物", "rabbit"), ("動物", "snail"), ("動物", "ant")]
'''

objects = [("動物", "Piglet"), ("動物", "Fawn"), ("動物", "Lamb"),
    ("動物", "Tiger"), ("動物", "Peacock"), ("植物", "Banyan tree"),
    ("植物", "Cherry blossom tree"), ("植物", "Grassland"),
    ("植物", "Goldenrain tree"), ("植物", "Wisteria"), ("植物", "Strawberry"),
    ("植物", "Sunflower"), ("植物", "Rose"), ("植物", "Apple tree"),
    ("植物", "Green bamboo"), ("植物", "Mango tree"), ("植物", "Red cypress tree"),
    ("植物", "Cryptomeria tree"), ("植物", "Camphor tree"),
    ("植物", "Five-leaf pine"), ("植物", "Taiwan cypress"),
    ("植物", "Bamboo shoot"), ("植物", "Loquat tree"),
    ("植物", "Fir tree"), ("植物", "Coconut tree"),
    ("植物", "Rhododendron"), ("植物", "Chrysanthemum"),
    ("植物", "Rose flower")]

# Iterate over the objects
for type_name, object_name in objects:
    # Create the directory for the object type if it doesn't exist
    directory = os.path.join(current_directory, type_name)  # replace "/path/to/your/directory" with your directory
    os.makedirs(directory, exist_ok=True)
    print('directory =', directory)

    # URL for the Unsplash API
    url = f"https://api.unsplash.com/photos/random?query={object_name}&client_id={access_key}"
    print('url =', url)

    # Send a GET request to the API
    response = requests.get(url)
    print('response.status_code =', response.status_code)
    response.raise_for_status()  # Raise an exception if the request was unsuccessful

    # Get the URL of the actual photo from the JSON response
    photo_url = response.json()["urls"]["full"]

    # Send a GET request to download the photo
    photo_response = requests.get(photo_url, stream=True)
    photo_response.raise_for_status()  # Raise an exception if the request was unsuccessful

    # Save the photo to a file
    with open(os.path.join(directory, f"{object_name}.jpg"), "wb") as file:
        photo_response.raw.decode_content = True
        shutil.copyfileobj(photo_response.raw, file)

    print(f"Downloaded photo for {object_name}.")

print("Done downloading all photos.")
