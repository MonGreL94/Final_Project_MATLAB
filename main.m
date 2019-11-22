clear; close all; clc;
im = imread('checkerboard.jpg');
[th, sg, sgc] = cc_segm(im);
% figure; imshow(sgc);

metric = 'chessboard';

s = size(sg);
aux = zeros(s(1) + 1, s(2) + 1, 'double');
aux(ceil((s(1) + 1) / 2), ceil((s(2) + 1) / 2)) = 1;
aux = bwdist(aux, metric);
figure; imshow(imnorm(aux));

tf = bwdist(not(sg), metric);
tb = bwdist(sg, metric);
dif = tf - tb;
% figure; imshow(imnorm(dif));

rows = s(1);
cols = s(2);
for i=1:400:rows
    for j=1:400:cols
        d = fix(abs(dif(i, j)));
        th = aux;
        th(:) = 1;
        th(aux <= d) = 0;
        th(aux > d + 1) = 0;
        figure; imshow(th);
    end
end

% figure;
% surf(dif);
% hold on
% scatter3(c, r, diag(dif(r, c)), 'r*');

% [rows, cols] = find((dif == 1) | (dif == -1));
% figure; imshow(th); hold on; plot(cols, rows, 'r*');
% 
% figure; imshow(dif); hold on; plot(c, r, 'r*');

figure; imshow(sgc); hold on; plot(c, r, 'r*');