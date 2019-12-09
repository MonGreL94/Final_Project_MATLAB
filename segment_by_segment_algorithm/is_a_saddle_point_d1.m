function is_a_saddle = is_a_saddle_point_d1(matrix, v)
is_a_saddle = false;

fv3 = get_feature_vector(matrix(2:4, 2:4), NaN, 'chessboard', NaN);
fv5 = get_feature_vector(matrix, NaN, 'chessboard', NaN);
fv5 = fv5(1:2:end);

mins = find(~fv3);
for imin=1:length(mins)
    fv3sh = circshift(fv3, -(mins(imin) - 1));
    fv5sh = circshift(fv5, -(mins(imin) - 1));
    values3 = fv3sh(1:length(fv3sh) / 4:end);
    values5 = fv5sh(1:length(fv5sh) / 4:end);
    m2 = values3(3);
    if m2 == v
        m2 = values5(3);
    end
    M1 = values3(2);
    if M1 == v
        M1 = values5(2);
    end
    M2 = values3(4);
    if M2 == v
        M2 = values5(4);
    end
    if (M1 > v) && (m2 < v) && (M2 > v)
        is_a_saddle = true;
    end
end
% n = matrix(1, 2);
% s = matrix(3, 2);
% w = matrix(2, 1);
% e = matrix(2, 3);
% nw = matrix(1, 1);
% ne = matrix(1, 3);
% sw = matrix(3, 1);
% se = matrix(3, 3);
% if ((v > n) && (v > s) && (v < w) && (v < e)) || ...
%         ((v < n) && (v < s) && (v > w) && (v > e)) || ...
%         ((v > nw) && (v > se) && (v < ne) && (v < sw)) || ...
%         ((v < nw) && (v < se) && (v > ne) && (v > sw))
%     is_a_saddle = true;
% end
end