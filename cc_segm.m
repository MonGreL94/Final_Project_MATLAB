function [th, sg, sgc] = cc_segm(im)
th = im2bw(im);
sg = bwlabel(th);
sgb = bwlabel(~th);
sg(sg == 0) = sgb(sgb ~= 0) + max(sg(:));
cs = linspace(0, 1, max(sg(:)) + 2);
cs = cs(2:end-1);
nc = length(cs);
sgc = label2rgb(sg, [cs(randperm(nc))' cs(randperm(nc))' cs(randperm(nc))']);
% r = sgc(:, :, 1);
% g = sgc(:, :, 2);
% b = sgc(:, :, 3);
% bg = sg == 0;
% r(bg) = 0;
% g(bg) = 0;
% b(bg) = 0;
% sgc = cat(3, r, g, b);
end