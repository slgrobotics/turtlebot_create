For updated version of this guide see https://github.com/slgrobotics/robots_bringup/tree/main/Docs/ROS-Jazzy

# Desktop Setup and operation

Most of the ROS2 Turtlebot software (nodes) run on the desktop computer. Cartographer and Navigation are too demanding for CPU and memory to fit on the on-board Raspberry Pi. Also, Rviz, Rqt and Rqt_graph with their UI can't run on the headless RPi Ubuntu Server.

Here is how we set up a Linux desktop machine (mine is Intel I5 with 8GB memory)

### 1. We use Ubuntu 22.04 Desktop OS - 64 bit ###

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

### 2. Set up "full ROS2-Desktop Humble" on your desktop machine. I used binary Debian packages. ###

    https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html

    sudo apt install ~nros-humble-rqt*
    
Install **Rviz IMU visualizer plugin** from  https://github.com/CCNYRoboticsLab/imu_tools

    sudo apt-get install ros-humble-imu-tools

The IMU plugin is described here for ROS1, but works fine in ROS2 Humble: http://wiki.ros.org/rviz_imu_plugin 

**Now you can proceed to RPi_Setup folder:**  https://github.com/slgrobotics/turtlebot_create/tree/main/RPi_Setup
