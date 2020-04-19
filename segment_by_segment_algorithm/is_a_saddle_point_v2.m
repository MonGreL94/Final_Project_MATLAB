function [is_a_saddle, m1_row, m1_col, m2_row, m2_col] = is_a_saddle_point_v2(fv_idx, v)
is_a_saddle = false;
m1_row = NaN;
m1_col = NaN;
m2_row = NaN;
m2_col = NaN;

fv = fv_idx(:, 1);
M1 = max(fv);
if M1 > v
    mins = find(~fv);
    for imin=1:length(mins)
        if ~is_a_saddle
            fv_idx_sh = circshift(fv_idx, -mins(imin));
            m2 = fv_idx_sh(length(fv)/2, 1);
            if m2 == 0
                % Si possono scorrere tutti i valori maggiori di v
                maxs = find(fv > v);
%                 maxs = find(fv == M1);
                for imax=1:length(maxs)
                    if ~is_a_saddle
                        fv_sh = circshift(fv, -maxs(imax));
                        M2 = fv_sh(length(fv)/2);
                        if M2 > v
                            is_a_saddle = true;
                            m1_row = fv_idx_sh(end, 2);
                            m1_col = fv_idx_sh(end, 3);
                            m2_row = fv_idx_sh(length(fv)/2, 2);
                            m2_col = fv_idx_sh(length(fv)/2, 3);
                        end
                    end
                end
            end
        end
    end
end
end