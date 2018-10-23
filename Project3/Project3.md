## Assignment 3
### Question 1. Toy Problem(20pts)

```matlab
%% TOY PROBLEM(20pts)

% Adding src path 
addpath('./src'); 

 disp('-----------------TOY-----------------');
 
 tic
 
 img = imread('./data/toy_problem.png');
 figure(), subplot(1,2,1), imshow(img);
 
 img2 = toy_example('./data/toy_problem.png');
 subplot(1,2,2), imshow(img2);
 fprintf('\n');
 
 toc
```

**Results**
```
![Alt text](/Figure/figure1.png)
```

### Question 2. POISSION BLENDING (50pts)
```matlab
%% POISSON BLENDING (50pts)

disp('----------POISSON BLENDING-----------');

tic

im_background = imresize(im2double(imread('./data/hiking.jpg')), 0.5, 'bilinear');
im_object = imresize(im2double(imread('./data/penguin-chick.jpeg')), 0.5, 'bilinear');
im2_object = imresize(im2double(imread('./data/penguin.jpg')), 0.5, 'bilinear');

% get source region mask from the user each
objmask = getMask(im_object);
objmask2 = getMask(im2_object);
% align im_s and mask_s with im_background & im_t
[im_s, mask_s, im_t] = alignSource(im_object, objmask, im_background);
[im_s2, mask_s2, im_t] = alignSource(im2_object, objmask2, im_t);

% blend
im_blend = poissonBlend(im_s, mask_s, im_background);
im2_blend = poissonBlend(im_s2, mask_s2, im_blend);
figure(5), hold off, imshow(im_blend);
figure(6), hold off, imshow(im2_blend);

toc
```

**Results**
```

```

### Question 3. BLEDNING WITH MIXED GRADIENTS (10pts)
```matlab

```


**Results**
```
```

### Question 4. MY OWN EXAMPLES (20pts)

**Results**


