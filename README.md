There is an **updated version of this guide** - https://github.com/slgrobotics/robots_bringup/tree/main/Docs/Create1 - but some info here is still very relevant 

# ROS2 Turtlebot based on old iRobot Create 1 platform
The idea is to take an "old" iRobot Create 1 base, add a Raspberry Pi 3B (or better), a Lidar scanner from Neato botvac, BNO055 IMU - and have it do navigation similar to modern Turtlebot 3.

## Software wise there are two projects:
1. There are drivers on GitHub for Create 1 (also works with Roomba 400, 500, 600 series), BNO055 UMU and XV11 Laser Scanner. They are capable of running on the on-board Raspberry Pi 3B and must be slightly modified and combined with a single launch.py file. On-boot autostart service is created.

2. If using RPi 3B - for a desktop operation I run "_turtle_" robot from my "articubot_one" repository. For RPi 4 or 5 - just run _RViz2_ as described in the updated guide.
  
## So, the steps are:

1. Set up Ubuntu 24.04 and ROS2 Jazzy on your Linux desktop machine (mine is Intel I7 with 16GB memory) - https://github.com/slgrobotics/robots_bringup/tree/main/Docs/ROS-Jazzy
2. Set up ROS2 and robot drivers on Raspberry Pi (3B, 4, 5) - folder *[RPi_Setup](https://github.com/slgrobotics/turtlebot_create/tree/main/RPi_Setup)*
3. Teleoperate the robot using the desktop's joystick - folder *[Turtle_Setup](https://github.com/slgrobotics/turtlebot_create/tree/main/Turtle_Setup)*
4. Map your room by running ROS2 Cartographer package
5. Navigate around by using Nav2 package
6. Optionally, explore cameras and other devices on the robot

## Here are links to GitHub repositories you will need:

https://github.com/slgrobotics/create_robot

https://github.com/slgrobotics/libcreate

https://github.com/slgrobotics/turtlebot3

https://github.com/slgrobotics/turtlebot3_simulations  (does not apply to ROS Jazzy)

https://github.com/slgrobotics/robots_bringup/tree/main

## Below is my Turtlebot setup

I have a powered USB hub ("Belkin") for the Laser scanner, and some obsolete router 9V power for my prior experiments. The Raspberry Pi and USB hub are powered from a 3S LiPo battery through a 5V Buck converter. The Raspberry Pi 3B is connected to Create 1 Base via FTDI USB-to-TTL-Serial adapter, pins 1,2 and 14.

I use Pixhawk standard I2C connectors for convenience, feeding 3.3V to its VCC rail. BNO055 IMU is connected to it.

![IMG_20230119_174749811_HDR](https://user-images.githubusercontent.com/16037285/213751203-675d83b6-2036-40fb-a05b-09158c08dd71.jpg)
![IMG_20230121_113657264_HDR](https://user-images.githubusercontent.com/16037285/213880585-62cd0c68-21be-45c6-a729-305838dba4c0.jpg)
![IMG_20230119_185616996](https://user-images.githubusercontent.com/16037285/213751208-5553f129-1f50-4218-9046-555f3a39df97.jpg)
![IMG_20230119_182203839_HDR](https://user-images.githubusercontent.com/16037285/213751214-75b6443a-e198-40f2-85ef-94ef069d0949.jpg)

## If you have genuine analog gyro connected to DB25 Pin 4 - do nothing

![IMG_9755](https://user-images.githubusercontent.com/16037285/228358282-196188dc-9f45-4dbe-9b6b-1d3374c00cea.JPG)

**Note from Ross Lunan:**
*If using Kinect and a Cargo Bay Expansion Board (from IHeartEngineering) that has a Gyro and 12 v regulator to power the Kinect. The Kinect power is enabled by a +5v from the "Digital Output 0".
This enabling was originally done by a "Breaker" python script that runs in the original turtlebot_bringup/minimal.launch.
The Autonomy driver does not have a code to drive this Digital Output (Create OI Index 147). But you can jury-rig a wire jumper (or small resistor, 100..150 Ohm) between DB25 Pins 8 (Switched 5V) to Pin 19 (Digital Output 0 a.k.a. Regulator "Enable" Pin).
Works like a charm providing regulated +12 v/1.5 A for the onboard Kinect.*

## Instead of analog gyro, here's my "analog gyro emulator" (Arduino + MPU9250)
only needed for Create 1, if you don't have analog gyro or genuine accessory board. See [this link](https://github.com/slgrobotics/Misc/tree/master/Arduino/Sketchbook/MPU9250GyroTurtlebot):

![IMG_20230209_191916513_HDR](https://user-images.githubusercontent.com/16037285/217976758-1e9bc7c2-e8a8-45b0-a2b9-337abd95e2cf.jpg)

## See full manual in this folder: *https://github.com/slgrobotics/robots_bringup/tree/main/Docs/Create1*

![IMG_20230120_103156610](https://user-images.githubusercontent.com/16037285/213752879-3c88968a-8206-4ac0-acd0-9c275ddac683.jpg)
![IMG_20221217_095711148](https://user-images.githubusercontent.com/16037285/213755321-cc3408be-14e7-410d-8cd5-442953a7a80b.jpg)
