function fv = get_feature_vector(matrix, d, metric, aux)
if strcmp(metric, 'chessboard')
    fv = [matrix(1, :).'; matrix(2:end, end); flip(matrix(end, 1:end-1)).'; flip(matrix(2:end-1, 1))];
elseif strcmp(metric, 'cityblock')
    fv = [diag(matrix(1:d+1, d+1:end)); diag(rot90(matrix(d+2:end, d+1:end-1))); flip(diag(matrix(d+1:end-1, 1:d))); diag(rot90(matrix(2:d, 2:d), -1))];
else
    subaux = aux(end-d:end, 1:1+d);
    [ra, ca] = find((subaux > (d - 1)) & (subaux <= d));
    fv = [diag(matrix(ra, ca + d)); diag(matrix(d + d + 2 - flip(ra(1:end-1)), flip(ca(1:end-1)) + d)); diag(matrix(d + d + 2 - ra(2:end), d + 2 - ca(2:end))); diag(matrix(flip(ra(2:end-1)), d + 2 - flip(ca(2:end-1))))];
end
end