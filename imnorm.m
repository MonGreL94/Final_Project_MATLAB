function newim = imnorm(im)
m = min(im(:));
newim = im - m;
M = max(newim(:));
newim = newim / M;
end