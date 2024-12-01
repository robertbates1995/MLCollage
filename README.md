# MLCollage: Train AI to see  
### Create effective object detection models with less data collection  
MLCollage is a mac-based app that allows users to generate high volumes of novel annotated images given a small sample input. 
Used in tandem with [CreateML](https://developer.apple.com/machine-learning/create-ml/), users can easily and quickly train their very own object detection model 
capable of finding the location of any object within a picture. Traditionally, when training object detection models it can take days, or even weeks, 
to collect the thousands of sample photos needed. MLCollage changes that! This app allows the artificial generation of thousands of unique photos featuring any subject a user desires. 
This drastically cuts down on the time it takes to prepare training data. Additionally, MLCollage helps ensure a diverse data set by changing a wide array of variables. 
This further improves an object detection model's capability to recognize an object in a wide variety of conditions, such as at night or in different weather conditions.
Stop wasting your time on the tedium of data collection. Dowload MLCollage, and train your vison model _fast_.

### What is an object detection model?
A model trained to detect a particular object within a larger image is called an object detection model. Specifically, such a model is designed to locate and identify instances of the target object within the broader visual context.

### What is novel data?  
CreateML needs an input consisting of many photos of the object to be recognized, as well as an annotation pointing 
out where the object is speciffically in each picture. Many times, the number of photos needed to effectively train a 
model number in the thousands or more. Taking that many photos is tedious. So is annotating all of them. MLcollage helps by 
providing all that data with as few as 30 photos. 

### Modify the original subject in multiple ways:
- Translate 
- Scale
- Rotate
- Flip accross either axis
- Hue shift to simulate differing time of day

### Example use cases
- Detecting a specific type of fruit in a bin of assorted produce.
- Identifying vehicles in traffic footage.
- Recognizing a logo within a busy advertisement.

## Directions
as previously mentioned, MLCollage is designed to be used in tandem with [CreateML](https://developer.apple.com/machine-learning/create-ml/). 
When a training set is generated, a JSON file is included in the output. This package, including the JSON, can be dropped directly into an ML object detection model's inputs in the create ML app.

### Download the app to your iPhone  

### Take photos and isolate them to be used

### Select subjects and backgrounds in the app  

### Set parameters for image generation  

### Generate images  

### Drop file into CreateML

### Train
