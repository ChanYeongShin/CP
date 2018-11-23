## Assignment 4

### Post-Processing : CONVERT .NEF FILE INTO .TIFF FILE

I convert '.nef file' into '.tiff file' by using dcraw.exe

### Question 1. LINEARIZED RENDERED IMAGE (25pts)

This work is to linearize the rendered image which is non-linear. To achieve my goal , I have to solve least squares optimization problem.

![Alt text](./Figure/formula_q1.png)

I choose 'lambda = 1000' for strict smoothing and Result part shows each 'g' curve using uniform, tent, gaussian weight scheme for each color channels, respectively. weighting type image which this project uses is shown below.

![Alt text](./Figure/formula2_q2.png)


**Results**

![Alt text](./Figure/G_curve_uniform.jpg)

![Alt text](./Figure/G_curve_tent.jpg)

![Alt text](./Figure/G_curve_gaussian.jpg)

As you see, 'g' curve using tent and gaussian is more smoother than uniform weighting type.

### Question 2. MERGE EXPOSURE STACK INTO HDR IMAGE (15pts)

I merge exposure stack into HDR IMAGE each with two 'file_type : Rendered, Raw', 'weight_type : uniform, tent, gaussian', 'merge_type : logarithmic, linear'. The image is shown below.

**Results**




### Question 3. EVALUATION (10pts)




**Results**




### Question 4. PHOTOGRAPHIC TONEMAPPING (20pts)

**Results**



### Question 5. TONEMAPPING USING BILITERAL FILTERING (30pts)

**Results**

