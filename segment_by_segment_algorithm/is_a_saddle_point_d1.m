function is_a_saddle = is_a_saddle_point_d1(five_by_five_matrix, v)
is_a_saddle = false;
n = five_by_five_matrix(1, 2);
s = five_by_five_matrix(3, 2);
w = five_by_five_matrix(2, 1);
e = five_by_five_matrix(2, 3);
nw = five_by_five_matrix(1, 1);
ne = five_by_five_matrix(1, 3);
sw = five_by_five_matrix(3, 1);
se = five_by_five_matrix(3, 3);
if ((v > n) && (v > s) && (v < w) && (v < e)) || ...
        ((v < n) && (v < s) && (v > w) && (v > e)) || ...
        ((v > nw) && (v > se) && (v < ne) && (v < sw)) || ...
        ((v < nw) && (v < se) && (v > ne) && (v > sw))
    is_a_saddle = true;
end
end