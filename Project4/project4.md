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

**uniform, raw, linear**
![Alt text](./Figure/uniform_raw_linear.jpg)
**uniform, raw, logarithmic**
![Alt text](./Figure/uniform_raw_logarithmic.jpg)
**uniform, rendered, linear**
![Alt text](./Figure/uniform_rendered_linear.jpg)
**uniform, rendered, logarithmic**
![Alt text](./Figure/uniform_rendered_logarithmic.jpg)
**tent, raw, linear**
![Alt text](./Figure/tent_raw_linear.jpg)
**tent, raw, logarithmic**
![Alt text](./Figure/tent_raw_logarithmic.jpg)
**tent, rendered, linear**
![Alt text](./Figure/tent_rendered_linear.jpg)
**tent, rendered, logarithmic**
![Alt text](./Figure/tent_rendered_logarithmic.jpg)
**gaussian, raw, linear**
![Alt text](./Figure/gaussian_raw_linear.jpg)
**gaussian, raw, logarithmic**
![Alt text](./Figure/gaussian_raw_logarithmic.jpg)
**gaussian, rendered, linear**
![Alt text](./Figure/gaussian_rendered_linear.jpg)
**gaussian, rendered, logarithmic**
![Alt text](./Figure/gaussian_rendered_logarithmic.jpg)

As you see, in uniform weighting cases, Raw image is better thatn Rendered image. However, in weighting type tent and gaussian cases, especially, 'rendered image + logarithmic merge type' is much better than 'rendered image + linear merge type' in my view.

### Question 3. EVALUATION (10pts)




**Results**




### Question 4. PHOTOGRAPHIC TONEMAPPING (20pts)

**Results**



### Question 5. TONEMAPPING USING BILITERAL FILTERING (30pts)

**Results**

