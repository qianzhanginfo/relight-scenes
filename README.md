# Lighting transfer across multiple views through local color transforms

![](https://github.com/qianzhanginfo/relight-scenes/raw/master/teaser.png "Paper Teaser")

MATLAB code for the CVM paper [Lighting transfer across multiple views through local color transforms](https://link.springer.com/article/10.1007/s41095-017-0085-5).

Tested on Ubuntu 18.04.1 LTS with MATLAB R2018b. Change directory to ```/src```, run in MATLAB:
```
>> main
```

## Input and Output
For the lighting transfer demo, we provide as inputs:
```
- an image pair: source (to be edited), target (with desired lighting)
- visible 3D points in the reconstructed point cloud
- estimated camera matrices
```
Data source: [Laffont 12](http://www-sop.inria.fr/reves/Basilic/2012/LBPDD12/).
We DO NOT claim copyrights of these inputs. Please DO NOT re-distribute without further agreement.

The outputs include:
```
- output_ours: a relit image obtained by propagating local color transforms
- output_warped_target: a naive homography warping of the target image
- output_propagated_color: a naive color propagation of the target pixel correspondences
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

06/09/2019