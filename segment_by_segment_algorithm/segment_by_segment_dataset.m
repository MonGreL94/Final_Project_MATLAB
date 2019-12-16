clear; close all; clc;

files = dir('..\small_dataset\cropped_dataset');
for i=11:4:length(files)
    img = imread('..\small_dataset\cropped_dataset\' + string(files(i).name));
    [thresholded_img, segmented_img, color_segmented_img] = cc_segm(img);
    [saddle_points_rows, saddle_points_cols] = simplify_saddles(get_saddle_points(segmented_img, 'euclidean'));
    
    figure;
    imshow(color_segmented_img);
    hold on;
    scatter(saddle_points_cols, saddle_points_rows, 'r*');
end