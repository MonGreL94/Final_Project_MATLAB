clear; close all; clc;

im = imread('checkerboard.jpg');
[th, sg, sgc] = cc_segm(im);
% figure; imshow(imnorm(th));
% figure; imshow(imnorm(sg));
% figure; imshow(sgc);

metric = 'euclidean';

rows = size(sg, 1) + 2;
cols = size(sg, 2) + 2;
cx = ceil(cols / 2);
cy = ceil(rows / 2);

aux = zeros(rows, cols, 'double');
aux(end, 1) = 1;
aux = bwdist(aux, metric);
% figure; imshow(imnorm(aux));

fg = [zeros(1, size(im, 2) + 2, 'double');
zeros(size(im, 1), 1, 'double'), sg, zeros(size(im, 1), 1, 'double');
zeros(1, size(im, 2) + 2, 'double')];

bg = [zeros(1, size(im, 2) + 2, 'double');
zeros(size(im, 1), 1, 'double'), not(sg), zeros(size(im, 1), 1, 'double');
zeros(1, size(im, 2) + 2, 'double')];

tf = bwdist(not(fg), metric);
tb = bwdist(not(bg), metric);
dif = tf - tb;
% figure; imshow(imnorm(tf));
% figure; imshow(imnorm(tb));
% figure; imshow(imnorm(dif));

M = get_max(abs(dif), 1);
[r, c] = find(M);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUGGING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=2:400:rows - 1
%     for j=2:400:cols - 1
%         d = ceil(abs(dif(i, j)))
%         subdif = dif(i - d:i + d,j - d:j + d)
%         subaux = aux(cy - d:cy + d, cx - d:cx + d)
%         subaux = (subaux > (d - 1)) & (subaux <= d)
%         if strcmp(metric, 'chessboard')
%             fv = [subdif(1, :).'; subdif(2:end, end); flip(subdif(end, 1:end-1)).'; flip(subdif(2:end-1, 1))]
%         elseif strcmp(metric, 'cityblock')
%             fv = [diag(subdif(1:d+1, d+1:end)); diag(rot90(subdif(d+2:end, d+1:end-1))); flip(diag(subdif(d+1:end-1, 1:d))); diag(rot90(subdif(2:d, 2:d), -1))]
%         else
%             subaux = rot90(aux(cy:cy + d, cx:cx + d));
%             subaux = (subaux > (d - 1)) & (subaux <= d);
%             [ra, ca] = find(subaux == 1);
%             
%             d1 = subdif(1:d+1, d+1:end);
%             d2 = rot90(subdif(d+1:end, d+1:end));
%             d3 = rot90(rot90(subdif(d+1:end, 1:d+1)));
%             d4 = rot90(subdif(1:d+1, 1:d+1), -1);
%             
%             f1 = diag(d1(ra, ca));
%             f2 = diag(d2(ra, ca));
%             f3 = diag(d3(ra, ca));
%             f4 = diag(d4(ra, ca));
%             
%             fv = [f1; f2(2:end); f3(2:end); f4(2:end-1)]
%         end
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUGGING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:length(r)
    i = r(k);
    j = c(k);
    d = ceil(abs(dif(i, j)));
    
    subdif = dif(i-d:i+d, j-d:j+d);
    if strcmp(metric, 'chessboard')
        fv = [subdif(1, :).'; subdif(2:end, end); flip(subdif(end, 1:end-1)).'; flip(subdif(2:end-1, 1))];
    elseif strcmp(metric, 'cityblock')
        fv = [diag(subdif(1:d+1, d+1:end)); diag(rot90(subdif(d+2:end, d+1:end-1))); flip(diag(subdif(d+1:end-1, 1:d))); diag(rot90(subdif(2:d, 2:d), -1))];
    else
        subaux = aux(end-d:end, 1:1+d);
        [ra, ca] = find((subaux > (d - 1)) & (subaux <= d));
        fv = [diag(subdif(ra, ca + d)); diag(subdif(d + d + 2 - flip(ra(1:end-1)), flip(ca(1:end-1)) + d)); diag(subdif(d + d + 2 - ra(2:end), d + 2 - ca(2:end))); diag(subdif(flip(ra(2:end-1)), d + 2 - flip(ca(2:end-1))))];
    end
end