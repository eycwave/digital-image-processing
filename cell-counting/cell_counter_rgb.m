clear all, close all; clc

I = imread('cell.png'); 

[Nx, My, D] = size(I);
I_mat = reshape(I, Nx*My, 3);

[ID, Ct] = kmeans(double(I_mat), 2);

I_kmn = reshape(ID, Nx, My, []);
B1 = labeloverlay(I, I_kmn);

Ibw = I_kmn == 2;
Ibw2 = bwareaopen(Ibw, 200);

Ibw3 = imfill(Ibw2, "holes");

se = strel('disk', 7);
Ibw4 = imopen(Ibw3, se);

B2 = labeloverlay(I, Ibw4);

figure,
subplot(3,3,1), imshow(I,[]), title('Original Image');
subplot(3,3,2), imshow(B1,[]), title('Overlayed Kmeans');
subplot(3,3,3), imshow(Ibw,[]), title('Ibw');
subplot(3,3,4), imshow(Ibw2, []), title('Ibw2 (bwareaopen)');
subplot(3,3,5), imshow(Ibw3, []), title('Ibw3 (imfill)');
subplot(3,3,6), imshow(Ibw4, []), title('Ibw4 (imopen)');
subplot(3,3,7), imshow(B2, []), title('Overlayed Final');
