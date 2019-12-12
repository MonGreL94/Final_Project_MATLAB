clear; close all; clc;

files = dir('..\color_segmented_dataset\');
for i=3:length(files)
    img = imread('..\color_segmented_dataset\' + string(files(i).name));
    figure; imshow(img); title(string(files(i).name));
end