clear; close all; clc;

im = imread('checkerboard.jpg');
[th, sg, sgc] = cc_segm(im);
% figure; imshow(imnorm(th));
% figure; imshow(imnorm(sg));
% figure; imshow(sgc);

metric = 'quasi-euclidean';

rows = size(sg, 1);
cols = size(sg, 2);
cx = ceil(cols / 2);
cy = ceil(rows / 2);

if strcmp(metric, 'euclidean') || strcmp(metric, 'quasi-euclidean')
    aux = zeros(rows, cols, 'double');
    aux(end, 1) = 1;
    aux = bwdist(aux, metric);
    % figure; imshow(imnorm(aux));
end

fg = [zeros(1, cols + 2, 'double');
zeros(rows, 1, 'double'), sg, zeros(rows, 1, 'double');
zeros(1, cols + 2, 'double')];

bg = [zeros(1, cols + 2, 'double');
zeros(rows, 1, 'double'), not(sg), zeros(rows, 1, 'double');
zeros(1, cols + 2, 'double')];
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
[rs, cs] = find(sadds);

figure;
imshow(th);
hold on;
scatter(cs, rs, 'r*');

figure;
imshow(imnorm(dif(2:end-1, 2:end-1)));
hold on;
scatter(cs, rs, 'r*');