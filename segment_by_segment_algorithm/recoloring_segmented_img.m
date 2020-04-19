function [new_segmented_img, new_color_segmented_img] = recoloring_segmented_img(splitted_segmented_img, segments)
new_segmented_img = zeros(size(splitted_segmented_img, 1), size(splitted_segmented_img, 2));
for i=2:length(segments)
    th = zeros(size(splitted_segmented_img, 1), size(splitted_segmented_img, 2), "logical");
    th(splitted_segmented_img == segments(i)) = 1;
    sg = bwlabel(th, 8);
    sg(sg ~= 0) = sg(sg ~= 0) + max(new_segmented_img(:));
    new_segmented_img = new_segmented_img + sg;
end
colors = linspace(0, 1, max(new_segmented_img(:)) + 2);
colors = colors(2:end-1);
number_of_cc = length(colors);
new_color_segmented_img = label2rgb(new_segmented_img, [colors(randperm(number_of_cc))' colors(randperm(number_of_cc))' colors(randperm(number_of_cc))']);
new_segmented_img = uint8(imnorm(new_segmented_img) * 255);
end