# Desktop Setup and operation

Most of the ROS2 Turtlebot software (nodes) run on the desktop computer. Cartographer and Navigation are too demanding for CPU and memory to fit on the on-board Raspberry Pi. Also, Rviz, Rqt and Rqt_graph with their UI can't run on the headless RPi Ubuntu Server.

Here is how we set up a Linux desktop machine (mine is Intel I5 with 8GB memory)

1. We use Ubuntu 22.04 Desktop OS - 64 bit

The OS setup is better described elsewhere (i.e. https://ubuntu.com/tutorials/install-ubuntu-desktop)

    login:  ubuntu / ubuntu

You need to make sure that your network is set up, better use Ethernet cable initially, for WiFi - see /etc/netplan/*

It is a good idea to update:

    sudo apt update
    sudo apt upgrade
    sudo apt full-upgrade
    sudo apt clean

    hostnamectl set-hostname NEW_NAME

    sudo adduser ros sudo

Have some extra networking packages installed:

    sudo apt install winbind samba smbclient net-tools
    sudo apt install python3-pip

2. Set up "full ROS2-Desktop Humble" on your desktop machine. I used binary Debian packages.

    https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html

    sudo apt install ~nros-humble-rqt*

3. Set up ROBOTIS-GIT Turtlebot3 for simulation and actual Create operation

    https://github.com/ROBOTIS-GIT/turtlebot3

    https://navigation.ros.org/tutorials/docs/navigation2_on_real_turtlebot3.html


sudo apt install -y python3-colcon-common-extensions python3-rosdep python3-vcstool

Follow https://ros2-industrial-workshop.readthedocs.io/en/latest/_source/navigation/ROS2-Turtlebot.html

Use https://github.com/ROBOTIS-GIT/turtlebot3

For binary:

    sudo apt install gazebo
    sudo apt install ros-humble-turtlebot3*

For sources:

    mkdir -p ~/turtlebot3_ws/src
    cd turtlebot3_ws/
    wget https://raw.githubusercontent.com/ROBOTIS-GIT/turtlebot3/humble-devel/turtlebot3.repos
    vcs import src<turtlebot3.repos

    rosdep update
    rosdep install --from-paths src --ignore-src -y

    source  /opt/ros/humble/setup.bash
    export TURTLEBOT3_MODEL=waffle
    Empty world:          ros2 launch turtlebot3_gazebo empty_world.launch.py
    World with obstacles: ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py

    export TURTLEBOT3_MODEL=waffle
    ros2 launch turtlebot3_cartographer cartographer.launch.py use_sim_time:=true

    export TURTLEBOT3_MODEL=waffle
    ros2 run turtlebot3_teleop teleop_keyboard


4. Teleoperate the robot using the desktop's joystick

5. Map your room by running ROS2 Cartographer package

6. Navigate around by using Nav2 package

7. Optionally, explore cameras and other devices on the robot

