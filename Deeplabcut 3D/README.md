# 3D DeepLabCut
(FOR 2 CAMERA SUPPORT)

* Open Anaconda Prompt. Activate the DEEPLABCUT environment using the following command. 
```python
Run: activate DEEPLABCUT
```

* First enter into the ipython terminal and import deeplabcut using the commands:

```python
Run: ipython
```

```python
Run: import deeplabcut
```

* Run the following commands initially to prevent: wxAssertionError (OR)
AttributeError: ‘MainFrame’ object has no attribute ‘rdb’: 

```python
import locale
locale.setlocale(locale.LC_ALL, 'C')
```
### (1) Create a New 3D Project:

Run:
```python
deeplabcut.create_new_project_3d('ProjectName','NameofLabeler',num_cameras = 2)
```
TIP 1: you can also pass ``working_directory=`Full path of the working directory'`` if you want to place this folder somewhere beside the current directory you are working in. If the optional argument ``working_directory`` is unspecified, the project directory is created in the current working directory.

TIP 2: you can also place ``config_path3d`` in front of ``deeplabcut.create_new_project_3d`` to create a variable that holds the path to the config.yaml file, i.e. ``config_path3d=deeplabcut.create_new_project_3d(...`` Or, set this variable for easy use. Please note that ``config_path3d='Full path of the 3D project configuration file'``.

 This function will create a project directory with the name **Name of the project+name of the experimenter+date of creation of the project+3d** in the **Working directory**. The project directory will have subdirectories: **calibration_images**, **camera_matrix**, **corners**, and **undistortion**.  All the outputs generated during the course of a project will be stored in one of these subdirectories, thus allowing each project to be curated in separation from other projects.

 The purpose of the subdirectories is as follows:

 **calibration_images:** This directory will contain a set of calibration images acquired from the two cameras. A calibration image can be acquired using a printed checkerboard and its pair wise images are taken from both the cameras to consider as a set of calibration images. These pair of images are saved as ``.jpg`` with camera names as the prefix. e.g. ``camera-1-01.jpg`` and ``camera-2-01.jpg`` for the first pair of images. 

 **camera_matrix:** This directory will store the parameter for both the cameras as a pickle file. Specifically, these pickle files contain the intrinsic and extrinsic camera parameters. While the intrinsic parameters represent a transformation from 3-D camera's coordinates into the image coordinates, the extrinsic parameters represent a rigid transformation from world coordinate system to the 3-D camera's coordinate system.

 **corners:**  As a part of camera calibration, the checkerboard pattern is detected in the calibration images and these patterns will be stored in this directory. Each row of the checkerboard grid is marked with a unique color.

 **undistortion:** In order to check for calibration, the calibration images and the corresponding corner points are undistorted. These undistorted images are overlaid with undistorted points and will be stored in this directory.

 Here is an overview of the calibration and triangulation workflow that follows:

 <p align="center">
<img src="https://images.squarespace-cdn.com/content/v1/57f6d51c9f74566f55ecf271/1559751031211-IOTHQDAEEFP939AD8L8Q/ke17ZwdGBToddI8pDm48kCpBvlJgRextwO-RLKSiThBZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZamWLI2zvYWH8K3-s_4yszcp2ryTI0HqTOaaUohrI8PIMRcHFn6kFHmdB2CIEK_nkzQWBtRKl1IphR3INrGSAiA/3dworkflow.png?format=1000w" width="55%">
</p>

### (2) Take and Process Camera Calibration Images:

The checkerboard images taken should be named with the **camera-#** as the prefix, i.e. **camera-1-01.jpg** and **camera-2-01.jpg** for the first pair of images. Please note, this cannot be changed after the project is created. Also, make sure that the numbering is same, e.g: camera-1-**01** and camera-2-**01**.

To extract the frames from the video captured(this extracts 200 frames from the video), run the following commands for the two cameras:
**RUN THE FOLLOWING COMMANDS IN ANACONDA PROMPT AFTER ACTIVATING THE DEEPLABCUT ENVIRONMENT WITHOUT GOING INTO THE IPYTHON TERMINAL. ALSO, YOU NEED TO NAVIGATE TO THE VIDEO DIRECTORY IN THE ANACONDA PROMPT WHERE THE VIDEOS ARE PRESENT.**
```
ffmpeg -i 002_Nexigo.mp4 -r 2 -vframes 200 camera-1-%03d.jpg

