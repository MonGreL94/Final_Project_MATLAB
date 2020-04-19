function [new_segmented_img, new_color_segmented_img] = recoloring_segmented_cells_img(splitted_segmented_img, segments)
new_segmented_img = zeros(size(splitted_segmented_img, 1), size(splitted_segmented_img, 2));

new_segmented_img(splitted_segmented_img == 0) = 1;
new_segmented_img(splitted_segmented_img == 170) = 2;
new_segmented_img(splitted_segmented_img == 255) = 3;

for i=1:length(segments)
    th = zeros(size(splitted_segmented_img, 1), size(splitted_segmented_img, 2), "logical");
    th(splitted_segmented_img == segments(i)) = 1;
    sg = bwlabel(th, 8);
    sg(sg ~= 0) = sg(sg ~= 0) + max(new_segmented_img(:));
    new_segmented_img = new_segmented_img + sg;
end
number_of_colors = max(new_segmented_img(:));
colors = zeros(number_of_colors, 3);
colors(1, :) = [0.2392, 0.149, 0.6588];
colors(2, :) = [0.502, 0.7961, 0.3451];
colors(3, :) = [0.9765, 0.9804, 0.07843];
for i=4:number_of_colors
    colors(i, :) = [rand(1,1), rand(1,1), rand(1,1)];
end
new_color_segmented_img = label2rgb(new_segmented_img, colors);
new_segmented_img = uint8(imnorm(new_segmented_img) * 255);
end