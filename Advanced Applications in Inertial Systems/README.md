# EKF for a strapdown model
 > Technion course : Advanced Applications in Inertial Navigation Systems (018827)
 
Online demonstration of EKF estimation performance w.r.t several IMU/GPS fusion ratio, and thus the evolving of the corresponding error. Requires basic *Matlab* installation without further packages.

&nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp; [![Watch the video](https://github.com/Daniboy370/Autonomous-Systems/blob/master/Advanced%20Applications%20in%20Inertial%20Systems/Error_estimation_GIF.gif)](https://www.youtube.com/watch?v=O6Orm3T98A0)

Unlike the position that is being corrected by the observation itself ( z̃_GPS ), the errors
worsen along time, as they evolve in a random walk :

&nbsp;  &nbsp; &nbsp;  &nbsp; &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  [![Watch the video](https://github.com/Daniboy370/Autonomous-Systems/blob/master/Advanced%20Applications%20in%20Inertial%20Systems/Course/Strapdown%20INS/drift_velocity.png)](https://www.youtube.com/watch?v=O6Orm3T98A0)

The final and most important expression of the IMU drift, can be seen in the
overall trajectory whose estimated course deviates exponentially over time, w.r.t to GT :

&nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;  &nbsp;   &nbsp;  &nbsp; ![alt text](https://github.com/Daniboy370/Autonomous-Systems/blob/master/Advanced%20Applications%20in%20Inertial%20Systems/Course/Strapdown%20INS/drift_map.png)


#
## Citation
* Monitoring Degree of Observability in GPS/INS Integration [[link](https://www.researchgate.net/publication/228997493_Monitoring_Degree_of_Observability_in_GPSINS_Integration)] :
```
@article{article,
author = {Han, Songlai},
year = {2008},
month = {01},
pages = {},
title = {Monitoring Degree of Observability in GPS/INS Integration}
}
```
#
## Installation
1. Clone the desired repository in the root directory
2. Install Matlab 
3. Download [raw-data](https://github.com/Daniboy370/Autonomous-Systems/blob/master/Advanced%20Applications%20in%20Inertial%20Systems/Code_model/Trajectory.mat) from the model's directory


## Contents

Extended Kalman Filter solution for a navigation strapdown model ,under Technion course : 
Advanced Applications in Inertial Navigation Systems ([018827](https://www.graduate.technion.ac.il/Subjects.Eng/?Sub=18827)).

## Additional
Raw data of IMU and GPS that can be selectively noised by to the user.
Full online code and exact code