ffmpeg -i 002_Webcam.mp4 -r 2 -vframes 200 camera-2-%03d.jpg
```

The camera calibration is an **iterative process**, where the user needs to select a set of calibration images where the grid pattern is correctly detected. The function:``deeplabcut.calibrate_cameras(config_path)``
extracts the grid pattern from the calibration images and store them under the `corners` directory. The grid pattern could be 8x8 or 5x5 etc. We use a pattern of the 8x6 grid to find the internal corners of the checkerboard.

In some cases, it may happen that the corners are not detected correctly or the order of corners detected in the camera-1 image and camera-2 image is incorrect. You need to remove these pair of images from the **calibration_images** folder as they will reduce the calibration accuracy.

To begin, please place your images into the **calibration_images** directory.

 (**CRITICAL!**) Edit the **config.yaml** file to set the camera names; note that once this is set, **do not change the names!**

Then, run:

```python
deeplabcut.calibrate_cameras(config_path3d, cbrow=8, cbcol=6, calibrate=False, alpha=0.9)
```
NOTE: you need to specify how many rows (``cbrow``) and columns (``cbcol``) your checkerboard has. Also, first set the variable ``calibrate`` to **False**, so you can remove any faulty images. You need to visually inspect the output to check for the detected corners and select those pair of images where the corners are correctly detected. Please note, If the scaling parameter ``alpha=0``, it returns undistorted image with minimum unwanted pixels. So it may even remove some pixels at image corners. If ``alpha=1``, all pixels are retained with some extra black images.


Once all the set of images are selected (namely, delete from the folder any bad pairs!) where the corners and their orders are detected correctly, then the two cameras can be calibrated using:

```python
deeplabcut.calibrate_cameras(config_path3d, cbrow=8, cbcol=6, calibrate=True, alpha=0.9)
```

This computes the intrinsic and extrinsic parameters for each camera. A re-projection error is also computed using the intrinsic and extrinsic parameters which provide an estimate of how good the parameters are. The transformation between the two cameras are estimated and the cameras are stereo calibrated. Furthermore, the above function brings both the camera image plane to the same plane by computing the stereo rectification. These parameters are stored as a pickle file named as `stereo_params.pickle` under the directory `camera_matrix`.

Once you have run this for the project, you do not need to do so again (unless you want to re-calibrate your cameras); be advised, if you do re-calibrate, you may want to clearly mark which videos are analyzed with "old" vs. "new" calibration images.

### (3) Check for Undistortion:

In order to check how well the stereo calibration is, it is recommended to undistort the calibration images and the corner points using camera matrices and project these undistorted points on the undistorted images to check if they align correctly. This can be done in deeplabcut as:

```python
deeplabcut.check_undistortion(config_path3d, cbrow=8, cbcol=6)
```

Each calibration image is undistorted and saved under the directory ``undistortion``. A plot with a pair of undistorted camera images with its undistorted corner points overlaid is also stored. Please visually inspect this image. All the undistorted corner points from all the calibration images are triangulated and plotted for the user to visualize for any undistortion related errors. If they are not correct, go check and revise the calibration images (then repeat the calibration and this step)!

### (4) Triangulation --> Take your 2D to 3D!

If there are no errors in the undistortion, then the pose from the 2 cameras can be triangulated to get the 3D DeepLabCut coordinates!

 (**CRITICAL!**) Name the video files in such a way that the file name **contains the name of the cameras** as specified in the ``config file``. e.g. if the cameras as named as ``camera-1`` and ``camera-2`` (or ``cam-1``, ``cam-2`` etc.) then the video filename must contain this naming, i.e. this could be named as ``rig-1-mouse-day1-camera-1.avi`` and ``rig-1-mouse-day1-camera-2.avi`` or could be ``rig-1-mouse-day1-camera-1-date.avi`` and ``rig-1-mouse-day1-camera-2-date.avi``.

- **Note** that to correctly pair the videos, the file names otherwise need to be the same!
- **Note** that the videos do not need to be the same pixel size, but be sure they are similar in size to the calibration images (and they must be the same cameras used for calibration).

 (**CRITICAL!**) You must also edit the **3D project config.yaml** file to denote which DeepLabCut projects have the information for the 2D views.

 - Of critical importance is that you need to input the **same** body part names as in the config.yaml file of the 2D project.
- You must set the snapshot to use inside the 2D config file (default is -1, namely the last training snapshot of the network).
- You need to set a "scorer 3D" name; this will point to the project file and be set in future 3D output file names.
- You **MUST** define a "skeleton" here as well. Not every point needs to be "skeletonized", i.e. these points can be a subset of the full body parts list. The other points will just be plotted into the 3D space. Here is how the config.yaml looks with some example inputs:

 <p align="center">
<img src="https://images.squarespace-cdn.com/content/v1/57f6d51c9f74566f55ecf271/1559756808766-2G6FG91S2I4ZX2SSP6QF/ke17ZwdGBToddI8pDm48kEULogWWASOhGi36VEr2SOlZw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZamWLI2zvYWH8K3-s_4yszcp2ryTI0HqTOaaUohrI8PIoI8wFyxyzDq4NO_A5fg6hgZUWi6FxVv9SjR8GkGxb-wKMshLAGzx4R3EDFOm1kBS/config3d.jpg?format=1000w" width="95%">
</p>

(**CRITICAL!**) This step will also run the equivalent of ``analyze_videos`` (in 2D) for you and then apply a median filter to the 2D data (``filterpredictions=True`` is by default)! If you already ran the 2D analysis and there is a filtered output file, it will take this by default (otherwise it will take your unfiltered 2D analysis files)!

Next, pass the ``config_path3d`` and now the video folder path, which is the path to the **folder** where all the videos from two cameras are stored. The triangulation can be done in deeplabcut by typing:

```python
deeplabcut.triangulate(config_path3d, '/yourcomputer/fullpath/videofolder', videotype = 'MP4',filterpredictions=True/False, save_as_csv=True/False)
```
NOTE: Windows users, you must input paths as: ``r`C:\Users\computername\videofolder' `` or ``C:\\Users\\computername\\videofolder'``.

