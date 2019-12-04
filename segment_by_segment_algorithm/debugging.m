function [d, matrix, subauxdbg, subauxdbg_contour, fv] = debugging(transformed_cropped_img_segment, metric, sample_step, aux)
matrix = NaN;
subauxdbg = NaN;
subauxdbg_contour = NaN;
fv = NaN;
rows = size(transformed_cropped_img_segment, 1);
cols = size(transformed_cropped_img_segment, 2);
cx = ceil(cols / 2);
cy = ceil(rows / 2);
auxdbg = zeros(rows, cols, 'double');
auxdbg(cy, cx) = 1;
auxdbg = bwdist(auxdbg, metric);
% figure; imshow(imnorm(auxdbg));
for i=2:sample_step:rows - 1
    for j=2:sample_step:cols - 1
        d = ceil(transformed_cropped_img_segment(i, j));
        if d ~= 0
            matrix = transformed_cropped_img_segment(i-d:i+d, j-d:j+d);
            subauxdbg = auxdbg(cy-d:cy+d, cx-d:cx+d);
            subauxdbg_contour = (subauxdbg > (d - 1)) & (subauxdbg <= d);
            if strcmp(metric, 'euclidean') || strcmp(metric, 'quasi-euclidean')
                fv = get_feature_vector(matrix, d, metric, aux(end-d:end, 1:1+d));
            else
                fv = get_feature_vector(matrix, d, metric);
            end
        end
    end
end
end