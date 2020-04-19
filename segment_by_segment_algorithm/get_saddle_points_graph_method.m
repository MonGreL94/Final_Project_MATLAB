function saddle_points = get_saddle_points_graph_method(segmented_img, metric)
rows = size(segmented_img, 1);
cols = size(segmented_img, 2);

saddle_points = zeros(rows, cols, "logical");

segments = unique(segmented_img);
for s=1:length(segments)
    segment = segments(s);
    % segment = 255 means that the segment is the image background and
    % therefore it should not be considered
    if (segment ~= 0) && (segment ~= 255) && (segment ~= 170)
        img_segment = segmented_img == segment;
%         figure; imshow(img_segment);
        [segment_rows, segment_cols] = find(img_segment);
        min_row = min(segment_rows(:));
        max_row = max(segment_rows(:));
        min_col = min(segment_cols(:));
        max_col = max(segment_cols(:));
        crop_rows = max_row - min_row + 5;
        crop_cols = max_col - min_col + 5;
        cropped_img_segment = ones(crop_rows, crop_cols, "logical");
        cropped_img_segment(3:end-2, 3:end-2) = ~img_segment(min_row:max_row, min_col:max_col);
%         figure; imshow(cropped_img_segment);
%         figure; imshow(bwdist(cropped_img_segment, metric), []);
        saddle_points(min_row:max_row, min_col:max_col) = saddle_points(min_row:max_row, min_col:max_col) + saddle_points_finder_graph_method(bwdist(cropped_img_segment, metric));
%     else
%         figure; imshow(segmented_img == segment);
    end
end
end