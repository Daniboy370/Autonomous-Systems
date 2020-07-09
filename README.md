# Navigation and State Estimation

018827 - [Advanced Applications in Inertial Systems](https://www.graduate.technion.ac.il/Subjects.Heb/?SUB=018827&SEM=201702).


**Syllabus** :
Navigation filters, precise methods for IMU initializations, satellite systems and inertial navigation systems integration,
information fusion with measurable and external data, pedestrian navigation and gyro-free navigation.

The course's final project exhibits a full navigation solution with noised IMU and GPS
sensors, estimated by EKF, and pronounced in a set of kinematic and global states along the scenario :

&nbsp;  &nbsp; &nbsp;  &nbsp; &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  [![Watch the video](https://github.com/Daniboy370/Autonomous-Systems/blob/master/Advanced%20Applications%20in%20Inertial%20Systems/Error_Estimation_GIF.gif)](https://www.youtube.com/watch?v=O6Orm3T98A0) 

Unlike the position that is being corrected by the observation itself ( z̃_GPS ), here the errors
worsen along time, as they evolve in a random walk :

&nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  [![Watch the video](https://github.com/Daniboy370/Autonomous-Systems/blob/master/Advanced%20Applications%20in%20Inertial%20Systems/Course/Strapdown%20INS/drift_velocity.png)](https://www.youtube.com/watch?v=RhmRRAcA_xg
)

The final and most important expression of the IMU drift, can be seen in the
overall trajectory whose estimated course deviates exponentially over time, w.r.t to GT :

&nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;   &nbsp;  &nbsp; ![alt text](https://github.com/Daniboy370/Autonomous-Systems/blob/master/Advanced%20Applications%20in%20Inertial%20Systems/Course/Strapdown%20INS/drift_map.png)

#
086761 - [Vision Aided Navigation](https://www.graduate.technion.ac.il/Subjects.Eng/?Sub=86761).

**Syllabus** :
Inertial and Dead Reckoning Navigation, Probabilistic Information Fusion, Vision Aided Navigation, Simultaneous Localization and Mapping, Imu Pre-Integration, Visual-Inertial Bundle Adjustment, Cooperative Navigation and Slam (Centralized and Distributed), Active State Estimation and Belief-Space Planning. 

Demonstration from homeworks :
![alt text](https://github.com/Daniboy370/Autonomous-Systems/blob/master/Hands-on/SLAM.png)

#
086759 - [Navigation Systems](https://www.graduate.technion.ac.il/Subjects.Eng/?Sub=86759).


**Syllabus** :
Orientation Parametrization, Major Coordiante Frames in Navigation Systems, 3D Rigid Transformation Between Different Coordinate Frames, Dynamics, Inertial Sensors, Inertial Navigation Equations, Earth Model, Sensor Error Characteristics, Inertial Error Prograation, GNSS, Overview of Ins-GPS Ekf. 
1. Learn the Operating Principles and the Underlying Equations of Inertial Navigation Systems. 
2. Learn to Perform Analysis to Inertial Navigation Errors. 
3. Get Familiar with Principle of Operation of GNSS Systems. 

Demonstration from homeworks :
![alt text](https://github.com/Daniboy370/Autonomous-Systems/blob/master/Hands-on/demo_navigation.png)

## Requirements
The codes run solely on *Matlab* without further packages.
