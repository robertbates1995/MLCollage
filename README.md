# MLCollage: Train AI to see  
### Effective vision AI models with less data collection  
MLCollage is a mac-based app that allows users to generate high volumes of novel annotated images given a small sample input. 
Used in tandem with [CreateML](https://developer.apple.com/machine-learning/create-ml/), users can easily train their very own vision model.
When training ml vision models, often it can be tough to collect the thousands of sample photos often needed to effectively train 
to a high degree of accuracy. That's where MLCollage comes in. This app allows the artificial generation of many unique photos of the subject. 
Stop wasting your time on the tedium of data collection! Dowload MLCollage, and train your vison model _fast_.

### What is the novel data specifically?  
CreateML needs an input consisting of many photos of the object to be recognized, as well as an annotation pointing 
out where the object is speciffically in each picture. Many times, the number of photos needed to effectively train a 
model number in the thousands or more. Taking that many photos is tedious. So is annotating all of them. MLcollage helps by 
providing all that data with as few as 30 photos. 

### What do I use this for?  
If you are creating a data set to train a vision model using CreateML, this is the app for you!

## Modify the original subject in multiple ways:
- translate 
- scale
- rotate
- flip accross either axis
- hue shift to simulate differing time of day

## Application
as previously mentioned, MLCollage is designed to be used in tandem with [CreateML](https://developer.apple.com/machine-learning/create-ml/). 
When a training set is generated, a JSON file is included in the output. This package, including the JSON, can be dropped directly into an ML vision model's inputs in the create ML app.
