# Turtlebot Setup and Operation

By this time you want to have your Raspberry Pi on the turtlebot completely set up in autostart-on-boot mode. Three essentual hardware drivers run on Raspberry Pi "turtle.local" and communicate via your home WiFi *(see RPi_Setup folder)*.

Your *Create Base, XV_11 Laser Scanner* and *BNO055 IMU* nodes and messages should show up in **rqt** and **rqt_graph** on your Linux (Ubuntu 22.04)  desktop machine, which you previously set up with ROS2-Desktop Humble *(see Desktop_setup folder)*.

Most of the power hungry ROS2 Turtlebot software (nodes) - like Cartographer and Navigation, - run on your desktop machine. Also, **Rviz, Rqt** and **Rqt_graph** with their UI run on the desktop.

Here is how we set up your desktop machine with ROS2 Turtlebot software.

1. Set up ROBOTIS-GIT Turtlebot3 software - binary and a working copy

2. Test Turtlebot3 in Gazebo simulation

3. Modify the working copy of Turtlebot3 software to run with Create hardware drivers

4. Teleoperate your Turtlebot using keyboard teleop

5. Map your room by running ROS2 Cartographer package

6. Navigate around by using Nav2 package

7. Optionally, explore cameras and other devices on the robot

