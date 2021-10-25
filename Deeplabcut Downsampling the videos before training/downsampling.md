For deeplabcut, it is always desirable to downsample the original video for better results.

* First enter into the ipython terminal and import deeplabcut using the commands:
```python
Run: ipython
```
```python
Run: import deeplabcut
```

* 
```python
Run: downsampledvideoname=deeplabcut.DownSampleVideo('**PATH TO THE VIDEO**', width=360,height=640,outsuffix='cropped')
```
This command downsamples the video to a width of 360 and height of 640 and saves it in the video folder as {videoname}cropped.avi

* To learn more about the function, in the ipython terminal, after importing deeplabcut
```python
Run: help(deeplabcut.DownSampleVideo)
```

![Image](https://miro.medium.com/max/1138/1*b-jsx5S_3qbIHNjlL3ZXXQ.png)