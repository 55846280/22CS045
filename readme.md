# Introduction

This project attempted to use Vocaloid 4 to generate a singing recording dataset with different value of 7 parameters, including BRE, BRI, CLE, GEN, GWL, OPE, and Vibrate, and use this dataset to train a model to recognitize the parameter value of real singing, thereby to explore applying this method into Mechine Learning task.\
\
Developing evniroment: Python 3.9.4\
Modules mainly used: Keras 2.9.0, librosa 0.9.1


# File purpose
## Step 0: Constant (00_Constant)

fyp_constants: A py file defined constants that are used in this project.


## Step 1: Generate Setting (01_Generate_Setting)

lyric.csv: list all 103 Japanese letters that are used to generate samples\
noteSeq.csv: list all possible note sequences in this project (for a 4 second sample)\
ListNoteSeq.ipynb: the code to generate noteSeq.csv\
genSetting.ipynb: the code to generate the setting of samples that to be generated by Vocaloid 4


## Step 2: Generate Sample (02_Generate_Sample)

autoSync.lua: a script for automating the process of setting up a sample in Vocaloid 4. This script will import as a Job Plugin in the software.\
template.vsqx: a Vocaloid 4 project save file, already set up for sample generation.\
start.vbs: act as a entry for the whole automate generation process\
setup.vbs: to activate the job plugin by hotkey\
sync.vbs: to activate the synthesizing and exporting by hotkey\
thread.vbs: to ensure the job plugin will terminate before sync.vbs is executed\
progress.txt: to store the generating progress during automate generation


## Step 3: Data Processing (03_Data_Processing)

preprocess.ipynb: python script for data preprocessing


## Step 4: Model (04_Model)

trainModel: python script for train models\
testModel: python script for test models


# Folder purpose
Data, model and some figure are stored in the folder below during my project. Those file are not uploaded to this repository but Google Drive. Link of the drive can be found in the corresponding readme.md in the folder.

## Folder data

The generated audio, dataset, processed audio, recording for testing are stored in this folder


## Folder model

The trained models in experiments are stored in this folder


## Folder figure

The boxplot generated in External Test are stored in this folder


