function segment_saddle_points = saddle_points_finder(transformed_cropped_segmented_img, metric, aux)
rows = size(transformed_cropped_segmented_img, 1);
cols = size(transformed_cropped_segmented_img, 2);
segment_saddle_points = zeros(rows - 2, cols - 2, 'uint8');
% cnt = 0;
for i=2:rows - 1
    for j=2:cols - 1
        v = transformed_cropped_segmented_img(i, j);
        d = ceil(v);
        if d ~= 0
            fv = get_fv(transformed_cropped_segmented_img(i-d:i+d, j-d:j+d), d, metric, aux);
            if is_a_saddle_point_v2(fv, v)
                segment_saddle_points(i-1, j-1) = 255;
%                 if mod(cnt, 10000) == 0
%                     figure; plot(fv); hold on; plot(ones(length(fv), 1) * v);
%                 end
            end
        end
%         cnt = cnt + 1;
    end
end
end