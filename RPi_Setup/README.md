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

### 3. Compile ROS2 driver for Create 1 base

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
    
At this point you should be able to use teleop from the desktop:

Joystick teleop friendly blog:

    https://articulatedrobotics.xyz/mobile-robot-14a-teleop/

To test joystick:

	ros2 run joy joy_enumerate_devices
	ros2 run joy joy_node      # <-- Run in first terminal
	ros2 topic echo /joy       # <-- Run in second terminal

    https://index.ros.org/p/teleop_twist_joy/github-ros2-teleop_twist_joy/

### Note: joy_node sends cmd_vel messages ONLY when enable_button is pressed (Usually btn 1)
	you MUST set enable_button to desired value (0 for btn 1, "front trigger").
	ros2 param get /teleop_twist_joy_node enable_button  - to see current value

    sudo apt-get install ros-humble-teleop-twist-joy

    ros2 launch teleop_twist_joy teleop-launch.py     - also runs joy_node
    ros2 param set /teleop_twist_joy_node enable_button 0


### 4. Compile ROS2 driver for Laser scanner

Surreal XV Lidar controller v1.2 (Neato Lidar)

    https://github.com/getSurreal/XV_Lidar_Controller  - Teensy software
    https://www.getsurreal.com/product/lidar-controller-v2-0/   - hardware (Teensy 2.0)

Connect to the USB port at 115200 baud. (minicom -D /dev/ttyACM0 -b 115200)

ROS2 driver port (by Mark Johnston): https://github.com/mjstn/xv_11_driver

The following file needs editing (as  declare_parameter() now requires a default value as a second parameter):

    /home/sergei/xv_11_ws/src/xv_11_driver/src/xv_11_driver.cpp

    int main(int argc, char * argv[])
    {
      rclcpp::init(argc, argv);

      auto node = rclcpp::Node::make_shared("xv11_laser");

      node->declare_parameter("port",XV11_PORT_DEFAULT);
      auto port_param      = rclcpp::Parameter("port", XV11_PORT_DEFAULT);

      node->declare_parameter("baud_rate", XV11_BAUD_RATE_DEFAULT);
      auto baud_rate_param = rclcpp::Parameter("baud_rate", XV11_BAUD_RATE_DEFAULT);

      node->declare_parameter("frame_id", XV11_FRAME_ID_DEFAULT);
      auto frame_id_param  = rclcpp::Parameter("frame_id", XV11_FRAME_ID_DEFAULT);

      node->declare_parameter("firmware_version", XV11_FIRMWARE_VERSION_DEFAULT);
      auto firmware_param  = rclcpp::Parameter("firmware_version", XV11_FIRMWARE_VERSION_DEFAULT);

Commands to compile and install:

    mkdir -p ~/xv_11_ws/src
    cd ~/xv_11_ws/src
    git clone https://github.com/mjstn/xv_11_driver.git
    
      (edit the xv_11_driver/src/xv_11_driver.cpp here - also define XV11_PORT_DEFAULT as /dev/ttyACM0)

    cd ..
    colcon build
    source ~/xv_11_ws/install/setup.bash
    ros2 run xv_11_driver xv_11_driver &

Rviz needs at least a static transform, to relate the grid to the laser frame ("neato_laser" in this case).

    rviz2 &
    ros2 run tf2_ros static_transform_publisher 0 0 0 0 0 0 map neato_laser &

For Rviz you need:

    Global Options to have Fixed Frame set to a known TF ("map")
  
    Grid reference frame - set to "map"
  
    Add LaserScan, topic "/scan", Style :Spheres" size 0.02
  
    ros2 run tf2_ros tf2_echo map neato_laser            -- to see published TF


### 5. Compile ROS2 driver for BNO055 IMU



### 6. Create a Linux service for on-boot autostart





