function segment_saddle_points = saddle_points_finder(transformed_cropped_img_segment, metric, aux)
rows = size(transformed_cropped_img_segment, 1);
cols = size(transformed_cropped_img_segment, 2);
segment_saddle_points = zeros(rows - 2, cols - 2, 'logical');
cnt = 0;
off = 1;
for i=2+off:rows - 1-off
    for j=2+off:cols - 1-off
        v = transformed_cropped_img_segment(i, j);
        d = ceil(v);
        if d ~= 0
            if d == 1
                d = d + 1;
            end
            if strcmp(metric, 'euclidean') || strcmp(metric, 'quasi-euclidean')
                fv = get_feature_vector(transformed_cropped_img_segment(i-d:i+d, j-d:j+d), d, metric, aux(end-d:end, 1:1+d));
            else
                fv = get_feature_vector(transformed_cropped_img_segment(i-d:i+d, j-d:j+d), d, metric);
            end
%             if length(find(~fv)) > 1
%                 if mod(cnt, 10000) == 0
%                     figure; plot(fv); hold on; plot(ones(length(fv), 1) * v); title('row = ' + string(i-1) + ' - col = ' + string(j-1));
%                 end
%             end
            if is_a_saddle_point_v2(fv, v)
                segment_saddle_points(i-1, j-1) = 1;
%                 if mod(cnt, 100) == 0
%                     figure; plot(fv); hold on; plot(ones(length(fv), 1) * v); title('row = ' + string(i-1) + ' - col = ' + string(j-1));
%                 end
            end
        end
        cnt = cnt + 1;
    end
end
end