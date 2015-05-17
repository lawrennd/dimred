Matlab Dimensional Reduction Demos
==================================

RELEASEINFORMATION Third release in line with Interspeech Tutorial.
#### Release 0.11

Second release in line with ICML tutorial.
#### Release 0.1

First release in line with Datamodelling School Talk. The scripts to run are given in the slides for the lecture.
### Examples

#### Speech Synthesis

The synthesis examples are tested only on a Linux machine and they require the SYNTH toolbox (linked to above).
`>> demPpcaCmp1`

runs PCA on the means. PCA on the durations can also be run with demPpcaDur1. Files for running the GPLVM are demFgplvmCmp1 and demFgplvmCmp2. The second uses a mix of lengthscales.

#### Sixes Data

The rotation of the sixes example can be recreated using

`>> demManifold`

The projection of the sixes on to their first two principal components is given below.

![](demManifoldPrint1.png)
 *Left*: Visualisation of the rotated sixes onto the first two principal components. .
#### Oil Data

The results for the oil data with the density network can be recovered using `demOilDnet4` and `demOilDnet5`. They 100 samples and 400 samples respectively. Results are shown below.

![](demOilDnet4.png)![](demOilDnet5.png)
 *Left*: Visualisation of oil data with density networks and 100 samples from the latent distribution, `demOilDnet4`. Nearest neighbour classification in the latent space leads to 22 errors. *Right*: Visualisation of oil data with density network and 400 samples from the latent distribution, `demOilDnet5`. Nearest neighbour classification in the latent space leads to 16 errors.
The results for the oil data with the GTM can be recovered using `demOilDnet1`, `demOilDnet2` and `demOilDnet3`. They used grids of 10x10, 20x20 and 30x30 respectively. Results for 10x10 and 30x30 grids are shown below.

![](demOilDnet1.png)![](demOilDnet3.png)
 *Left*: Visualisation of oil data with GTM and a 10x10 grid, `demOilDnet1`. Nearest neighbour classification in the latent space leads to 74 errors. *Right*: Visualisation of oil data with GTM and a 30x30 grid, `demOilDnet3`. Nearest neighbour classification in the latent space leads to 11 errors.
#### Stick Man Data

The results for the stick man data with the GTM can be recovered using `demStickDnet1`, `demStickDnet2` and `demStickDnet3`. They used grids of 10x10, 20x20 and 30x30 respectively. Results for 10x10 and 30x30 grids are shown below.

![](demStickDnet1.png)![](demStickDnet3.png)
 *Left*: Visualisation of stick data with GTM and a 10x10 grid, `demStickDnet1`. *Right*: Visualisation of stick data with GTM and a 30x30 grid, `demStickDnet3`.
### EPSRC Datamodelling Winter School School

#### Road Data

This example shows visualisation of inter city road distances projected onto an actual map of Europe using Procrustes rotation.

`>> demCmdsRoadData`

![](demCmdsRoadData1.png)![](demCmdsRoadData2.png)
 *Left*: Visualisation of cities from the road data compared to their actual positions in europe. *Right*: some of the eigenvalues from the distance matrix for the data are negative.

