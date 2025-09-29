clear all, close all; clc

I = imread('car.png');
Igry = rgb2gray(I);
Imed = medfilt2(Igry, [5,5]);

tresh = 0.2;
I_edg_med = edge(Imed, 'canny', tresh);

% Dilation after Canny edge detection
se_dilate = strel('rectangle', [1,2]); % Define structuring element (disk with radius 1)
I_dilated = imdilate(I_edg_med, se_dilate); % Apply dilation

I_fill = imfill(I_dilated, 'holes');

h = ones(40,100); 
se = strel(h);
I_cls = imopen(I_fill, se);

I_bwo = bwareaopen(I_cls, 20);

B = labeloverlay(I, I_bwo);

% Create a single figure with four subplots
figure;
subplot(2, 2, 1), imshow(I_edg_med, []), title('Edges');
subplot(2, 2, 2), imshow(I_dilated, []), title('Dilated Edges');
subplot(2, 2, 3), imshow(I_bwo, []), title('Processed Image');
subplot(2, 2, 4), imshow(B, []), title('Overlay');
