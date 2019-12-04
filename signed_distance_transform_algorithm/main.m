clear; close all; clc;

im = imread('checkerboard.jpg');
[th, sg, sgc] = cc_segm(im);
% figure; imshow(imnorm(th));
% figure; imshow(imnorm(sg));
% figure; imshow(sgc);

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
zeros(rows, 1, 'double'), sg, zeros(rows, 1, 'double');
zeros(1, cols + 2, 'double')];

bg = [zeros(1, cols + 2, 'double');
zeros(rows, 1, 'double'), not(sg), zeros(rows, 1, 'double');
zeros(1, cols + 2, 'double')];

tf = bwdist(not(fg), metric);
tb = bwdist(not(bg), metric);
dif = tf - tb;
% figure; imshow(imnorm(tf));
% figure; imshow(imnorm(tb));
% figure; imshow(imnorm(dif));

M = get_max(abs(dif), 1);
[r, c] = find(M);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUGGING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
auxdbg = zeros(rows, cols, 'double');
auxdbg(cy, cx) = 1;
auxdbg = bwdist(auxdbg, metric);
% figure; imshow(imnorm(auxdbg));
for i=2:400:rows + 1
    for j=2:400:cols + 1
        d = ceil(abs(dif(i, j)))
        subdif = dif(i-d:i+d, j-d:j+d)
        subauxdbg = auxdbg(cy-d:cy+d, cx-d:cx+d)
        subauxdbg = (subauxdbg > (d - 1)) & (subauxdbg <= d)
        if strcmp(metric, 'chessboard')
            fv = [subdif(1, :).'; subdif(2:end, end); flip(subdif(end, 1:end-1)).'; flip(subdif(2:end-1, 1))]
        elseif strcmp(metric, 'cityblock')
            fv = [diag(subdif(1:d+1, d+1:end)); diag(rot90(subdif(d+2:end, d+1:end-1))); flip(diag(subdif(d+1:end-1, 1:d))); diag(rot90(subdif(2:d, 2:d), -1))]
        else
            subaux = aux(end-d:end, 1:1+d);
            [ra, ca] = find((subaux > (d - 1)) & (subaux <= d));
            fv = [diag(subdif(ra, ca + d)); diag(subdif(d + d + 2 - flip(ra(1:end-1)), flip(ca(1:end-1)) + d)); diag(subdif(d + d + 2 - ra(2:end), d + 2 - ca(2:end))); diag(subdif(flip(ra(2:end-1)), d + 2 - flip(ca(2:end-1))))]
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DEBUGGING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
X = zeros(((rows + 2) * 2) + (cols * 2) + 4, length(r), 'double');
for k=1:length(r)
    i = r(k);
    j = c(k);
    % Verifichiamo che il pixel che stiamo considerando non appartenga al
    % padding aggiunto, come contorno, all'immagine.
    if (i > 1) && (i < (rows + 2)) && (j > 1) && (j < (cols + 2))
        v = dif(i, j);
        d = ceil(abs(v));
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
        X(1:length(fv), k) = fv;
        % i e j sono gli indici di dif, che contiene il padding
        X(end-3, k) = i - 1;
        X(end-2, k) = j - 1;
        X(end-1, k) = v;
        X(end, k) = length(fv);
    end
end
%%
sadds = zeros(rows, cols, 'uint8');
cnt = 0;
for i=2:rows + 1
    for j=2:cols + 1
        v = dif(i, j);
        d = ceil(abs(v));
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
        [m1, im1] = min(fv);
        if m1 < v
            fv = circshift(fv, -(im1 - 1));
            iM1 = find(fv(2:end) > v) + 1;
            if ~isempty(iM1)
                iM1 = iM1(1);
%                 M1 = fv(iM1);
                im2 = find(fv(iM1+1:end) < v) + iM1;
                if ~isempty(im2)
                    im2 = im2(1);
%                     m2 = fv(im2);
                    M2 = max(fv(im2+1:end));
                    if M2 > v
                        if mod(cnt, 1000) == 0
                            figure; plot(fv); hold on; plot(ones(length(fv), 1) * v);
                        end
                        sadds(i-1, j-1) = 255;
                    end
                end
            end
        end
        cnt = cnt + 1;
    end
end
%%
for i=5:360:length(r)
    sample = X(:, i);
    figure; plot(sample(1:sample(end))); hold on; plot(ones(sample(end), 1)*sample(end-1));
end
%%
sadds = zeros(rows, cols, 'uint8');
cnt = 0;
for i=1:size(X, 2)
    cnt = cnt + 1;
    i_s = X(end-3, i);
    j_s = X(end-2, i);
    v_s = X(end-1, i);
    l_s = X(end, i);
    fv_s = X(1:l_s, i);
%     if d_s == 1
%         if (im(i,j) >= im(i-d,j) && im(i,j) >= im(i+d,j) && ...
%                 im(i,j) <= im(i,j-d) && im(i,j) <= im(i,j+d)) || ...
%                 (im(i,j) <= im(i-d,j) && im(i,j) <= im(i+d,j) && ...
%                 im(i,j) >= im(i,j-d) && im(i,j) >= im(i,j+d)) || ...
%                 (im(i,j) <= im(i-d,j-d) && im(i,j) <= im(i+d,j+d) && ...
%                 im(i,j) >= im(i-d,j+d) && im(i,j) >= im(i+d,j-d)) || ...
%                 (im(i,j) >= im(i-d,j-d) && im(i,j) >= im(i+d,j+d) && ...
%                 im(i,j) <= im(i-d,j+d) && im(i,j) <= im(i+d,j-d))
%             sadds(i, j) = 255;
%         end
%     else
    [m1, im1] = min(fv_s);
    sh1 = circshift(fv_s, -im1);
    sh1 = sh1(1:end-1);
    [M1, iM1] = max(sh1);
    sh2 = circshift(sh1, -iM1);
    sh2 = sh2(1:end-1);
    [m2, im2] = min(sh2);
    sh3 = circshift(sh2, -im2);
    sh3 = sh3(1:end-1);
    M2 = max(sh3);
    if m1 < v_s && m2 < v_s && M1 > v_s && M2 > v_s
        if mod(cnt, 1000) == 0
            figure; plot(fv_s); hold on; plot(ones(l_s, 1) * v_s);
        end
        sadds(i_s, j_s) = 255;
    end
%     end
end
%%
[rs, cs] = find(sadds);

figure;
imshow(th);
hold on;
scatter(cs, rs, 'r*');

figure;
imshow(imnorm(dif(2:end-1, 2:end-1)));
hold on;
scatter(cs, rs, 'r*');