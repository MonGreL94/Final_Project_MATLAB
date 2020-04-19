function [is_a_saddle, m1_row, m1_col, m2_row, m2_col] = is_a_saddle_point_d1(matrix, v)
is_a_saddle = false;
m1_row = NaN;
m1_col = NaN;
m2_row = NaN;
m2_col = NaN;

fv_idx_3 = get_feature_vector(matrix(2:4, 2:4), "chessboard", 1);
fv_idx_3(:, 2) = fv_idx_3(:, 2) + 1;
fv_idx_3(:, 3) = fv_idx_3(:, 3) + 1;
fv_idx_5 = get_feature_vector(matrix, "chessboard", 2);
fv_idx_5 = fv_idx_5(1:2:end, :);
if max(fv_idx_3(:, 1)) > v || max(fv_idx_5(:, 1)) > v
    mins = find(~fv_idx_3(:, 1));
    for imin=1:length(mins)
        if ~is_a_saddle
            fv_idx_3_sh = circshift(fv_idx_3, -(mins(imin) - 1));
            fv_idx_5_sh = circshift(fv_idx_5, -(mins(imin) - 1));
            values3 = fv_idx_3_sh(1:length(fv_idx_3_sh)/4:end, :);
            values5 = fv_idx_5_sh(1:length(fv_idx_5_sh)/4:end, :);
            m2 = values3(3, 1);
            r_m2 = values3(3, 2);
            c_m2 = values3(3, 3);
            if m2 == v
                m2 = values5(3, 1);
                r_m2 = values5(3, 2);
                c_m2 = values5(3, 3);
            end
            M1 = values3(2, 1);
            if M1 == v
                M1 = values5(2, 1);
            end
            M2 = values3(4, 1);
            if M2 == v
                M2 = values5(4, 1);
            end
            if (M1 > v) && (m2 < v) && (M2 > v)
                is_a_saddle = true;
                m1_row = values3(1, 2);
                m1_col = values3(1, 3);
                m2_row = r_m2;
                m2_col = c_m2;
            end
        end
    end
end
end