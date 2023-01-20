# Turtlebot Setup and Operation

By this time you want to have your Raspberry Pi on the turtlebot completely set up in autostart-on-boot mode. Three essentual hardware drivers run on Raspberry Pi "turtle.local" and communicate via your home WiFi *(see RPi_Setup folder)*.

Your *Create Base, XV_11 Laser Scanner* and *BNO055 IMU* nodes and messages should show up in **rqt** and **rqt_graph** on your Linux (Ubuntu 22.04)  desktop machine, which you previously set up with ROS2-Desktop Humble *(see Desktop_setup folder)*.

Most of the power hungry ROS2 Turtlebot software (nodes) - like Cartographer and Navigation, - run on your desktop machine. Also, **Rviz, Rqt** and **Rqt_graph** with their UI run on the desktop.

Here is how we set up your **desktop machine** with ROS2 Turtlebot3 software.

## 1. Set up ROBOTIS-GIT Turtlebot3 software - binary and a working copy ##

The idea is to take a well designed Turtlebot software package and make only necessary modifications to adapt it to our hardware. 

### a. We set up the binary package to be able to try Gazebo simulation and to have all components installed properly in /opt/ros directory. ###

See https://github.com/ROBOTIS-GIT/turtlebot3

See https://ros2-industrial-workshop.readthedocs.io/en/latest/_source/navigation/ROS2-Turtlebot.html  (adjust foxy -> humble)

For binary installation:

    sudo apt install gazebo
    sudo apt install ros-humble-turtlebot3*

### b. We also set up sources of the same Turtlebot3 packages in a working folder, where we can modify just a few files to make it work with our hardware. ###

Install sources in a working directory:

    mkdir -p ~/turtlebot_create_ws/src
    cd turtlebot_create_ws/
    wget https://raw.githubusercontent.com/ROBOTIS-GIT/turtlebot3/humble-devel/turtlebot3.repos
    vcs import src<turtlebot3.repos

    rosdep update
    rosdep install --from-paths src --ignore-src -y

You want to append the following to .barshrc

    export TURTLEBOT3_MODEL=waffle

## 2. Now you can try Gazebo simulation and a keyboard or joystick teleop: ##

```
source  /opt/ros/humble/setup.bash
export TURTLEBOT3_MODEL=waffle
```
*Empty world:*          ```ros2 launch turtlebot3_gazebo empty_world.launch.py```

*World with obstacles:* ```ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py```

```
export TURTLEBOT3_MODEL=waffle
ros2 launch turtlebot3_cartographer cartographer.launch.py use_sim_time:=true

export TURTLEBOT3_MODEL=waffle
ros2 run turtlebot3_teleop teleop_keyboard
```

## 3. Modify the working copy of Turtlebot3 software to run with Create hardware drivers ##

We need to modify one launch file to NOT run the physical Turtlebot3 drivers. Our drivers on the Raspberry Pi are already active on the network,  publishing information in */scan, /imu /odom, /joint_states* and other topics. The *Create Base* node will subscribe to */cmd_vel* topic published by teleop.

Find a modified copy of *robot.launch.py* file in this folder and copy it here:

    ~/turtlebot_create_ws/src/turtlebot3/turtlebot3/turtlebot3_bringup/launch/robot.launch.py

## 4. Teleoperate your Turtlebot using keyboard teleop ##

```
cd ~/turtlebot_create_ws
colcon build
source ~/turtlebot_create_ws/install/setup.bash   (this overrides binary installation pointers)
ros2 launch turtlebot3_bringup robot.launch.py
```
**These can run in separate terminals from the binaries in /op/ros:**
```
ros2 run turtlebot3_teleop teleop_keyboard

ros2 launch turtlebot3_cartographer cartographer.launch.py
```
It is a good time to run **rqt** and **rqt_graph** to explore nodes and topics.

## 5. Map your room by running ROS2 Cartographer package ##

Once you have your Cartographer running ... [ to be continued ]

## 6. Navigate around by using Nav2 package ##

## 7. Optionally, explore cameras and other devices on the robot ##

