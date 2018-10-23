clear all;
close all; clc;

addpath('./src')

%% POISSON BLENDING (50pts)

disp('----------POISSON BLENDING-----------');

tic

im_background = imresize(im2double(imread('./data/sky.jpg')), 0.5, 'bilinear');
im_object = imresize(im2double(imread('./data/bird.jpg')), 0.5, 'bilinear');

% get source region mask from the user each
objmask = getMask(im_object);

% align im_s and mask_s with im_background & im_t
[im_s, mask_s] = alignSource(im_object, objmask, im_background);
 
% blend
im_blend = poissonBlend(im_s, mask_s, im_background);

figure(3), hold off, imshow(im_blend);

toc

 %% BLENDING WITH MIXED GRADIENTS (10pts)

disp('----------MIXED BLENDING-----------');

tic

% blend
im2_blend = mixedBlend(im_s, mask_s, im_background);

figure(5), hold off, imshow(im2_blend);

toc