# Lighting transfer across multiple views through local color transforms

![](https://github.com/qianzhanginfo/relight-scenes/raw/master/teaser.png "Paper Teaser")

MATLAB code for the CVM paper [Lighting transfer across multiple views through local color transforms](https://link.springer.com/article/10.1007/s41095-017-0085-5).

Tested on Ubuntu 18.04.1 LTS with MATLAB R2018b. Change directory to ```/src```, run in MATLAB:
```
>> main
```

## Demo I/Os
For the lighting transfer demo, we provide as inputs:
```
- an image pair: source (to be edited), target (with desired lighting)
- visible 3D points in the reconstructed point cloud
- estimated camera matrices
```
Data source: [[Laffont et al. 12]](http://www-sop.inria.fr/reves/Basilic/2012/LBPDD12/).
We DO NOT claim copyrights of these inputs. Please DO NOT re-distribute without further agreement.

The outputs include:
```
- output_ours: a relit image obtained by propagating local color transforms
- output_warped_target: a naive homography warping of the target image
- output_propagated_color: a naive color propagation of the target pixel correspondences
```

## How to use your own photos
We use off-the-shelf software VisualSfM [[Wu 2011]](http://ccwu.me/vsfm/), which first applies structure from motion [Wu et al. 2011] to estimate the parameters of cameras and then uses patch-based multi-view stereo (pmvs) [Furukawa and Ponce 2010] to generate a 3D point cloud of the scene. 

Follow the instructions on the software website to run on your own **photo collection**. Note that you may want to modify the [```option```](https://www.di.ens.fr/pmvs/documentation.html) file to specify the timages. The software tries to reconstruct 3D points until image projections of these points cover all the target images.

Please copy the pmvs result folder under 
```/src```. The ```demo_data``` folder is set to the same folder structure for your reference:
```
.
├── ...
├── src
│   ├── demo_data
│       ├── models          
│           ├── option-custom.patch
|           └── ...
│       ├── txt             
│       ├── visualize       
│       └── ...
│   └── ...   
└── ...
```
Change the following lines of code:

main.m:
```
line 24| folder_name = 'your_data_folder';
```

load_3d_points.m
```
line  4| mode = 'pmvs';
line 13| filepath = fullfile(folder_name, 'models', 'your_custom_option.patch');
```

## Citation
Please cite the paper if you used this code for research:

```
@article{zhang2017lighting,
  title={Lighting transfer across multiple views through local color transforms},
  author={Zhang, Qian and Laffont, Pierre-Yves and Sim, Terence},
  journal={Computational Visual Media},
  volume={3},
  number={4},
  pages={315--324},
  year={2017},
  publisher={Springer}
}
```

## Contact
qian_zhang AT brown DOT edu, if you have any questions.