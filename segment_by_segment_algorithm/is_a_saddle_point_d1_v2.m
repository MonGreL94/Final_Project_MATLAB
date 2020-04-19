function [is_a_saddle, m1_row, m1_col, m2_row, m2_col] = is_a_saddle_point_d1_v2(matrix, v)
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
            r_m1 = fv_idx_3(mins(imin), 2);
            c_m1 = fv_idx_3(mins(imin), 3);
            fv_idx_3_sh = circshift(fv_idx_3, -mins(imin));
            fv_idx_5_sh = circshift(fv_idx_5, -mins(imin));
            m2 = fv_idx_3_sh(4, 1);
            r_m2 = fv_idx_3_sh(4, 2);
            c_m2 = fv_idx_3_sh(4, 3);
            if m2 == v
                m2 = fv_idx_5_sh(4, 1);
                r_m2 = fv_idx_5_sh(4, 2);
                c_m2 = fv_idx_5_sh(4, 3);
            end
            if m2 == 0
                % Si possono scorrere tutti i valori maggiori di v
                maxs = find(fv_idx_3_sh(:, 1) > v);
%                 maxs = find(fv_idx_3_sh(:, 1) == max(fv_idx_3( :, 1)));
                if ~isempty(maxs)
                    for imax=1:length(maxs)
                        if ~is_a_saddle
                            fv_3_sh = circshift(fv_idx_3(:, 1), -maxs(imax));
                            M2 = fv_3_sh(4);
                            if M2 == v
                                fv_5_sh = circshift(fv_idx_5(:, 1), -maxs(imax));
                                M2 = fv_5_sh(4);
                                if M2 > v
                                    is_a_saddle = true;
                                    m1_row = r_m1;
                                    m1_col = c_m1;
                                    m2_row = r_m2;
                                    m2_col = c_m2;
                                end
                            end
                        end
                    end
                else
                    % Si possono scorrere tutti i valori maggiori di v
                    maxs = find(fv_idx_5_sh(:, 1) > v);
%                     maxs = find(fv_idx_5_sh(:, 1) == max(fv_idx_5( :, 1)));
                    for imax=1:length(maxs)
                        if ~is_a_saddle
                            fv_5_sh = circshift(fv_idx_5(:, 1), -maxs(imax));
                            M2 = fv_5_sh(4);
                            if M2 > v
                                is_a_saddle = true;
                                m1_row = r_m1;
                                m1_col = c_m1;
                                m2_row = r_m2;
                                m2_col = c_m2;
                            end
                        end
                    end
                end
            end
        end
    end
end
end