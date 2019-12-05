function sadds = get_sadds(signed_transformed_img, d1, off)
rows = size(signed_transformed_img, 1);
cols = size(signed_transformed_img, 2);
sadds = zeros(rows, cols, 'uint8');
for i=1+d1+off:rows-d1-off
    for j=1+d1+off:cols-d1-off
        v = signed_transformed_img(i, j);
        if d1 == ceil(abs(v))
            d = d1 + off;
    %         d = ceil(abs(v));
            n = signed_transformed_img(i-d, j);
            s = signed_transformed_img(i+d, j);
            w = signed_transformed_img(i, j-d);
            e = signed_transformed_img(i, j+d);
            nw = signed_transformed_img(i-d, j-d);
            ne = signed_transformed_img(i-d, j+d);
            sw = signed_transformed_img(i+d, j-d);
            se = signed_transformed_img(i+d, j+d);
            if (v >= n && v >= s && v <= w && v <= e) || ...
                    (v <= n && v <= s && v >= w && v >= e) || ...
                    (v >= nw && v >= se && v <= ne && v <= sw) || ...
                    (v <= nw && v <= se && v >= ne && v >= sw)
                sadds(i, j) = 255;
            end
        end
    end
end
end