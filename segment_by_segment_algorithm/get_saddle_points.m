function saddle_points = get_saddle_points(segmented_img, metric)
rows = size(segmented_img, 1);
cols = size(segmented_img, 2);

% Auxiliary matrix for Euclidean and quasi-Euclidean metrics
if strcmp(metric, 'euclidean') || strcmp(metric, 'quasi-euclidean')
    aux = zeros(rows, cols, 'double');
    aux(end, 1) = 1;
    aux = bwdist(aux, metric);
    % figure; imshow(imnorm(aux));
end

saddle_points = zeros(rows, cols, 'logical');
segments = unique(segmented_img);
for s=1:length(segments)
    segment = segments(s);
    % segment = 255 means that the segment is the image background and
    % therefore it should not be considered
    if segment ~= 255
        img_segment = segmented_img == segment;
%         figure; imshow(img_segment);
        [segment_rows, segment_cols] = find(img_segment);
        min_row = min(segment_rows(:));
        max_row = max(segment_rows(:));
        min_col = min(segment_cols(:));
        max_col = max(segment_cols(:));
        cropped_img_segment = ones(max_row - min_row + 3, max_col - min_col + 3, 'logical');
        cropped_img_segment(2:end-1, 2:end-1) = ~img_segment(min_row:max_row, min_col:max_col);
%         figure; imshow(cropped_img_segment);
%         figure; imshow(imnorm(bwdist(cropped_img_segment, metric)));
        if strcmp(metric, 'euclidean') || strcmp(metric, 'quasi-euclidean')
            saddle_points(min_row:max_row, min_col:max_col) = saddle_points(min_row:max_row, min_col:max_col) + saddle_points_finder(bwdist(cropped_img_segment, metric), metric, aux);
        else
            saddle_points(min_row:max_row, min_col:max_col) = saddle_points(min_row:max_row, min_col:max_col) + saddle_points_finder(bwdist(cropped_img_segment, metric), metric, NaN);
        end
    end
end
end