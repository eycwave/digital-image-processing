%% 
clear all, close all; clc

% Step 1: Read the image and convert to grayscale
I = imread('cell.png'); % Replace with your image file name
if size(I, 3) == 3
    Igry = rgb2gray(I);
else
    Igry = I; % If already grayscale
end

% Step 2: Apply median filter to remove salt-and-pepper noise
Imed = medfilt2(Igry, [5, 5]);

% Step 3: Apply adaptive thresholding
Ibw = imbinarize(Imed, 'adaptive', 'Sensitivity', 0.35, 'ForegroundPolarity', 'dark');

% Step 4: Invert the binary image (black ↔ white)
Iinv = ~Ibw;

% Step 5: Clean
Ibw2 = bwareaopen(Iinv, 200);
Ibw3 = imfill(Ibw2, "holes");

% Step 6: Visualize the results
figure;
subplot(2, 3, 1), imshow(Igry, []), title('Grayscale Image');
subplot(2, 3, 2), imshow(Imed, []), title('After Median Filter');
subplot(2, 3, 3), imshow(Ibw, []), title('Adaptive Thresholding');
subplot(2, 3, 4), imshow(Iinv, []), title('Inverted Image');
subplot(2, 3, 5), imshow(Ibw2, []), title('Cleaned Image');
subplot(2, 3, 6), imshow(Ibw3, []), title('Filled Image');

