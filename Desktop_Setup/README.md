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
	  sudo apt clean    // purges packages from SD   https://www.raspberrypi.org/forums/viewtopic.php?f=66&t=133691

	  hostnamectl set-hostname NEW_NAME

    sudo adduser ros sudo

Have some extra networking packages installed:

    sudo apt install winbind samba smbclient net-tools
    sudo apt install python3-pip

2. Set up "full ROS2 Humble desktop" on your desktop machine. I used binary Debian packages.

    [https://docs.ros.org/en/humble/Tutorials.html](https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html)

    sudo apt install ~nros-humble-rqt*

3. Set up ROBOTIS-GIT Turtlebot3 for simulation and actual Create operation

4. Teleoperate the robot using the desktop's joystick

5. Map your room by running ROS2 Cartographer package

6. Navigate around by using Nav2 package

7. Optionally, explore cameras and other devices on the robot

