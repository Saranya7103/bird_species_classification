from flask import Flask,jsonify,request
import tensorflow as tf
from tensorflow import keras
from keras.preprocessing import image
import numpy as np
import base64
import os
from flask_cors import CORS
import cv2
import pandas as pd

model = tf.keras.models.load_model('YOUR ML MODEL HERE', compile=False) 
model.compile()


classes = []
df = pd.read_csv('YOUR LABELS.txt FILE HERE',header=None)
for i in df[0]:
    classes.append(i)



app = Flask(__name__)
CORS(app)


@app.route('/',methods = ['GET','POST'])
def home():
    if(request.method=='GET'):
        data = "Hello world"
        return jsonify({'data':data})
    


def preprocess_image(img):
    img_resized = cv2.resize(img, (224, 224))  
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