The **triangulated file** is now saved under the same directory where the video files reside (or the destination folder you set)! This can be used for future analysis. This step can be run at anytime as you collect new videos, and easily added to your automated analysis pipeline, i.e. such as **replacing** ``deeplabcut.triangulate(config_path3d, video_path)`` with ``deeplabcut.analyze_videos`` (as if it's not analyzed in 2D already, this function will take care of it ;):

### (5) Visualize your 3D DeepLabCut Videos:

In order to visualize both the 2D videos with tracked points plut the pose in 3D, the user can create a 3D video for certain frames (these are large files, so we advise just looking at a subset of frames). The user can specify the config file, the **path of the triangulated file folder**, and specify the start and end frame indices to create a 3D labeled video. Note that the ``triangulated_file_folder`` is where the newly created file that ends with ``yourDLC_3D_scorername.h5`` is located. This can be done using:

```python
deeplabcut.create_labeled_video_3d(config_path, ['triangulated_file_folder'], videotype = 'MP4', start=50, end=250)
```

Keep all the videos in the triangulated_file_folder.

**TIP:** (see more parameters below) You can set how the axis of the 3D plot on the far right looks by changing the variables ``xlim``, ``ylim``, ``zlim`` and ``view``. Your checkerboard_3d.png image which was created above will show you the axis ranges. 

``View`` is used to set the elevation and azimuth of the axes (defaults are [113, 270], and you should play around to find the view-point you like!). Also note that the video is created from a set of .png files in a "temp" directory, so as soon as you run this command you can open the first image, and if you don't like the view, hit ``CNTRL+C`` to stop, edit the values, and start again!