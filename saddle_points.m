clear; close all; clc;
img = imread('coins.jpg');
% thresholded_img = imbinarize(rgb2gray(img), 'adaptive');
thresholded_img = im2bw(img);

distance_metric = 'euclidean';
transformed_img = bwdist(thresholded_img, distance_metric);
transformed_img = normalize_image(transformed_img);

inv_transformed_img = bwdist(not(thresholded_img), distance_metric);
inv_transformed_img = normalize_image(inv_transformed_img);

img_subtraction = inv_transformed_img - transformed_img;
img_subtraction = normalize_image(img_subtraction);

% img_addition = inv_transformed_img + transformed_img;
% img_addition = normalize_image(img_addition);

img_sizes = size(img);
img_rows = img_sizes(1);
img_cols = img_sizes(2);
dist = 1;
saddles = [];
for d=1:dist
    curr = [];
    for i=1+d:img_rows-d
        for j=1+d:img_cols-d
            if (img_subtraction(i,j) >= img_subtraction(i-d,j) && img_subtraction(i,j) >= img_subtraction(i+d,j) && ...
                img_subtraction(i,j) <= img_subtraction(i,j-d) && img_subtraction(i,j) <= img_subtraction(i,j+d)) || ...
               (img_subtraction(i,j) <= img_subtraction(i-d,j) && img_subtraction(i,j) <= img_subtraction(i+d,j) && ...
                img_subtraction(i,j) >= img_subtraction(i,j-d) && img_subtraction(i,j) >= img_subtraction(i,j+d))
                curr = [curr; [i, j]];
            end
        end
    end
    if d ~= 1
        saddles = intersect(saddles, curr, 'rows');
    else
        saddles = curr;
    end
%     saddles = curr;
end

figure;
surf(img_subtraction);
hold on
scatter3(saddles(:, 2), saddles(:, 1), diag(img_subtraction(saddles(:, 1), saddles(:, 2))), 'r*');

figure;
imshow(img);
hold on
plot(saddles(:, 2), saddles(:, 1), 'r*');