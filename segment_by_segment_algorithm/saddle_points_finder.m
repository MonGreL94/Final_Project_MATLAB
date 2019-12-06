function segment_saddle_points = saddle_points_finder(transformed_cropped_img_segment, metric, aux)
rows = size(transformed_cropped_img_segment, 1);
cols = size(transformed_cropped_img_segment, 2);
segment_saddle_points = zeros(rows - 2, cols - 2, 'logical');
% cnt = 0;
for i=2:rows-1
    for j=2:cols-1
        v = transformed_cropped_img_segment(i, j);
        d = ceil(v);
        if d ~= 0
            if d == 1
                segment_saddle_points(i-1, j-1) = is_a_saddle_point_d1(transformed_cropped_img_segment(i-d:i+d, j-d:j+d), v);
            else
                if strcmp(metric, 'euclidean') || strcmp(metric, 'quasi-euclidean')
                    fv = get_feature_vector(transformed_cropped_img_segment(i-d:i+d, j-d:j+d), d, metric, aux(end-d:end, 1:1+d));
                else
                    fv = get_feature_vector(transformed_cropped_img_segment(i-d:i+d, j-d:j+d), d, metric);
                end
%                 if length(find(~fv)) > 1
%                     if mod(cnt, 10000) == 0
%                         figure; plot(fv); hold on; plot(ones(length(fv), 1) * v); title('row = ' + string(i-1) + ' - col = ' + string(j-1));
%                     end
%                 end
                segment_saddle_points(i-1, j-1) = is_a_saddle_point(fv, v);
%                 if mod(cnt, 100) == 0
%                     figure; plot(fv); hold on; plot(ones(length(fv), 1) * v); title('row = ' + string(i-1) + ' - col = ' + string(j-1));
%                 end
            end
        end
%         cnt = cnt + 1;
    end
end
end