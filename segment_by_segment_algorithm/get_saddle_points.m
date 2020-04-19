function [saddle_points, minima_coords] = get_saddle_points(segmented_img, metric)
rows = size(segmented_img, 1);
cols = size(segmented_img, 2);

% Auxiliary matrix for Euclidean and quasi-Euclidean metrics
if strcmp(metric, "euclidean") || strcmp(metric, "quasi-euclidean")
    aux = zeros(rows + 4, cols + 4, "double");
    aux(end, 1) = 1;
    aux = bwdist(aux, metric);
    % figure; imshow(imnorm(aux));
end

saddle_points = zeros(rows, cols, "logical");
minima_coords = [];

segments = unique(segmented_img);
for s=1:length(segments)
    segment = segments(s);
    % segment = 255 means that the segment is the image background and
    % therefore it should not be considered
    if (segment ~= 0) % && (segment ~= 255) && (segment ~= 170)
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
%         figure; imshow(imnorm(bwdist(cropped_img_segment, metric)));
        if strcmp(metric, "euclidean") || strcmp(metric, "quasi-euclidean")
            [segment_saddle_points, segment_minima_coords] = saddle_points_finder(bwdist(cropped_img_segment, metric), metric, aux(end-crop_rows+1:end, 1:crop_cols));
%             [d, matrix, subauxdbg, subauxdbg_contour, fv] = debugging(bwdist(cropped_img_segment, metric), metric, 400, aux(end-crop_rows+1:end, 1:crop_cols))
        else
            [segment_saddle_points, segment_minima_coords] = saddle_points_finder(bwdist(cropped_img_segment, metric), metric);
%             [d, matrix, subauxdbg, subauxdbg_contour, fv] = debugging(bwdist(cropped_img_segment, metric), metric, 400)
        end
        saddle_points(min_row:max_row, min_col:max_col) = saddle_points(min_row:max_row, min_col:max_col) + segment_saddle_points;
        if ~isempty(segment_minima_coords)
            segment_minima_coords(:, [1, 3]) = segment_minima_coords(:, [1, 3]) + min_row;
            segment_minima_coords(:, [2, 4]) = segment_minima_coords(:, [2, 4]) + min_col;
            minima_coords = [minima_coords; segment_minima_coords];
        end
%     else
%         figure; imshow(segmented_img == segment);
    end
end
end