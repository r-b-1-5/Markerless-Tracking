**INSTALLING DEEPLABCUT** iN YOUR PC:

* First install [Anaconda](http://anaconda.com/distribution) on your PC (from the hyperlink).
* Now open Anaconda Prompt.
* Change the directory in the prompt using suitable commands to go to the directory where you intend to download DeepLabCut.
```
(Run: cd {dir_name} → to change to a particular directory
Run: mkdir {dir_name} → to create a new directory)
```
![Creating a new directory and changing to it](https://miro.medium.com/max/689/1*zLs8GhDDa1m_KEEhGUPKew.png)
* Now, clone DeepLabCut using the following command into your PC.
```
Run: git clone https://github.com/DeepLabCut/DeepLabCut.git
```
* Go to the folder named conda-environments present in the DeepLabCut directory that was cloned in the previous step and copy its path.

![Copying the path to the conda-environments directory](https://miro.medium.com/max/1138/1*8PLJK-x7CGiaTOu16j0Jtw.png)
* Then, 
```
Run: conda env create -f DEEPLABCUT.yaml
```
This command may take some time to set up the environment.
* Next, 
```
Run: activate DEEPLABCUT
```
This command will change to the environment that we created with the command before.
* (OPTIONAL) To upgrade DeepLabCut,
run the following command inside your env in Anaconda:
```
Run: pip install — upgrade deeplabcut
```
* Then, 
``` 
Run: ipython
```
This command enters you into the python shell, where you can work with the python commands (including those specific to deeplabcut.)
* Next, 
```
Run: import deeplabcut
```
This imports the deeplabcut package. Now we can test the various functionalities of DeepLabCut.
* FOR OTHER DETAILS ON THE INSTALLATION PROCESS, FOLLOW THIS LINK: [Link](https://github.com/DeepLabCut/DeepLabCut/blob/master/docs/installation.md)