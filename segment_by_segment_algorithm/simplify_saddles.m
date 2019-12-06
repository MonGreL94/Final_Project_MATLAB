function [new_rows, new_cols] = simplify_saddles(saddle_points)
new_saddles_array = struct2array(regionprops(saddle_points, 'Centroid'));
new_rows = zeros(length(new_saddles_array) / 2, 1);
new_cols = zeros(length(new_saddles_array) / 2, 1);
for i=1:2:length(new_saddles_array)
    new_cols(ceil(i / 2)) = new_saddles_array(i);
    new_rows(ceil(i / 2)) = new_saddles_array(i + 1);
end
end