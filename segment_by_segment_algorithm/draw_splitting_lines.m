function [segmented_img, new_segments] = draw_splitting_lines(segmented_img, minima_coords)
segmented_img = uint8(imnorm(segmented_img) * 200);
new_segments = unique(segmented_img);
for i=1:size(minima_coords, 1)
    segmented_img = rgb2gray(insertShape(segmented_img, "Line", [minima_coords(i, 2), minima_coords(i, 1), minima_coords(i, 4), minima_coords(i, 3)], "LineWidth", 1, "Color", [255, 255, 255]));
end
end