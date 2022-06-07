import launch
from launch_ros.actions import Node
import os

config_path = 

def generate_launch_description():

    pi_camera = Node(
        package="v4l2_camera",
        executable="v4l2_camera_node",
        parameters=[os.path.join(
            get_package_share_directory("ros2_v4l2_camera"), "camera_configs", "hd_pi_cam.yaml"
        )],
        output="both",
        arguments=["--ros-args", "--log-level", "webrtc_video:=debug"],
    )


    return launch.LaunchDescription(
        [
            pi_camera,
        ]
    )
