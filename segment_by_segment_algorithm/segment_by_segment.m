clear; close all; clc;

% stack = load_stack("..\images\labelled-stack.tif");
% segmented_img = stack(:, :, 1);

img = imread("..\dataset\images\distortion02.jpg");
[thresholded_img, segmented_img, color_segmented_img] = cc_segm(img);
figure; imshow(thresholded_img);
figure; imshow(segmented_img);
figure; imshow(color_segmented_img);

%% Metric choice and identification of all the saddle points of the segmented image
[saddle_points, minima_coords] = get_saddle_points(segmented_img, "euclidean");
%% Plotting the segmented image with all the saddle points
% [saddle_points_rows, saddle_points_cols] = find(saddle_points);
[saddle_points_rows, saddle_points_cols] = compute_centroids(saddle_points);
%%
splitted_segmented_img = draw_splitting_lines(segmented_img, minima_coords);
[new_segmented_img, new_color_segmented_img] = recoloring_segmented_img(splitted_segmented_img, unique(segmented_img));
%%
figure;
imshow(segmented_img);
colormap("default");
hold on;
scatter(saddle_points_cols, saddle_points_rows, "r*");
scatter(minima_coords(:, 2), minima_coords(:, 1), "b*");
scatter(minima_coords(:, 4), minima_coords(:, 3), "g*");
%%
figure;
imshow(new_color_segmented_img);
colormap("default");
hold on;
scatter(saddle_points_cols, saddle_points_rows, "r*");
scatter(minima_coords(:, 2), minima_coords(:, 1), "b*");
scatter(minima_coords(:, 4), minima_coords(:, 3), "g*");