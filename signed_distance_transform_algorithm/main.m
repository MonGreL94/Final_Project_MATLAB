clear; close all; clc;

im = imread('..\images\checkerboard.jpg');
[th, sg, sgc] = cc_segm(im);
figure; imshow(th);
figure; imshow(imnorm(sg));
figure; imshow(sgc);

metric = 'cityblock';

rows = size(sg, 1);
cols = size(sg, 2);
cx = ceil(cols / 2);
cy = ceil(rows / 2);

aux = zeros(rows, cols, 'double');
aux(end, 1) = 1;
aux = bwdist(aux, metric);
% figure; imshow(imnorm(aux));

fg = [zeros(1, cols + 2, 'double');
zeros(rows, 1, 'double'), th, zeros(rows, 1, 'double');
zeros(1, cols + 2, 'double')];

bg = [zeros(1, cols + 2, 'double');
zeros(rows, 1, 'double'), not(th), zeros(rows, 1, 'double');
zeros(1, cols + 2, 'double')];

tf = bwdist(not(fg), metric);
tb = bwdist(not(bg), metric);
dif = tf - tb;
figure; imshow(imnorm(tf));
figure; imshow(imnorm(tb));
figure; imshow(imnorm(dif));
%%
M = get_max(abs(dif), 1);
[r, c] = find(M);
%%
sadds = get_sadds(dif, 1, 0);
%%
[rs, cs] = find(sadds);

figure;
imshow(imnorm(sg));
hold on;
scatter(cs, rs, 'r*');