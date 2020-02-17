# v4l2_camera

A ROS 2 camera driver using Video4Linux2 (V4L2).

## Custom Dependencies

The following dependencies need to be pulled in manually, because we
need new features in them that have not been released yet:

* `common_interfaces` - USB cameras mostly use the YUY2 format, which
  historically hasn't been supported in ROS. Support has [landed
  recently](https://github.com/ros2/common_interfaces/pull/78), but
  has not been released yet, so you need to clone master into your
  workspace:

        git clone https://github.com/ros2/common_interfaces.git src/common_interfaces

* `vision_opencv` - The OpenCV bridge is used to convert between image
  formats. Support for the YUY2 format has not landed yet (see PR
  [ros-perception/vision_opencv#309](https://github.com/ros-perception/vision_opencv/pull/309). Until
  that has happened, clone the fork into your workspace:

        git clone --branch yuv422-yuy2 https://github.com/sgvandijk/vision_opencv.git src/vision_opencv

## Nodes

### v4l2_camera_node

The `v4l2_camera_node` interfaces with standard V4L2 devices and
publishes images as `sensor_msgs/Image` messages.

#### Published Topics

* `/raw_image` - `sensor_msgs/Image`

    The image.

#### Parameters

* `video_device` - `string`, default: `"/dev/video0"`

    The device the camera is on.

* `pixel_format` - `string`, default: `"YUYV"`

    The pixel format to request from the camera. Must be a valid four
    character '[FOURCC](http://fourcc.org/)' code [supported by
    V4L2](https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/videodev.html)
    and by your camera. The node outputs the available formats
    supported by your camera when started.

    Currently only `"YUYV"` is supported, which results in image
    messages with the `YUV422_YUY2` encoding.

* `output_encoding` - `string`, default: `"rgb8"`

    The encoding to use for the output image. Any format supported by
    `cv_bridge::cvtColor` is allowed. If this matches the input format
    from the camera, no conversion and thus no additional overhead is
    required.

* `image_size` - `integer_array`, default: `[640, 480]`

    Width and height of the image.

* Camera Control Parameters

    Camera controls, such as brightness, contrast, white balance, etc,
    are automatically made available as parameters. The driver node
    enumerates all controls, and creates a parameter for each, with
    the corresponding value type. The parameter name is derived from
    the control name reported by the camera driver, made lower case,
    commas removed, and spaces replaced by underscores. So
    `Brightness` becomes `brightness`, and `White Balance, Automatic`
    becomes `white_balance_automatic`.

## Compressed Transport

Streaming raw images from a robot to your machine takes up a very
large bandwidth and is especially not feasible through WiFi. By using
`image_transport` the images can be compressed to make streaming
possible. However, by default `image_transport` only supports raw
transfer, and additional plugins are required to enable
compression.

Standard ones are available in the
[`image_transport_plugins`](https://github.com/ros-perception/image_transport_plugins)
repository. You can clone these into your workspace to get these:

    git clone --branch ros2 https://github.com/ros-perception/image_transport_plugins.git src/image_transport_plugins

### Building: Ubuntu

The following packages are required to be able to build the plugins:

    sudo apt install libtheora-dev libogg-dev libboost-python-dev

### Building: Arch

To get the plugins compiled on Arch Linux, a few special steps are
needed:

* Arch provides OpenCV 4.x, but OpenCV 3.x is required
* Arch provides VTK 8.2, but VTK 8.1 is required
* `boost-python` is used, which [needs to be linked to python libs
  explicitly](https://bugs.archlinux.org/task/55798):

        colcon build --symlink-install --packages-select cv_bridge --cmake-args "-DCMAKE_CXX_STANDARD_LIBRARIES=-lpython3.7m"

### Usage

If the compression plugins are compiled and installed in the current
workspace, they will be automatically used by the driver and
additional `/image_raw/compressed` and `/image_raw/theora` topics will
be available.

Neither Rviz2 or `showimage` use `image_transport` (yet) and so can't
use these topics. Therefore, to be able to view a compressed topic,
it needs to be republished uncompressed. `image_transport` comes with
the `republish` node to do this:

    ros2 run image_transport republish compressed in/compressed:=image_raw/compressed raw out:=image_raw/uncompressed

To use the Theora (possibly more bandwidth efficient):

    ros2 run image_transport republish theora in/theora:=image_raw/theora raw out:=image_raw/uncompressed

**NB:** the idea is to run this and do the decompression on your
machine, _not_ on the robot, or else you'll be streaming raw data
through the network after all anyway.

The parameters mean:

* `compressed` - the transport to use for input, in this case
  'compressed'. Alternative: `raw`, to republish the raw `/image_raw`
  topic
* `in/compressed:=image_raw/compressed` - by default, `republish` uses
  the topics `in` and `out`, or `in/compressed` for example if the
  input transport is 'compressed'. This parameter is a ROS remapping
  rule to map those names to the actual topic to use.
* `raw` - the transport to use for output. If omitted, all available
  transports are provided.
* `out:=image_raw/uncompressed` - remapping of the output topic.
