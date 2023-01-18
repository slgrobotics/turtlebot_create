# This is how to set up your Raspberry Pi 3B (or better)

We need to set up a Ubuntu 22.04 Server 64 bit, install ROS2 Humble, compile drivers for Create 1, Laser scanner, BNO055 IMU and create a Linux service for on-boot autostart.

### 1. Set up a Ubuntu 22.04 Server 64 bit

Follow this guide, selecting Ubuntu 22.04.1 LTS Server 64 bit:

    https://docs.ros.org/en/humble/How-To-Guides/Installing-on-Raspberry-Pi.html

Once you go through Ubuntu setup, make sure your Raspberry Pi is connected to your home WiFi. Create a "ros" account with sudo privileges.

Install additional packages for convenience:

You should be able to ping your "turtle.local" machine and ssh into it ("ssh ros@turtle.local" from your Desktop machine).

### 2. Continue with same guide, installing binary ROS2 Humble

Follow these guides:

    https://docs.ros.org/en/humble/Installation.html
    https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html

    https://docs.ros.org/en/humble/Tutorials/Beginner-CLI-Tools/Configuring-ROS2-Environment.html

for "ros" account:

    echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

Try some basic things from Tutorials:

    sudo apt install ros-humble-demo-nodes-py
    sudo apt install ros-humble-demo-nodes-cpp

now you can run in separate terminals (even across your LAN machines):

    ros2 run demo_nodes_cpp talker
    ros2 run demo_nodes_py listener

### 3. Compile ROS2 driver for Create 1

For iRobot Create 1 (2004) and other roombas of 400, 500 and 600 series (https://en.wikipedia.org/wiki/IRobot_Create):

Follow this guide:

    https://github.com/girvenavery2022/create_robot/tree/galactic

here are all commands:

    cd ~
    mkdir -p create_ws/src  
    cd create_ws

    cd ~/create_ws/src
    git clone https://github.com/autonomylab/create_robot.git
    git clone https://github.com/AutonomyLab/libcreate

    cd ~/create_ws
    rosdep update  
    rosdep install --from-paths src --ignore-src -r -y      (will ask for su password)

    cd ~/create_ws
    vi src/create_robot/create_bringup/config/default.yaml    (edit port - /dev/ttyS0 on sergeidell, /dev/ttyUSB0 on turtle)
    colcon build

    source ~/create_ws/install/setup.bash
    ros2 launch create_bringup create_1.launch

### 4. Compile ROS2 driver for Laser scanner

### 5. Compile ROS2 driver for BNO055 IMU

### 6. Create a Linux service for on-boot autostart



