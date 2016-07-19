# A Dual-Source Approach for 3D Pose Estimation from a Single Image  

# Introduction

The code package provides a tool for estimating 3D human pose from a 
single image. If you use this code for research purposes, please cite 
the following paper in any resulting publication:

**Hashim Yasin, Umar Iqbal, Björn Krüger, Andreas Weber, Juergen Gall**  
A Dual-Source Approach for 3D Pose Estimation from a Single Image  
IEEE Conference on Computer Vision and Pattern Recognition (CVPR) 2016.  

For more information visit http://pages.iai.uni-bonn.de/iqbal_umar/ds3dpose/

The code is tested on Ubuntu 14.04 (64bit) with MATLAB (2016a).

#Instructions

1. PROVIDED  
    Within this Release, we provide  
    * the pre-normalized 3D pose database for Human3.6M  
    * pre-trained random forests for 2D pose estimation  

2. REQUIREMENTS  
  2.1. LIBRARIES  

  * OpenCV  
  * Boost-1.55  
  * Gflags  
  * GLog compiled with Gflags  
  
  If the libraries are installed locally, please set 'CUSTOM_LIBRARY_PATH' in '../MEX/src/CMakeLists.txt' to your 
  corresponding directory containing the glog, gflags folders. In '../MEX/src/cmake/Modules' scripts are provied to find your local glog and gflags installation.  
  
  Also please make sure that all local libraries are specified in your LD_LIBRARY_PATH and in your PATH variables.

  2.2. TOOLBOXES  
    Matlab's optimization toolbox.

  2.3. DATASET  
    Please get the Human36M Dataset and extract it to '../Human36M/code-v1.1/Release-v1.1' or any other location. If Human36M is located somewhere else, the path has to be adapted. See 6. for more information.

3. Switch to the 'code' folder to run any function. 

4. COMPILATION  
    To compile and install the binaries, please run 'installBinaries.m'. This script automatically runs cmake to build the neccecasry C++ implementations. For some Matlab installations, this results in some undefined reference errors. In that case, please switch to '../MEX/src/build' and run the following commands manually from your terminal

      * $ cmake -G "Unix Makefiles"
      * $ make;
      

5. CONFIGURATION  
5.1. Adjust Parameters
Open 'Initialize.m' located in the 'code' folder.
    Line 9:   
      If necessary, adjust the path for the Human36M code
    
    Line 16 and following:  
      In some cases, matlab has problems executing the binaries, because there are conflicts with matlab's provided openCV   libraries. If this is the case, please adjust the 'OPENCV_LIBRARY_PATH' and the 'OPENCV_INCLUDE_PATH' 
    
    Line 48 and following:  
      Adapt configuration parameters for pose estimation like location of ground truth files or save paths for (temporary) estimation results:  
  
    TDPose_ConfigPath:  
        /some/location/3D_Pose_Estimation/MEX/src/regressors  
    TDPose_ExperimentName:  
        Folder contained in TDPose_ConfigPath  
    TDPose_TestImageLocation:  
        Path, where the test image are located  
    TDPose_NTrees:  
        Number of trees that are used in each forest  
    TDPose_TrainFile:  
        Path to the train annotation file for the dataset  
    TDPose_TmpFileSavePath:  
        Path where to save temporary data  
    TDPose_TmpSaveResults:  
        Path where to save (temporary) results  
    TDPose_VisualizeResults:  
         1, if results should be visualized  
    TDPose_PauseAfterResult:  
        1, if estimation should be paused  
    TDPose_DeleteFilesAfterEstimation:  
        delete all estimation files  

  Line 85:  
       You can specify, how many iterations you want to perform.  

6. RUNNING THE CODE  

  You can either call 'RUN_Complete.m' to perform 3D Pose Estimation onthe whole dataset once or call 'RUN_Iterated.m' to performe 3D Pose Estimation	for each single image of the dataset.  

	Ideally the approach requires roughly 100GBs of RAM to load 3D pose databases for the retrievel of K-NNs. However, in this release we have modified the code to fit in 32GBs of RAM. Therefore, the run-time will be different as compared to  the one reported in the paper.  


7. FUTURE RELEASE  
    In the future we will also add support for HumanEva dataset

## Citing
```
@inproceedings{Yasin_Iqbal_CVPR2016,
	author = {Hashim Yasin, Umar Iqbal, Björn Krüger, Andreas Weber, Juergen Gall},
	title = {A Dual-Source Approach for 3D Pose Estimation from a Single Image},
	booktitle = {IEEE Conference on Computer Vision and Pattern Recognition (CVPR)},
	year = {2016},
	url = {http://arxiv.org/abs/1509.06720}
}
```
