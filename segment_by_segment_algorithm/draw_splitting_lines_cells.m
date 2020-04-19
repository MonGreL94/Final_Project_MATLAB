function segmented_img = draw_splitting_lines_cells(segmented_img, minima_coords)
for i=1:size(minima_coords, 1)
    segmented_img = rgb2gray(insertShape(segmented_img, "Line", [minima_coords(i, 2), minima_coords(i, 1), minima_coords(i, 4), minima_coords(i, 3)], "LineWidth", 1, "Color", [255, 255, 255]));
end
end