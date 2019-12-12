clear; close all; clc;

%% Metric choice and identification of all the saddle points of the segmented image
saddle_points = get_saddle_points(segmented_img, 'euclidean');
%% Plotting the segmented image with all the saddle points
% [saddle_points_rows, saddle_points_cols] = find(saddle_points);
[saddle_points_rows, saddle_points_cols] = simplify_saddles(saddle_points);

figure;
imshow(imnorm(segmented_img));
hold on;
scatter(saddle_points_cols, saddle_points_rows, 'r*');