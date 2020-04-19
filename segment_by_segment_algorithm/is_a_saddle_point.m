function [is_a_saddle, m1_row, m1_col, m2_row, m2_col] = is_a_saddle_point(fv_idx, v)
fv = fv_idx(:, 1);
% disp('fv:');
% disp(fv);
is_a_saddle = false;
m1_row = NaN;
m1_col = NaN;
m2_row = NaN;
m2_col = NaN;

M1 = max(fv);
M2 = max(fv(fv < M1));
% disp(M1);
% disp(M2);
if M1 > v
    mins = find(~fv);
    for imin=1:length(mins)
        if ~is_a_saddle
            fv_idx_sh = circshift(fv_idx, -(mins(imin) - 1));
%             disp('fv dopo ' + string(imin) + '-esimo shift');
%             disp(fvsh);
            values = fv_idx_sh(1:length(fv_idx_sh)/4:end, :);
%             disp(values(2));
%             disp(values(4));
            if (values(2, 1) > v) && (values(3, 1) < v) && (values(4, 1) > v) && (((values(2, 1) == M1) && (values(4, 1) == M2)) || ((values(2, 1) == M2) && (values(4, 1) == M1)) || ((values(2, 1) == M1) && (values(4, 1) == M1)))
                is_a_saddle = true;
                m1_row = values(1, 2);
                m1_col = values(1, 3);
                m2_row = values(3, 2);
                m2_col = values(3, 3);
%                 figure; plot(fvsh); hold on; plot(ones(length(fvsh), 1) * v);
            end
        end
    end
end
end