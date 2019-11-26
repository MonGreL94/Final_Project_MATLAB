clear; close all; clc;

im = imread('checkerboard.jpg');
[th, sg, sgc] = cc_segm(im);
% figure; imshow(imnorm(th));
% figure; imshow(imnorm(sg));
% figure; imshow(sgc);

metric = 'chessboard';

s = size(sg);
rows = s(1);
cols = s(2);
cx = ceil(cols / 2);
cy = ceil(rows / 2);

aux = zeros(rows, cols, 'double');
aux(cy, cx) = 1;
aux = bwdist(aux, metric);
% figure; imshow(imnorm(aux));

tf = bwdist(not(sg), metric);
tb = bwdist(sg, metric);
dif = tf - tb;
% figure; imshow(imnorm(tf));
% figure; imshow(imnorm(tb));
% figure; imshow(imnorm(dif));

M = get_max(abs(dif), 1);
[r, c] = find(M == 255);

% for i=1:rows
%     for j=1:cols
%         d = ceil(abs(dif(i, j)));
%         subdif = dif(max([1, i - d]):min([rows, i + d]), max([1, j - d]):min([cols, j + d]));
%         subaux = aux(max([cy - i + 1, cy - d]):min([cy + rows - i, cy + d]), max([cx - j + 1, cx - d]):min([cx + cols - j, cx + d]));
%         if strcmp(metric, 'euclidean')
%             subaux = (subaux > (d - 1)) & (subaux <= d);
%         else
%             subaux = subaux == d;
%         end
%         f = subdif(subaux);
%     end
% end

for k=1:length(r)
    i = r(k);
    j = c(k);
    d = ceil(abs(dif(i, j)));
    subdif = dif(max([1, i - d]):min([rows, i + d]), max([1, j - d]):min([cols, j + d]));
    subaux = aux(max([cy - i + 1, cy - d]):min([cy + rows - i, cy + d]), max([cx - j + 1, cx - d]):min([cx + cols - j, cx + d]));
    if strcmp(metric, 'euclidean')
        subaux = (subaux > (d - 1)) & (subaux <= d);
    else
        subaux = subaux == d;
    end
    f = subdif(subaux);
end

% figure; imshow(imnorm(dif));

% figure;
% surf(dif);
% hold on
% scatter3(c, r, diag(dif(r, c)), 'r*');

% [rows, cols] = find((dif == 1) | (dif == -1));
% figure; imshow(th); hold on; plot(cols, rows, 'r*');
% 
% figure; imshow(dif); hold on; plot(c, r, 'r*');

% figure; imshow(sgc); hold on; plot(c, r, 'r*');