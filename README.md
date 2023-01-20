# ROS2 Turtlebot based on old iRobot Create 1 platform
The idea is to take an "old" iRobot Create 1 base, add a Raspberry Pi 3B (or better), a Lidar scanner from Neato botvac, BNO055 IMU - and have it do navigation similar to modern Turtlebot 3.

## Software wise there are two projects:
1. There are drivers on GitHub for Create 1 (also works with Roomba 400, 500, 600 series), BNO055 UMU and XV11 Laser Scanner. They are capable of running on the on-board Raspberry Pi and must be slightly modified and combined with a single launch.py file. On-boot autostart service is created.

2. For a desktop operation I take full Turtlebot 3 source, remove all base-related nodes from the launch file. The removed topics are now published by the on-board Raspberry Pi, and I can run Cartographer, Navigation and other nodes on the desktop for full ROS2 experience.

I've chosen not to create a fork from ROBOTIS-GIT Turtlebot 3 repository, but rather provide clear instructions and some files. It makes it easier to set up a fully functional Turtlebot from scratch.

## So, the steps are:

1. Set up ROS2 on your Linux desktop machine (mine is Intel I5 with 8GB memory) - folder *Desktop_Setup*
2. Set up ROS2 and robot drivers on Raspberry Pi (3B, 4) - folder *RPi_Setup*
3. Teleoperate the robot using the desktop's joystick - folder *Turtle_Setup*
4. Map your room by running ROS2 Cartographer package
5. Navigate around by using Nav2 package
6. Optionally, explore cameras and other devices on the robot

![IMG_20230119_174749811_HDR](https://user-images.githubusercontent.com/16037285/213751203-675d83b6-2036-40fb-a05b-09158c08dd71.jpg)
![IMG_20230119_185616996](https://user-images.githubusercontent.com/16037285/213751208-5553f129-1f50-4218-9046-555f3a39df97.jpg)
![IMG_20230119_182203839_HDR](https://user-images.githubusercontent.com/16037285/213751214-75b6443a-e198-40f2-85ef-94ef069d0949.jpg)
