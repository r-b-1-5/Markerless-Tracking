**DISCLAIMER**: We extract and label the frames after creating the project in the local computer. For training the model with GPU, Google Colab is used.
* First enter into the ipython terminal and import deeplabcut using the commands:
Run: ipython
Then, Run: import deeplabcut
* To create a new project directory,
Run:
config_path= deeplabcut.create_new_project(‘Name of the project’, ‘Name of the experimenter’, [r’Full path of video 1’, r’Full path of video 2’], working_directory=r’Full path of the working directory’, copy_videos=True, multianimal=False)
This stores the full path to the configuration file of the project in the config_path variable.
* This set of arguments will create a project directory with the name Name of the project+name of the experimenter+date of creation of the project in the Working directory.
* For more details on creating a new project, go to this link: [Link](https://github.com/DeepLabCut/DeepLabCut/blob/master/docs/standardDeepLabCut_UserGuide.md#a-create-a-new-project)
* The Task, scorer, date should not be changed in the config.yaml file throughout the process. Edit the file to add the list of bodyparts (or points of interest) that you want to track.
![Config File](https://miro.medium.com/max/1138/1*VWvOzmWRt9KrBdXkEdX3ng.png)
* The next step is extracting frames. To do so,
Run: deeplabcut.extract_frames(config_path, ‘automatic’, ‘kmeans’)
* For more details on extracting frames, go to this link: [Link](https://github.com/DeepLabCut/DeepLabCut/blob/master/docs/standardDeepLabCut_UserGuide.md#c-data-selection-extract-frames)
* Labelling the frames manually is the next step.
Run: deeplabcut.label_frames(config_path)
* IN CASE YOU ENCOUNTER THE ERRORS :
wxAssertionError (OR)
AttributeError: ‘MainFrame’ object has no attribute ‘rdb’
WHILE TYPING THE COMMAND,
Run: import locale
Then, Run: locale.setlocale(locale.LC_ALL, ‘C’)
Then, type the command in the previous comment.
* The user needs to use the Load Frames button to select the directory which stores the extracted frames from one of the videos. Subsequently, the user can use one of the radio buttons (top right) to select a body part to label. RIGHT click to add the label. Left click to drag the label, if needed. If you label a part accidentally, you can use the middle button on your mouse to delete! If you cannot see a body part in the frame, skip over the label! Please see the HELP button for more user instructions. This auto-advances once you labeled the first body part. You can also advance to the next frame by clicking on the RIGHT arrow on your keyboard (and go to a previous frame with LEFT arrow). Each label will be plotted as a dot in a unique color.
* For more details on labelling frames, go to this link: [Link](https://github.com/DeepLabCut/DeepLabCut/blob/master/docs/standardDeepLabCut_UserGuide.md#d-label-frames)
* To check that the labelling is done correctly,
Run: deeplabcut.check_labels(config_path, visualizeindividuals=True)
* For each video directory in labeled-data directory this function creates a subdirectory with labeled as a suffix. Those directories contain the frames plotted with the annotated body parts. The user can double check if the body parts are labeled correctly. If they are not correct, the user can reload the frames (i.e. deeplabcut.label_frames), move them around, and click save again.


The other part of the training will be done in Google Colab, where we use the GPU for training the Deep Learning model.