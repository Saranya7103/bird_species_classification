from flask import Flask,jsonify,request
import tensorflow as tf
# from tensorflow.keras.preprocessing import image
# from tensorflow.keras.preprocessing.image import load_img, img_to_array
from tensorflow import keras
from keras.preprocessing import image
# from PIL import Image as image
import numpy as np
import base64
import os
from flask_cors import CORS
import cv2
import pandas as pd

model = tf.keras.models.load_model(r"D:\birds_450\birds_450_inceptionV3.h5", compile=False) 
model.compile()
#classes = ['Amaranthus Green', 'Amaranthus Red', 'Asthma Plant', 'Avaram', 'Balloon vine', 'Balloon vine1', 'Bellyache bush (Green)', 'Benghal dayflower', 'Betel Leaves', 'Big Caltrops', 'Black Night Shade', 'Black-Honey Shrub', 'Bristly Wild Grape', 'Butterfly Pea', 'Cape Gooseberry', 'Celery', 'Chinese Spinach', 'Common Wireweed', 'Coriander Leaves', 'Country Mallow', 'Crown flower', 'Curry Leaf', 'Dwarf Copperleaf (Green)', 'Dwarf copperleaf (Red)', 'False Amarnath', 'Fenugreek Leaves', 'Giant Pigweed', 'Gongura', 'Green Chireta', 'Holy Basil', 'Indian CopperLeaf', 'Indian Jujube', 'Indian Sarsaparilla', 'Indian Stinging Nettle', 'Indian Thornapple', 'Indian pennywort', 'Indian wormwood', 'Ivy Gourd', 'Kokilaksha', 'Lagos Spinach', 'Lambs Quarters', 'Land Caltrops (Bindii)', 'Lettuce Tree', 'Madagascar Periwinkle', 'Madras Pea Pumpkin', 'Malabar Catmint', 'Malabar Spinach (Green)', 'Mexican Mint', 'Mexican Prickly Poppy', 'Mint Leaves', 'Mountain Knotgrass', 'Mustard', 'Nalta Jute', 'Night blooming Cereus', 'Palak', 'Panicled Foldwing', 'Prickly Chaff Flower', 'Punarnava', 'Purple Fruited Pea Eggplant', 'Purple Tephrosia', 'Rosary Pea', 'Shaggy button weed', 'Siru Keerai', 'Small Water Clover', 'Spiderwisp', 'Square Stalked Vine', 'Stinking Passionflower', 'Sweet Basil', 'Sweet flag', 'Tinnevelly Senna', 'Trellis Vine', 'Velvet bean', 'Water Spinach', 'coatbuttons', 'heart-leaved moonseed']


classes = []
df = pd.read_csv(r"D:\AndroidStudioProjects\birds_main\assets\tflite\labels_450.txt",header=None)
for i in df[0]:
    classes.append(i)



app = Flask(__name__)
CORS(app)


@app.route('/',methods = ['GET','POST'])
def home():
    if(request.method=='GET'):
        data = "Hello world"
        return jsonify({'data':data})
    
@app.route('/home/<int:num>', methods = ['GET'])
def disp(num):
  
    return jsonify({'data': num**2})



def preprocess_image(img):
    img_resized = cv2.resize(img, (224, 224))  # Resize the image to (299, 299)
    img_array = img_resized.astype(np.float32)
    img_processed = np.expand_dims(img_array, axis=0)
    img_processed = img_processed / 255.0
    return img_processed
def predict_image(img, model):
    img_processed = preprocess_image(img)
    prediction = model.predict(img_processed)
    index = np.argmax(prediction)
    return classes[index]


@app.route('/home/image', methods=['POST'])
def predict():
    img = request.files['file']
    img.save("img.jpg")
    image = cv2.imread("img.jpg")
    pred = predict_image(image, model)

    return jsonify({"prediction": pred})


if __name__ == '__main__':
    app.run(host='0.0.0.0',port=5000)