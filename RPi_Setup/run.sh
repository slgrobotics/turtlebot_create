#!/bin/bash

source ~/create_ws/install/setup.bash
source ~/xv_11_ws/install/setup.bash
source ~/bno055_ws/install/setup.bash

ros2 launch ~/launch/myturtle.py
