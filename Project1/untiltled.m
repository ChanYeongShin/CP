close all;
clc; clear all;
img = imread('banana_slug.tiff');
figure, imshow(img);
title('Original');

%% Question 1
img_size = size(img);
img_type = class(img);
fprintf('------------INITIALS-------------\n');
fprintf('Image size: %d x %d\n', img_size(1), img_size(2));
fprintf('Image Class: %s \n', img_type);
fprintf(' \n');
img = cast(img, 'double');

%% Question 2

img = (img - 2047) / 12953; % 15000-2047=12953
M = max(max(img));
m = min(min(img));

disp('---------LINEARIZATION-----------');
fprintf('Max: %.3f\n', M);
fprintf('Min: %.3f\n', m);

disp('* After Clipping');
img(img > 1) = 1;
img(img < 0) = 0;
M = max(max(img));
m = min(min(img));
fprintf('Max: %.3f\n', M);
fprintf('Min: %.3f\n', m);
fprintf(' \n');

%% Question 3

disp('-------IDENTIFYING PATTERN-------');
figure;

% grbg pattern
R = [1 2]; G = [1 1]; B = [2 1];
r = img(R(1):2:end, R(2):2:end);
g = img(G(1):2:end, G(2):2:end);
b = img(B(1):2:end, B(2):2:end);
img_rgb = cat(3, r/max(max(r)), g/max(max(g)), b/max(max(b)));
subplot(2, 2, 1), imshow(min(1, img_rgb * 5));
title('GRBG');

% rggb pattern
R = [1 1]; G = [1 2]; B = [2 2];
r = img(R(1):2:end, R(2):2:end);
g = img(G(1):2:end, G(2):2:end);
b = img(B(1):2:end, B(2):2:end);
img_rgb = cat(3, r/max(max(r)), g/max(max(g)), b/max(max(b)));
subplot(2, 2, 2), imshow(min(1, img_rgb * 5));
title('RGGB');

% bggr pattern
R = [2 2]; G = [1 2]; B = [1 1];
r = img(R(1):2:end, R(2):2:end);
g = img(G(1):2:end, G(2):2:end);
b = img(B(1):2:end, B(2):2:end);
img_rgb = cat(3, r/max(max(r)), g/max(max(g)), b/max(max(b)));
subplot(2, 2, 3), imshow(min(1, img_rgb * 5));
title('BGGR');

% gbrg pattern
R = [2 1]; G = [1 1]; B = [1 2];
r = img(R(1):2:end, R(2):2:end);
g = img(G(1):2:end, G(2):2:end);
b = img(B(1):2:end, B(2):2:end);
img_rgb = cat(3, r/max(max(r)), g/max(max(g)), b/max(max(b)));
subplot(2, 2, 4), imshow(min(1, img_rgb * 5));
title('GBRG');

disp('Correct Bayer Pattern: RGGB');
fprintf('\n');

%% Question 4
figure;
R = [1 1]; G_1 = [2 1]; G_2 = [1 2]; B = [2 2];
r = img(R(1):2:end, R(2):2:end);
g1 = img(G_1(1):2:end, G_1(2):2:end);
g2 = img(G_2(1):2:end, G_2(2):2:end);
b = img(B(1):2:end, B(2):2:end);

disp('--------WHITE BALANCING----------');
fprintf('\n');

% White world assumption
r = r / max(max(r));
g1 = g1 / max(max(max(g1)), max(max(g2)));
g2 = g2 / max(max(max(g1)), max(max(g2)));
b = b / max(max(b));
img_rgb = cat(3, r, (g1 + g2) / 2, b);
subplot(2, 2, 1), imshow(img_rgb);
title('White World Assumption');
subplot(2, 2, 3), imshow(min(1, img_rgb * 5));

% Gray world assumption
r_avg = mean(mean(r));
g_avg = (mean(mean(g1)) + mean(mean(g2))) / 2;
b_avg = mean(mean(b));

r = r / r_avg * g_avg;
b = b / b_avg * g_avg;
img_rgb = cat(3, r, (g1 + g2) / 2, b);
subplot(2, 2, 2), imshow(img_rgb);
title('Gray World Assumption');
subplot(2, 2, 4), imshow(min(1, img_rgb * 5));

%% Question 5

disp('----------DEMOSAICING------------');
fprintf('\n');

interp_r = interp2(r, 2);
interp_g = interp2((g1+g2)/2, 2);
interp_b = interp2(b, 2);

img_rgb = cat(3, interp_r, interp_g, interp_b);
figure, imshow(img_rgb);
title('Demosaicing');

%% Question 6

disp('-------BRIGHTNESS ADJUSTMENT-------');
fprintf('\n');

disp('---------GAMMA CORRECTION----------');

figure;
max_gray = max(max(rgb2gray(img_rgb)));
for i=0:3
    %Bright Adjustment
    img_bright = img_rgb * (1+i*0.01);
    adj_max_gray = max(max(rgb2gray(img_bright)));

     % Gamma correction
    temp = (1 + 0.055) * power(img_bright, 1/2.4) - 0.055;
    img_bright(img_bright >= 0.0031308) = temp(img_bright >= 0.0031308);
    temp = 12.92 * img_bright;
    img_bright(img_bright < 0.0031308) = temp(img_bright < 0.0031308);

    subplot(2, 2, i+1);
    imshow(img_bright);
    title(sprintf('Bright: %.1f%%', adj_max_gray / max_gray * 100));
end

%% Question 7

disp('------------COMPRESSION------------');

imwrite(img_bright, 'result 1.png');
imwrite(img_bright, 'result 2.jpg', 'Quality', 95);
disp(imfinfo('result 1.png'));
disp(imfinfo('result 2.jpg'));
