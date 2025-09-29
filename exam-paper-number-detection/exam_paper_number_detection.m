clear all, close all; clc
% Step 1: Read the image and convert to grayscale
I = imread('exam_paper.png'); % Replace with your image file name
if size(I, 3) == 3
    Igry = rgb2gray(I);
else
    Igry = I; % If already grayscale
end
% Step 2: Apply median filter to remove salt-and-pepper noise
Imed = medfilt2(Igry, [5, 5]);
% Step 3: Apply adaptive thresholding
Ibw = imbinarize(Imed, 'adaptive', 'Sensitivity', 0.5, 'ForegroundPolarity', 'dark');
% Step 4: Fill holes using imfill
Ifill = imfill(Ibw, 'holes');

% Step 5: Find number row using horizontal profile
horizontal_profile = sum(~Ifill, 2);
threshold = max(horizontal_profile) * 0.3;
potential_rows = find(horizontal_profile > threshold);

if ~isempty(potential_rows)
    % Define number row region with margin
    number_row_center = potential_rows(1);
    margin = 50;
    number_row_start = max(1, number_row_center - margin);
    number_row_end = min(size(Ifill, 1), number_row_center + margin);
    
    % Step 6: Regionprops with location filtering
    stats = regionprops(Ifill, 'Area', 'BoundingBox', 'Centroid');
    min_area = 100;
    max_area = 8000;
    Iregions = false(size(Ifill));
    
    for i = 1:length(stats)
        % Check if centroid is in number row region
        if stats(i).Centroid(2) >= number_row_start && ...
           stats(i).Centroid(2) <= number_row_end && ...
           stats(i).Area > min_area && stats(i).Area < max_area
            
            bbox = round(stats(i).BoundingBox);
            % Check aspect ratio
            aspect_ratio = bbox(3) / bbox(4);
            if aspect_ratio > 0.5 && aspect_ratio < 2.5
                row_start = max(1, bbox(2));
                col_start = max(1, bbox(1));
                row_end = min(size(Ifill, 1), row_start + bbox(4) - 1);
                col_end = min(size(Ifill, 2), col_start + bbox(3) - 1);
                Iregions(row_start:row_end, col_start:col_end) = true;
            end
        end
    end
else
    Iregions = false(size(Ifill));
end

% Step 7: Visualize the results
figure;
subplot(2, 3, 1), imshow(Igry, []), title('Grayscale Image');
subplot(2, 3, 2), imshow(Imed, []), title('After Median Filter');
subplot(2, 3, 3), imshow(Ibw, []), title('Adaptive Thresholding');
subplot(2, 3, 4), imshow(Ifill, []), title('Filled Image');
subplot(2, 3, 5), imshow(Iregions), title('Regionprops');