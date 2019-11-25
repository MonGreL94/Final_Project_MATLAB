clear; close all; clc;

im = imread('checkerboard.jpg');
[th, sg, sgc] = cc_segm(im);
% figure; imshow(sgc);

metric = 'chessboard';

s = size(th);
s1 = s(1);
s2 = s(2);
c1 = ceil(s1 / 2);
c2 = ceil(s2 / 2);
aux = zeros(s1, s2, 'double');
aux(c1, c2) = 1;
aux = bwdist(aux, metric);
% figure; imshow(imnorm(aux));

tf = bwdist(not(th), metric);
tb = bwdist(th, metric);
dif = tf - tb;
% figure; imshow(imnorm(dif));

m = min(dif(:));

for i=1:s1
    for j=1:s2
        v = dif(i, j);
        d = ceil(abs(v));
        subdif = dif(max([1, i - d]):min([s1, i + d]), max([1, j - d]):min([s2, j + d]));
        subaux = aux(max([c1 - i + 1, c1 - d]):min([c1 + s1 - i, c1 + d]), max([c2 - j + 1, c2 - d]):min([c2 + s2 - j, c2 + d]));
        subaux = (subaux > (d - 1)) & (subaux <= d);
        f = subdif(subaux);
    end
end

figure; imshow(imnorm(dif));

% figure;
% surf(dif);
% hold on
% scatter3(c, r, diag(dif(r, c)), 'r*');

% [rows, cols] = find((dif == 1) | (dif == -1));
% figure; imshow(th); hold on; plot(cols, rows, 'r*');
% 
% figure; imshow(dif); hold on; plot(c, r, 'r*');

% figure; imshow(sgc); hold on; plot(c, r, 'r*');