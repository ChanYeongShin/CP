## CP_project2 

#### Failure Reason

Because of limitation of my RAM SIZE, Large Scale Array cannot be calculated + So.. I cannot implement 'fft' idea & 'ifft'.. Instead, I upload the code that I used about './data/face.mp4'

### Q1. Initials and color transformation (5 pts)

```matlab
%% INITIALS AND COLOR TRANSFORMATION (5pts)

tic

Image_size = 512; % Limitations of RAM SIZE, Setting each frame power of two..

% Load video
video_path = './data/face.mp4';
v = VideoReader(video_path);

v_height = v.Height;
v_width = v.Width;

num_frames = v.NumberOfFrames;
v_fps = v.FrameRate;

v = VideoReader(video_path);
frames = zeros(num_frames, v_height, v_width, 3);

for i=1:num_frames
    % Read frame
    temp = readFrame(v);
    % Double-precision frame
    temp = double(temp);
    % Re-range to [0 1]
    temp = temp / 255.;
    % Color Space Transformation
    temp = rgb2ntsc(temp);
    frames(i, :, :, :) = temp;
end
toc
```

### Q2. Laplacian Pyramid (20pts)

```matlab
%% LAPLACIAN PYRAMID (20pts)

tic

Laplacian_level = 5;
sigma = 1;

another_pyramid = laplacian_pyramid((frames(1, :, :, :)), Laplacian_level, sigma);
ap_size = size(another_pyramid);
pyramid_frames = zeros(num_frames, ap_size(1), ap_size(2), ap_size(3));

for i=1:num_frames
    pyramid_frames(i, :, :, :) = laplacian_pyramid((frames(i, :, :, :)), Laplacian_level, sigma);
end

toc
```

### Q3. Temporal Filtering (20pts) + Q4. Extracting the freq band of interest (30pts)

```matlab
%% TEMPORAL FILTERING (30pts) + EXTRACTING THE FREQUENCY BAND OF INTEREST (30pts)
tic

% Fourier Transform params
Fs = v_fps;      
Ts = 1 / Fs;         
L = num_frames;      
t = (0:L - 1) * Ts;   

% FFT with zero padding
fft_num_frames = num_frames;
pad = 2 * fft_num_frames; % Modified num_frames
dummy_size = size(pyramid_frames);
fft_pyramid_frames = fft(pyramid_frames, pad, 1);

fft_pf_disp = fft_pyramid_frames(1:pad/2+1, :, :, :);
fft_pf_disp = fft_pf_disp / fft_num_frames;
fft_pf_disp(2:end-1, :, :, :) = 2 * fft_pf_disp(2:end-1, :, :, :);
freq = 0:Fs/pad:Fs/2;

toc

tic
% Add './src' path to utilize BWBPF
addpath('./src');

Hd = butterworthBandpassFilter(Fs, 256, 0.83, 1.0);
fftHd = freqz(Hd, fft_num_frames + 1);

% Multiplication params for each layer
alpha = [0 0 0 0 100];

alpha = alpha / sum(alpha) * 10;
total_dims = size(fft_pyramid_frames);
total_width = total_dims(3);
alpha_matrix = ones(Image_size, total_width, 3);
alpha_matrix(:, :, 1) = zeros(Image_size, total_width);

width_idx = 1;
ORIGINAL_LEVEL = nextpow2(Image_size);
for i=1:Laplacian_level
    new_width_idx = width_idx+pow2(ORIGINAL_LEVEL-i+1);
    alpha_matrix(:, width_idx:new_width_idx-1, :) = alpha(i) * alpha_matrix(:, width_idx:new_width_idx-1, :);
    width_idx = new_width_idx;
end

% Creating filter
fftHdFull = zeros(l_pad, 1);
fftHdFull(1:fft_num_frames+1) = fftHd;
fftHdFull(fft_num_frames+2:end) = fftHd(end-1:-1:2);

% Filtering
[drop, height, width, channel] = size(fft_pyramid_frames);
for c=1:channel
    for w=1:width
        for h=1:height
            fft_pyramid_frames(:, h, w, c) = ...
                fft_pyramid_frames(:, h, w, c) .* (1 + fftHdFull * alpha_matrix(h, w, c));
        end
    end
end

fft_pf_disp = fft_pyramid_frames(1:l_pad/2+1, :, :, :);
fft_pf_disp = fft_pf_disp / fft_num_frames;
fft_pf_disp(2:end-1, :, :, :) = 2 * fft_pf_disp(2:end-1, :, :, :);
freq = 0:Fs/l_pad:Fs/2;

toc
```

### Q5. Image Reconstruction (20pts)

```matlab

tic
%% IMAGE RECONSTRUCTION (20 pts)

% Inverse FFT
pyramid_frames = real(ifft(fft_pyramid_frames, l_pad, 1));

new_frames = zeros([num_frames, v_height v_width 3], 'uint8');
for i=1:num_frames
    % Reconstruct image
    temp = reconstruct((pyramid_frames(i, :, :, :)), Laplacian_level);
    temp = ntsc2rgb(temp);
    temp = temp * 255.;
    temp = uint8(temp);
    new_frames(i, :, :, :) = temp;
end
toc

tic
% Write video
v = VideoWriter('Result.avi');
open(v);
toc
```
