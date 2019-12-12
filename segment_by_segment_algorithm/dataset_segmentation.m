clear; close all; clc;

files = dir('..\dataset');
for i=3:length(files)
    img = imread('..\dataset\' + string(files(i).name));
    if i >= 30
        cropped_img = imcrop(img);
    else
        cropped_img = img;
    end
    [thresholded_img, segmented_img, color_segmented_img] = cc_segm(cropped_img);
    imwrite(cropped_img, '..\cropped_dataset\' + string(files(i).name));
    imwrite(thresholded_img, '..\thresholded_dataset\' + string(files(i).name));
    imwrite(imnorm(segmented_img), '..\segmented_dataset\' + string(files(i).name));
    imwrite(color_segmented_img, '..\color_segmented_dataset\' + string(files(i).name));
end