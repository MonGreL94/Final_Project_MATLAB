clear; close all; clc;

files = dir("C:\Users\scald\Desktop\dataset\images");
i=7;
img = imread("C:\Users\scald\Desktop\dataset\images\" + string(files(i).name));
[thresholded_img, segmented_img, ~] = cc_segm(img);
figure; imshow(segmented_img);
%%
segmented_img(segmented_img == 1) = 0;
figure; imshow(segmented_img);
%%
segments = unique(segmented_img)
double_segmented_img = zeros(size(segmented_img, 1), size(segmented_img, 2), "double");

s = 1;
for i_s=2:length(segments)
    double_segmented_img(segmented_img == segments(i_s)) = s;
    s = s + 1;
end

segments = unique(double_segmented_img)
figure; imshow(imnorm(double_segmented_img));
%%
colors = linspace(0, 1, max(double_segmented_img(:)) + 2);
colors = colors(2:end-1);
number_of_cc = length(colors);
color_segmented_img = label2rgb(double_segmented_img, [colors(randperm(number_of_cc))' colors(randperm(number_of_cc))' colors(randperm(number_of_cc))']);
figure; imshow(color_segmented_img);
%%
segmented_img = uint8(imnorm(double_segmented_img) * 255);

save("C:\Users\scald\Desktop\dataset\matrix\" + erase(string(files(i).name), [".jpg", ".png"]), "segmented_img");
imwrite(thresholded_img, "C:\Users\scald\Desktop\dataset\thresholded\" + string(files(i).name));
imwrite(segmented_img, "C:\Users\scald\Desktop\dataset\segmented\" + string(files(i).name));
imwrite(color_segmented_img, "C:\Users\scald\Desktop\dataset\color_segmented\" + string(files(i).name));