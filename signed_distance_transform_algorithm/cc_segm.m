function [thresholded_img, segmented_img, color_segmented_img] = cc_segm(img, conn)
if nargin < 2
    conn = 8;
end
thresholded_img = im2bw(img);
segmented_img = bwlabel(thresholded_img, conn);
segmented_img_back = bwlabel(~thresholded_img, conn);
segmented_img(segmented_img ~= 0) = segmented_img(segmented_img ~= 0) + max(segmented_img_back(:));
segmented_img(segmented_img == 0) = segmented_img_back(segmented_img_back ~= 0);
colors = linspace(0, 1, max(segmented_img(:)) + 2);
colors = colors(2:end-1);
number_of_cc = length(colors);
color_segmented_img = label2rgb(segmented_img, [colors(randperm(number_of_cc))' colors(randperm(number_of_cc))' colors(randperm(number_of_cc))']);
end