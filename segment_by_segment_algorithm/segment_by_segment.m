clear; close all; clc;

stack = load_stack('..\images\labelled-stack.tif');
segmented_img = stack(:, :, 1);

% img = imread('..\images\radial_checkerboard.png');
% [thresholded_img, segmented_img, color_segmented_img] = cc_segm(img);
% figure; imshow(thresholded_img);
% figure; imshow(imnorm(segmented_img));
% figure; imshow(color_segmented_img);

%% Metric choice and identification of all the saddle points of the segmented image
saddle_points = get_saddle_points(segmented_img, 'euclidean');
%% Plotting the segmented image with all the saddle points
% [saddle_points_rows, saddle_points_cols] = find(saddle_points);
[saddle_points_rows, saddle_points_cols] = simplify_saddles(saddle_points);

figure;
imshow(segmented_img);
hold on;
scatter(saddle_points_cols, saddle_points_rows, 'r*');