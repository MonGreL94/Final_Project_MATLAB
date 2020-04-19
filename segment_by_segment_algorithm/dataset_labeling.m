clear; close all; clc;

files = dir("C:\Users\scald\Desktop\dataset\matrix");
i=7;
load("C:\Users\scald\Desktop\dataset\matrix\" + string(files(i).name));

[saddle_points, minima_coords] = get_saddle_points(segmented_img, "euclidean");
[saddle_points_rows, saddle_points_cols] = simplify_saddles(saddle_points);
[saddle_points_cols, saddle_points_rows]

figure; imshow(segmented_img); title(string(files(i).name));
hold on;
scatter(saddle_points_cols, saddle_points_rows, "r*");