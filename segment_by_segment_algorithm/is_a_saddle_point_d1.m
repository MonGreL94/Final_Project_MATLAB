function is_a_saddle = is_a_saddle_point_d1(three_by_three_matrix, v)
is_a_saddle = false;
n = three_by_three_matrix(1, 2);
s = three_by_three_matrix(3, 2);
w = three_by_three_matrix(2, 1);
e = three_by_three_matrix(2, 3);
nw = three_by_three_matrix(1, 1);
ne = three_by_three_matrix(1, 3);
sw = three_by_three_matrix(3, 1);
se = three_by_three_matrix(3, 3);
if ((v > n) && (v > s) && (v < w) && (v < e)) || ...
        ((v < n) && (v < s) && (v > w) && (v > e)) || ...
        ((v > nw) && (v > se) && (v < ne) && (v < sw)) || ...
        ((v < nw) && (v < se) && (v > ne) && (v > sw))
    is_a_saddle = true;
end
end