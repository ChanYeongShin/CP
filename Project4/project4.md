## Assignment 4

### Post-Processing : CONVERT .NEF FILE INTO .TIFF FILE

I convert '.nef file' into '.tiff file' by using dcraw.exe

![Alt text](./Figure/dcraw.png)

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

I use linear regression each types(uniform linear, logarithmic + tent linear, logarithmic + gaussian linear, logarithmic).

```matlab

% Linear regression
e = 0;
figure;
for idx_weight=1:3
    for idx_merge=1:2
        e = e + 1;
        X = ones(6, 2);
        y = zeros(6, 1);
        for i=1:6
            intensity(idx_weight, idx_merge, i) = log(mean(mean(mean(image_stack{idx_weight, idx_merge}(position(i, 2):position(i, 4), position(i, 3):position(i, 1), 2)))));
 
            y(i, 1) = intensity(idx_weight, idx_merge, i);
            X(i, 2) = i;
        end
        % Linear regression solver
        b = X \ y;
        yCalc = X * b;
        
        subplot(3, 2, e);
        plot(X(:, 2), yCalc);
        hold on;
        scatter(X(:, 2), y);
        hold off;
        title(sprintf('%s %s', weight_type{idx_weight}, merge_type{idx_merge});
    end
end
```
**Results**

![Alt text](./Figure/linear_regression.jpg)

### Question 4. PHOTOGRAPHIC TONEMAPPING (20pts)

Given equation which is shown below, I got two photographic tonemapped images(RGB colorspace, xyY colorspace).

![Alt text](./Figure/formula_q3.png)

**Results**

**RGB channel space**
![Alt text](./Figure/photo_rgb.png)
**xyY channel space**
![Alt text](./Figure/photo_xyY.png)

In my view, photo RGB space gives cool feeling and photo xyY gives warm feeling. 

### Question 5. TONEMAPPING USING BILITERAL FILTERING (30pts)

By using bilateral filter, it makes image edge clear. But I think using this method, it looks more bad in shapeness.

**Results**

**RGB channel space**
![Alt text](./Figure/bilateral_rgb.png)
**xyY channel space**
![Alt text](./Figure/bilateral_xyY.png)
