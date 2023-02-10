# ROS2 Turtlebot based on old iRobot Create 1 platform
The idea is to take an "old" iRobot Create 1 base, add a Raspberry Pi 3B (or better), a Lidar scanner from Neato botvac, BNO055 IMU - and have it do navigation similar to modern Turtlebot 3.

## Software wise there are two projects:
1. There are drivers on GitHub for Create 1 (also works with Roomba 400, 500, 600 series), BNO055 UMU and XV11 Laser Scanner. They are capable of running on the on-board Raspberry Pi and must be slightly modified and combined with a single launch.py file. On-boot autostart service is created.

2. For a desktop operation I take full Turtlebot 3 source, remove all base-related nodes from the launch file. The removed topics are now published by the on-board Raspberry Pi, and I can run Cartographer, Navigation and other nodes on the desktop for full ROS2 experience.

I've chosen to create a fork from ROBOTIS-GIT Turtlebot 3 repository, and also provide here clear instructions and some files. It makes it easier to set up a fully functional Turtlebot from scratch.

## So, the steps are:

1. Set up ROS2 on your Linux desktop machine (mine is Intel I5 with 8GB memory) - folder *Desktop_Setup*
2. Set up ROS2 and robot drivers on Raspberry Pi (3B, 4) - folder *RPi_Setup*
3. Teleoperate the robot using the desktop's joystick - folder *Turtle_Setup*
4. Map your room by running ROS2 Cartographer package
5. Navigate around by using Nav2 package
6. Optionally, explore cameras and other devices on the robot

## Below is my Turtlebot setup

I have a powered USB hub ("Belkin") for the Laser scanner, and some obsolete router 9V power for my prior experiments. The Raspberry Pi and USB hub are powered from a 3S LiPo battery through a 5V Buck converter. The Raspberry Pi 3B is connected to Create 1 Base via FTDI USB-to-TTL-Serial adapter, pins 1,2 and 14.

I use Pixhawk standard I2C connectors for convenience, feeding 3.3V to its VCC rail. BNO055 IMU is connected to it.

![IMG_20230119_174749811_HDR](https://user-images.githubusercontent.com/16037285/213751203-675d83b6-2036-40fb-a05b-09158c08dd71.jpg)
![IMG_20230121_113657264_HDR](https://user-images.githubusercontent.com/16037285/213880585-62cd0c68-21be-45c6-a729-305838dba4c0.jpg)
![IMG_20230119_185616996](https://user-images.githubusercontent.com/16037285/213751208-5553f129-1f50-4218-9046-555f3a39df97.jpg)
![IMG_20230119_182203839_HDR](https://user-images.githubusercontent.com/16037285/213751214-75b6443a-e198-40f2-85ef-94ef069d0949.jpg)

## Here's an "analog gyro emulator"
(See https://github.com/slgrobotics/Misc/tree/master/Arduino/Sketchbook/MPU9250GyroTurtlebot):

![IMG_20230209_191916513_HDR](https://user-images.githubusercontent.com/16037285/217976758-1e9bc7c2-e8a8-45b0-a2b9-337abd95e2cf.jpg)

## See full manual in the Docs folder

![IMG_20230120_103156610](https://user-images.githubusercontent.com/16037285/213752879-3c88968a-8206-4ac0-acd0-9c275ddac683.jpg)
![IMG_20221217_095711148](https://user-images.githubusercontent.com/16037285/213755321-cc3408be-14e7-410d-8cd5-442953a7a80b.jpg)
