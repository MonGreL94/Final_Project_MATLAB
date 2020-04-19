function segment_saddle_points = saddle_points_finder_graph_method(transformed_cropped_img_segment)
rows = size(transformed_cropped_img_segment, 1);
cols = size(transformed_cropped_img_segment, 2);
segment_saddle_points = zeros(rows - 4, cols - 4, "logical");

for i=3:rows-2
    for j=3:cols-2
        v = transformed_cropped_img_segment(i, j);
        d = ceil(v);
        if d ~= 0
            matrix = transformed_cropped_img_segment(i-1:i+1, j-1:j+1);
            n = matrix(1, 2);
            s = matrix(3, 2);
            w = matrix(2, 1);
            e = matrix(2, 3);
            nw = matrix(1, 1);
            ne = matrix(1, 3);
            sw = matrix(3, 1);
            se = matrix(3, 3);
            if ((v >= n) && (v >= s) && (v <= w) && (v <= e)) || ...
                    ((v <= n) && (v <= s) && (v >= w) && (v >= e)) || ...
                    ((v >= nw) && (v >= se) && (v <= ne) && (v <= sw)) || ...
                    ((v <= nw) && (v <= se) && (v >= ne) && (v >= sw))
                segment_saddle_points(i-2, j-2) = true;
            end
        end
    end
end
end