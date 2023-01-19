# Turtlebot Setup and Operation

By this time you want to have your Raspberry Pi on the turtlebot completely set up in autostart-on-boot mode. Three essentual hardware drivers run on Raspberry Pi "turtle.local" and communicate via your home WiFi *(see RPi_Setup folder)*.

Your *Create Base, XV_11 Laser Scanner* and *BNO055 IMU* nodes and messages should show up in **rqt** and **rqt_graph** on your Linux (Ubuntu 22.04)  desktop machine, which you previously set up with ROS2-Desktop Humble *(see Desktop_setup folder)*.

Most of the power hungry ROS2 Turtlebot software (nodes) - like Cartographer and Navigation, - run on your desktop machine. Also, **Rviz, Rqt** and **Rqt_graph** with their UI run on the desktop.

Here is how we set up your **desktop machine** with ROS2 Turtlebot software.

1. Set up ROBOTIS-GIT Turtlebot3 software - binary and a working copy

The idea is to take a well designed Turtlebot software package and make only necessary modifications to adapt it to our hardware. 

We set up the binary package to be able to try Gazebo simulation and to have all components installed properly in /opt/ros directory.

See https://github.com/ROBOTIS-GIT/turtlebot3

See https://ros2-industrial-workshop.readthedocs.io/en/latest/_source/navigation/ROS2-Turtlebot.html  (adjust foxy -> humble)

For binary installation:

    sudo apt install gazebo
    sudo apt install ros-humble-turtlebot3*

We also set up sources of the same Turtlebot3 packages in a working folder, where we can modify just a few files to make it work with our hardware.

Install sources in a working directory:

    mkdir -p ~/turtlebot_create_ws/src
    cd turtlebot_create_ws/
    wget https://raw.githubusercontent.com/ROBOTIS-GIT/turtlebot3/humble-devel/turtlebot3.repos
    vcs import src<turtlebot3.repos

    rosdep update
    rosdep install --from-paths src --ignore-src -y

You want to append the following to .barshrc

    export TURTLEBOT3_MODEL=waffle

Now you can try Gazebo simulation and keyboard teleop:

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






2. Test Turtlebot3 in Gazebo simulation

3. Modify the working copy of Turtlebot3 software to run with Create hardware drivers

4. Teleoperate your Turtlebot using keyboard teleop

5. Map your room by running ROS2 Cartographer package

6. Navigate around by using Nav2 package

7. Optionally, explore cameras and other devices on the robot

