### MLCollage: Train an AI to see
## Train effective vision AI models while taking fewer photos

ML Collage is a mac-based app that allows users to generate high volumes of novel annotated images given a small sample input. 
Used in tandem with [CreateML](https://developer.apple.com/machine-learning/create-ml/), users can easily train their very own vision model.
When training ml vision models, often it can be tough to collect the thousands of sample photos often needed to effectively train 
to a high degree of accuracy. That's where MLCollage comes in. This app allows the generation of many 'novel' photos of the subject by 
essentaly cut-and-pasting the pre-existing photos into new arrangements. Stop wasting your time on the tedium of data collection! Dowload
ML Collage and train your vison model _fast_.

What is the novel data specifically?
CreateML needs an input consisting of many photos of the object to be recognized, as well as an annotation pointing 
out where the object is speciffically in each picture. Many times, the number of photos needed to effectively train a 
model number in the thousands or more. Taking that many photos is tedious. So is annotating all of them. MLcollage helps by 
providing all that data with as few as 30 photos. 

What do I use this for?
If you are creating a data set to train a vision model using CreateML, this is the app for you!

## Modify the original subject in multiple ways:
- translate 
- scale
- rotate
- flip accross either axis
- hue shift to simulate differing time of day

## Application
MLCollage is designed to be used in tandem with create ML. When a training set is generated, a JSON file is included in the output. 
this package, including the JSON, can be dropped directly into an ML vision model's inputs in the create ML app.
