**Note:** this is an outdated version of instructions, based or ROBOTIS turtlebot3 codebase.

For the current version based on my *articubot_one* code see https://github.com/slgrobotics/robots_bringup

# Turtlebot Setup and Operation (Desktop side)

By this time you want to have your Raspberry Pi on the turtlebot completely set up in autostart-on-boot mode. Three essentual hardware drivers run on Raspberry Pi "turtle.local" and communicate via your home WiFi *(see RPi_Setup folder - https://github.com/slgrobotics/turtlebot_create/tree/main/RPi_Setup)*.

Your *Create Base, XV_11 Laser Scanner* and *BNO055 IMU* nodes and messages should show up in **rqt** and **rqt_graph** on your Linux (Ubuntu 22.04)  desktop machine, which you previously set up with ROS2-Desktop Jazzy *(see Desktop_setup folder)*.

Most of the power hungry ROS2 Turtlebot software (nodes) - like Cartographer and Navigation, - run on your desktop machine. Also, **Rviz, Rqt** and **Rqt_graph** with their UI run on the desktop.

Here is how we set up your **desktop machine** with ROS2 Turtlebot3 software.

## 1. Set up ROBOTIS-GIT Turtlebot3 software - binary and a working copy

The idea is to take a well designed Turtlebot software package and make only necessary modifications to adapt it to our hardware. 

### a. (ROS Humble only) We set up the binary package to be able to try Gazebo simulation and to have all components installed properly in /opt/ros directory.

See https://github.com/ROBOTIS-GIT/turtlebot3

**Note:** There is no _turtlebot3_ binary package for ROS Jazzy. Skip this step.

See https://ros2-industrial-workshop.readthedocs.io/en/latest/_source/navigation/ROS2-Turtlebot.html  (adjust foxy -> humble)

For binary installation:
```
sudo apt install gazebo
sudo apt install ros-${ROS_DISTRO}-turtlebot3*
```
### b. Set up sources of the same Turtlebot3 packages in a working folder. We modified just a few files to make it work with our hardware.

Follow instructions here: https://github.com/slgrobotics/turtlebot3

## 2. (ROS Humble only) Now you can try Gazebo simulation and a keyboard or joystick teleop:

When using standard binary installation :
```
source  /opt/ros/humble/setup.bash
export TURTLEBOT3_MODEL=waffle
```
When using compiled sources from slgrobotics:
```
source ~/turtlebot3_ws/install/setup.bash
export TURTLEBOT3_MODEL=create_1
```

*Empty world:*          ```ros2 launch turtlebot3_gazebo empty_world.launch.py```

*World with obstacles:* ```ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py```

```
ros2 launch turtlebot3_cartographer cartographer.launch.py use_sim_time:=true

ros2 run turtlebot3_teleop teleop_keyboard
```

## 3. Modified Turtlebot3 software to run with Create hardware drivers

I modified one launch file to NOT run the physical Turtlebot3 drivers. My drivers on the Raspberry Pi are already active on the network,  publishing information in */scan, /imu /odom, /joint_states* and other topics. The *Create Base* node will subscribe to */cmd_vel* topic published by teleop.

**Note:** The Autonomy Labs "create_driver" node on Raspberry Pi isn't a ROS2 Turtlebot yet and requires an actual ROBOTIS *robot_state_publisher* node - which I run on the Desktop. Other robots (Plucky, Dragger) run this node on their Raspberry Pi.

The *robot_state_publisher* node is spawned on the Desktop by a modified copy of *robot.launch.py* file in this folder: ```~/turtlebot3_ws/src/turtlebot3/turtlebot3/turtlebot3_bringup/launch/robot.launch.py```

```
cd ~/turtlebot3_ws
colcon build

source ~/turtlebot3_ws/install/setup.bash       # this overrides binary installation pointers
ros2 launch turtlebot3_bringup robot.launch.py
```

## 4. Teleoperate your Turtlebot using keyboard or joystick teleop

These can run in separate terminals, and when on Humble - from the binaries in /opt/ros

On Jazzy - ```source ~/turtlebot3_ws/install/setup.bash```
```
ros2 run turtlebot3_teleop teleop_keyboard

ros2 launch turtlebot3_cartographer cartographer.launch.py
```
It is a good time to run **rqt** and **rqt_graph** to explore nodes and topics.

## Tuning your Gyro (only for Create 1)

If you have Create 1 base - it needs a gyro to compensate for a firmware bug (see https://github.com/AutonomyLab/create_robot/issues/28).

Any analog gyro will do. The original accessory interface board which plugs into the Cargo Bay DB25 connector has an analog gyro, ADXR613. 

I had to create an _"analog gyro emulator"_ by connecting arduino mini to MPU9250 - and producing the same analog signal via PWM (https://github.com/slgrobotics/Misc/tree/master/Arduino/Sketchbook/MPU9250GyroTurtlebot).

Create does not read the gyro (or emulator) - it just passes it through from analog input (pin 4 of Cargo Bay) to the serial stream (which sends all sensor data every 15ms).

Your gyro will produce an ADC value between 0 and 1024, hopefully around 512, when stationary, and that value will vary with rotation (reflecting, naturally, turn rate).

Autonomy Lab Create driver with my modifications reads this value, adds gyro_offset and multiplies it by gyro_scale - and then integrates it (by dt) to produce angle.

https://github.com/slgrobotics/libcreate/blob/master/src/create.cpp : 148
```
// This is a fix involving analog gyro connected to pin 4 of Cargo Bay:
uint16_t angleRaw = GET_DATA(ID_CARGO_BAY_ANALOG_SIGNAL);
float angleF = -((float)angleRaw - 512.0 + getGyroOffset()) * dt;
angleF = angleF * 0.25 * getGyroScale(); // gyro calibration factor
//std::cout<< "dt: " << dt << " distanceRaw: " << distanceRaw << " angleRaw: " << angleRaw << " angleF: " << angleF << std::endl;
deltaYaw = angleF * (util::PI / 180.0); // D2R
```

Create driver needs *angle* to correctly publish *odom* topic, which is important for robot localization as it moves. Correct wheel joints rotation is the best indication of normal operation of odometry calculations.

You will need to calibrate your gyro, by tweaking parameters (see launch file at https://github.com/slgrobotics/turtlebot_create/tree/main/RPi_Setup/launch ).

I describe this process as follows (at https://github.com/slgrobotics/create_robot): 

**Tuning gyro_offset and gyro_scale**

You need to bring up Rviz2 to see wheel joints rotating on a map. The best way I found was to follow setup all the way to running Cartographer.

Analog gyro signal, as read by Create 1, is expected to be 512 when the robot is stationary. If it differs (say, 202 when robot doesn't move) - gyro_offset compensates for that (say, 512-202=310). Adjust it till wheel joints do not move.

The turn rate scale, as reported by gyro, usually needs adjustment. You need to drive the robot forward a couple meters and watch the odom point in Rviz to stay at the launch point. Then turn the robot (using teleop) and watch the *odom* point move. Adjust the gyro_scale for minimal odom displacement during rotations.

Once the parameters are adjusted, robot will be able to map the area, and the odom point will not move dramatically when the robot drives and turns in any direction.

## 5. Map your room by running ROS2 Cartographer package

Once you have your Cartographer running and the *odom* point not moving too much on turns, you will see that the map in Rviz is updated as the robot moves around. Try covering whole available area:

![Map4](https://user-images.githubusercontent.com/16037285/218316215-ae37289f-6fa4-40dd-967b-281c92a759e0.jpg)

When done, save the map as follows (produces two files - "my_map.pgm" and "my_map.yaml"):
```
ros2 run nav2_map_server map_saver_cli -f my_map
```
See https://github.com/ros-industrial/ros2_i_training/blob/main/workshop/source/_source/navigation/ROS2-Cartographer.md

## 6. Navigate around by using Nav2 package

Here are some useful links on using NAV2:

https://navigation.ros.org/tutorials/docs/navigation2_on_real_turtlebot3.html

https://navigation.ros.org/getting_started/index.html

https://automaticaddison.com/the-ultimate-guide-to-the-ros-2-navigation-stack/

https://automaticaddison.com/navigation-and-slam-using-the-ros-2-navigation-stack/

At this point your Create robot is complete, it boots up on power-up and requires no additional installations or command line commands. It is truely "headless". Your further work is done on your Desktop machine.

You need to install NAV2 packages on your Desktop machine:
```
sudo apt install ros-${ROS_DISTRO}-navigation2
sudo apt install ros-${ROS_DISTRO}-nav2-bringup
```
Now the simulation should work (ROS Humble only):
```
export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/opt/ros/humble/share/turtlebot3_gazebo/models
ros2 launch nav2_bringup tb3_simulation_launch.py headless:=False
```
Possible launch files (from _Nav2_ binary install):
```
/opt/ros/jazzy/share/nav2_bringup/launch

/opt/ros/jazzy/share/nav2_bringup/launch/navigation_launch.py
/opt/ros/jazzy/share/nav2_bringup/launch/localization_launch.py
/opt/ros/jazzy/share/nav2_bringup/launch/tb3_simulation_launch.py
/opt/ros/jazzy/share/nav2_bringup/launch/slam_launch.py
/opt/ros/jazzy/share/nav2_bringup/launch/bringup_launch.py
/opt/ros/jazzy/share/nav2_bringup/launch/cloned_multi_tb3_simulation_launch.py
/opt/ros/jazzy/share/nav2_bringup/launch/rviz_launch.py
```
### On a real robot:

Once the Turtlebot boots up and produces */battery/voltage* in *rqt*: 
```
export TURTLEBOT3_MODEL=create_1
ros2 launch turtlebot3_bringup robot.launch.py

export TURTLEBOT3_MODEL=waffle
ros2 launch nav2_bringup bringup_launch.py use_sim_time:=False autostart:=False map:=/home/sergei/my_map.yaml

export TURTLEBOT3_MODEL=waffle
ros2 run rviz2 rviz2 -d $(ros2 pkg prefix nav2_bringup)/share/nav2_bringup/rviz/nav2_default_view.rviz
  or
ros2 run rviz2 rviz2 -d /opt/ros/jazzy/share/nav2_bringup/rviz/nav2_default_view.rviz
```
You should be able to assign a destination point and navigate to it: https://youtu.be/jEXqNpXsQSc

## 7. Optionally, explore cameras and other devices on the robot

So far, my attempts to add Kinect (first generation) or OAK-D Lite produces very high CPU utilization and very low FPS on my Raspberry Pi 3B.
