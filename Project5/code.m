clc;
clear all;

%% Q1. Initials(5pts) & Q2. Sub-aperture views(20pts)

tic
img_plenoptic = imread('data/chessboard_lightfield.png');
lightfield = zeros(16, 16, 400, 700, 3);
for x = 1:400
    for y = 1:700
        for i = 1:16
            for j = 1:16
                for c = 1:3
                    lightfield(i, j, x, y, c) = double(img_plenoptic((x-1)*16+i, (y-1)*16+j, c)) / 256;
                end
            end
        end
    end
end
img_mosaic = zeros(6400, 11200, 3);
for i = 1:16
    for j = 1:16
        img_mosaic((i-1)*400+1 : (i-1)*400+400, (j-1)*700+1 : (j-1)*700+700, :) = lightfield(i, j, :, :, :);
    end
end
imwrite(img_plenoptic, 'img_plenoptic.png');
imwrite(img_mosaic, 'img_mosaic.png');
toc

%% Q3. Refocusing and focal-stack generation(40pts)

tic
img_depth = {};
for d = 0:0.2:2
    img = zeros(400, 700, 3);
    for x = 1:400
        for y = 1:700
            sum = 0;
            for i = -7:8
                for j = -7:8
                    new_x = round(x + i * d);
                    new_y = round(y - j * d);
                    if new_x >=1 && new_x <=400 && new_y >=1 && new_y <=700 % for new_x & new_y re-ranging
                    for c = 1:3
                        img(x, y, c) = img(x, y, c) + lightfield(i+8,j+8,new_x,new_y,c);
                    end
                    sum = sum + 1;
                    end
                end
            end
            img(x, y, :) = img(x, y, :) / sum;
        end
    end
    imwrite(img, strcat('img_depth_',num2str(d),'.png'));
    img_depth{end + 1} = img;
end
toc

%% Q4. All-focus image and depth from defocus (35pts)

tic
img_lum = {};
img_low = {};
img_high = {};
img_sharp = {};
for d = 1:11
    % Get luminance
    img_lum{end + 1} = rgb2xyz(img_depth{d}, 'ColorSpace', 'srgb');
    img_lum{end} = img_lum{end}(:, :, 2);
    % Get low frequency
    img_low{end + 1} = imgaussfilt(img_lum{end}, 2.5);
    % Get high frequency
    img_high{end + 1} = img_lum{end} - img_low{end};
    % Get sharpness
    img_sharp{end + 1} = imgaussfilt(img_high{end} .^ 2, 4);
end
img_all_focus = zeros(400, 700, 3);
img_depth_gray = zeros(400, 700);
 for x = 1:400
     for y = 1:700
        w = 0;
        for d = 1:11
            for c = 1:3
                img_all_focus(x, y, c) = img_all_focus(x, y, c) + img_depth{d}(x, y, c) * img_sharp{d}(x, y);
            end
            img_depth_gray(x, y) = img_depth_gray(x, y) + d * img_sharp{d}(x, y);
            w = w + img_sharp{d}(x, y);
        end
        img_all_focus(x, y, :) = img_all_focus(x, y, :) / w;
        img_depth_gray(x, y) = img_depth_gray(x, y) / w;
     end
 end
imwrite(img_all_focus, 'img_all_focus.png'); 
imwrite(1. - img_depth_gray / d, 'img_depth.png');

toc
