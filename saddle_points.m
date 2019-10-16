clear; clc;
close all;
img = imread('C:\Users\antonello\Documents\PycharmProjects\StarterProject\checkerboard.jpg');
% thresholded_img = imbinarize(rgb2gray(img), 'adaptive');
thresholded_img = im2bw(img);
distance_metric = 'euclidean';
transformed_img = bwdist(thresholded_img, distance_metric);
transformed_img = (transformed_img - min(transformed_img, [], 'all')) / (max(transformed_img, [], 'all') - min(transformed_img, [], 'all'));
inv_transformed_img = bwdist(not(thresholded_img), distance_metric);
inv_transformed_img = (inv_transformed_img - min(inv_transformed_img, [], 'all')) / (max(inv_transformed_img, [], 'all') - min(inv_transformed_img, [], 'all'));
img_subtraction = inv_transformed_img - transformed_img;
img_subtraction = (img_subtraction - min(img_subtraction, [], 'all')) / (max(img_subtraction, [], 'all') - min(img_subtraction, [], 'all'));
img_addition = inv_transformed_img + transformed_img;
img_addition = (img_addition - min(img_addition, [], 'all')) / (max(img_addition, [], 'all') - min(img_addition, [], 'all'));
img_sizes = size(img);
img_rows = img_sizes(1);
img_cols = img_sizes(2);
dist = 10;
final = [];
for d=1:dist
    curr = [];
    for i=1+d:img_rows-d
        for j=1+d:img_cols-d
            if (img_subtraction(i,j) >= img_subtraction(i-d,j) && img_subtraction(i,j) >= img_subtraction(i+d,j) && img_subtraction(i,j) <= img_subtraction(i,j-d) && img_subtraction(i,j) <= img_subtraction(i,j+d)) || (img_subtraction(i,j) <= img_subtraction(i-d,j) && img_subtraction(i,j) <= img_subtraction(i+d,j) && img_subtraction(i,j) >= img_subtraction(i,j-d) && img_subtraction(i,j) >= img_subtraction(i,j+d)) || (img_subtraction(i,j) >= img_subtraction(i-d,j-d) && img_subtraction(i,j) >= img_subtraction(i+d,j+d) && img_subtraction(i,j) <= img_subtraction(i+d,j-d) && img_subtraction(i,j) <= img_subtraction(i-d,j+d)) || (img_subtraction(i,j) <= img_subtraction(i-d,j-d) && img_subtraction(i,j) <= img_subtraction(i+d,j+d) && img_subtraction(i,j) >= img_subtraction(i+d,j-d) && img_subtraction(i,j) >= img_subtraction(i-d,j+d))
                curr = [curr; [i, j]];
            end
        end
    end
    if d ~= 1
        final = intersect(final, curr, 'rows');
    else
        final = curr;
    end
end
% final_sizes = size(final);
% final_rows = final_sizes(1);
% for cnt=1:final_rows
    % img(final(cnt, 1)-1:final(cnt, 1)+1, final(cnt, 2)-1:final(cnt, 2)+1, :) = cat(3, ones(3, 3)*255, zeros(3, 3), zeros(3, 3));
% end
figure;
imshow(thresholded_img);
hold on
plot(final(:, 2), final(:, 1), 'r*');
figure;
surf(img_subtraction);
final_sizes = size(final);
final_rows = final_sizes(1);
for cnt=1:final_rows
    hold on
    scatter3(final(cnt, 2), final(cnt, 1), img_subtraction(final(cnt, 1), final(cnt, 2)), 'r*');
end
figure;
imshow(img_subtraction);
figure;
imshow(img_addition);
% hold on
% plot(final(:, 2), final(:, 1), 'r*');
figure;
imshow(img);
hold on
plot(final(:, 2), final(:, 1), 'r*');