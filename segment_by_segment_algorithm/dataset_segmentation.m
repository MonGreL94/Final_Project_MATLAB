clear; close all; clc;

files = dir('..\big_dataset\images_dataset');
for i=3:length(files)
    img = imread('..\big_dataset\images_dataset\' + string(files(i).name));
    if i >= 3
        cropped_img = imcrop(img);
    else
        cropped_img = img;
    end
    if  isequal(string(files(i).name), 'Coins.jpg')
        [thresholded_img, segmented_img, color_segmented_img] = cc_segm(cropped_img);
        imwrite(cropped_img, '..\big_dataset\cropped_dataset\' + string(files(i).name));
        imwrite(thresholded_img, '..\big_dataset\thresholded_dataset\' + string(files(i).name));
        imwrite(imnorm(segmented_img), '..\big_dataset\segmented_dataset\' + string(files(i).name));
        imwrite(color_segmented_img, '..\big_dataset\color_segmented_dataset\' + string(files(i).name));
    end
end