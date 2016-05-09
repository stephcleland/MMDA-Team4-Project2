MMDA Team 4 Project 2: OverTime OT
====
###### Stephanie Cleland, Nate Winters, Alex Goldschmidt, Amanda Savage, Steven Santos, Ian Fletcher

### Problem Statement
Patients only interact with their OTs for ~3 hours a day, but they live their limitations for all 24. Without their primary OTs present, caregivers might struggle not only to motivate the patient but also work towards improving their patient’s ADLs.
###### "The more that she (Alexa) can be happy and feel like she has increased independence, the more she will participate and work towards her therapy" -OT

### Customer Requirements
* Caregivers want to be able to personalize the patient’s care such that the patient is motivated to work towards improvement and increased independence in ADLs
* Caregivers want to be able to track the patient’s progress towards reaching set goals, through both detailed health data and understandable, generalized improvements
* Caregivers want to enable the patient to participate in activities they enjoyed prior to injury through improving motion necessary to complete those activities
* Caregivers want to be able to have set measurable, personalized goals, a “just right” challenge, for their patients to reach, starting at a measured baseline level
* Caregivers want the patient’s health data to be secure

### Major Functionality for OverTime OT
* OT creates individualized activity based on a set of movements
* Physical device (Arduino with gyro / accelerometer) will be mounted on flexible band that can be worn on any place on any limb 
* Physical device and user input measure patient progress towards activities
* Device is connected to app via wifi
* Daily activity progress is sent to the OT for future planning
* Activity data is displayed to caregiver by day / by activity
* Daily activity progress is communicated to caregiver 
* Goals can be set for each activity to motivate patient 

### Installation Instructions
Just drag and drop the MMDA-Project2 folder into your project in Xcode. OverTime OT requires the hardware necessary to collect 
the data. The hardware consists of an Arduino, gyroscope, and accelerometer. OverTime OT is also dependent on a Heroku
server for data persistence of the patient's statistics. 

### Running Instructions
Once the code is in Xcode, the app must be run on an iPhone 5S, either in the simulator or on a real iPhone. 
The iPhone must be running iOS 8.1 or later.

### Future Works
Moving forward, the OverTime OT team wants to expand the app to include the following features:
* Different app interface for the OT and the primary caregiver
* Ability to track multiple motions at the same time
* A system for OTs to have mutiple patients on the app, each with their own data
* More comprehensive data overview
* More accurate motion detection algorithm
* More portable design of the hardware to allow for increased motion design

### Known Bugs
Currently no known bugs are present in the application. Further testing is required to guarantee
the absence of bugs.

### Open Source License
MIT License

Copyright (c) 2016 OverTime OT

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
