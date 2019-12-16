clear; close all; clc;

files = dir('..\small_dataset\cropped_dataset');
for i=11:4:length(files)
    img = imread('..\small_dataset\cropped_dataset\' + string(files(i).name));
    [thresholded_img, segmented_img, color_segmented_img] = cc_segm(img);
    figure; imshow(color_segmented_img); title(string(files(i).name));
end