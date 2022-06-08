# Raspberry Pi HD Camera v1.0
This is an HD camera for raspberry pi

## V4L2 Parameters Available

### Pixel Formats
  YU12 - Planar YUV 4:2:0
  YUYV - YUYV 4:2:2
  RGB3 - 24-bit RGB 8-8-8
  JPEG - JFIF JPEG
  H264 - H.264
  MJPG - Motion-JPEG
  YVYU - YVYU 4:2:2
  VYUY - VYUY 4:2:2
  UYVY - UYVY 4:2:2
  NV12 - Y/CbCr 4:2:0
  BGR3 - 24-bit BGR 8-8-8
  YV12 - Planar YVU 4:2:0
  NV21 - Y/CrCb 4:2:0

#### Usage
```
    pi_camera = Node(
        name="hw_camera_v1_0_2018",
        package="v4l2_camera",
        executable="v4l2_camera_node",
        parameters=[
          "video_device": "/dev/video0"
          "pixel_format": "YUYV"
          "output_encoding": "rgb8"
          "image_size": [640, 480]
        ],
        output="both",
        arguments=["--ros-args", "--log-level", "webrtc_video:=debug"],

    )
```

#### Control Params
| param                           | default  |
| ------------------------------- | -------- |
| contrast (1)                    | 0        |
| saturation (1)                  | 0        |
| red_balance (1)                 | 1000     |
| blue_balance (1)                | 1000     |
| horizontal_flip (2)             | 0        |
| vertical_flip (2)               | 0        |
| power_line_frequency (3)        | 1        |
| sharpness (1)                   | 0        |
| color_effects (3)               | 0        |
| rotate (1)                      | 0        |
| color_effects, CbCr (1)         | 32896    |
| codec_controls (6)              | 0        |
| video_bitrate_mode (3)          | 0        |
| vdeo_bitrate (1)                | 10000000 |
| repeat_sequence_header (2)      | 0        |
| h264_i_frame_period (1)         | 60       |
| h264_level (3)                  | 11       |
| h264_profile (3)                | 4        |
| camera_controls (6)             | 0        |
| auto_exposure (3)               | 0        |
| exposure_time_absolute (1)      | 1000     |
| exposure_dynamic_framerate (2)  | 0        |
| auto_exposure_bias (9)          | 12       |
| white_balance_auto_&_preset (3) | 1        |
| image_stabilization (2)         | 0        |
| iso_sensitivity (9)             | 0        |
| iso_snsitivity_auto (3)         | 1        |
| exposure_metering_mode (3)      | 0        |
| scene_mode (3)                  | 0        |
| jpeg_cmpression_controls (6)    | 0        |
| cmpression_quality (1)          | 30       |