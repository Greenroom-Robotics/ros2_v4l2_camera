import launch
from launch_ros.actions import Node
import os
from ament_index_python import get_package_share_directory

def generate_launch_description():

    pi_camera = Node(
        name="hw_camera_v1_0_2018",
        package="v4l2_camera",
        executable="v4l2_camera_node",
        parameters=[os.path.join(
            get_package_share_directory("v4l2_camera"), "camera_configs", "hd_pi_cam.yaml"
        )],
        output="both",
        arguments=["--ros-args", "--log-level", "webrtc_video:=debug"],

    )


    return launch.LaunchDescription(
        [
            pi_camera,
        ]
    )
