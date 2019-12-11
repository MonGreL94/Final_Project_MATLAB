function segment_saddle_points = saddle_points_finder(transformed_cropped_img_segment, metric, aux)
rows = size(transformed_cropped_img_segment, 1);
cols = size(transformed_cropped_img_segment, 2);
segment_saddle_points = zeros(rows - 4, cols - 4, 'logical');
% cnt = 0;
for i=3:rows-2
    for j=3:cols-2
        v = transformed_cropped_img_segment(i, j);
        d = ceil(v);
        if d ~= 0
            if d == 1
                segment_saddle_points(i-2, j-2) = is_a_saddle_point_d1(transformed_cropped_img_segment(i-2:i+2, j-2:j+2), v);
            else
                if strcmp(metric, 'euclidean') || strcmp(metric, 'quasi-euclidean')
                    fv = get_feature_vector(transformed_cropped_img_segment(i-d:i+d, j-d:j+d), metric, d, aux(end-d:end, 1:1+d));
                else
                    fv = get_feature_vector(transformed_cropped_img_segment(i-d:i+d, j-d:j+d), metric, d);
                end
%                 if length(find(~fv)) > 1
%                     if mod(cnt, 10000) == 0
%                         figure; plot(fv); hold on; plot(ones(length(fv), 1) * v); title('row = ' + string(i-1) + ' - col = ' + string(j-1));
%                     end
%                 end
                segment_saddle_points(i-2, j-2) = is_a_saddle_point(fv, v);
%                 if mod(cnt, 100) == 0
%                     figure; plot(fv); hold on; plot(ones(length(fv), 1) * v); title('row = ' + string(i-1) + ' - col = ' + string(j-1));
%                 end
            end
        end
%         cnt = cnt + 1;
    end
end
end