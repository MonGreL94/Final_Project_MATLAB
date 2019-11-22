function maxima = get_max(im, d)
s = size(im);
rows = s(1);
cols = s(2);
maxima = zeros(rows, cols, 'uint8');
for i=1+d:rows-d
    for j=1+d:cols-d
        if (im(i,j) >= im(i-d,j) && im(i,j) >= im(i+d,j) && ...
                im(i,j) >= im(i,j-d) && im(i,j) >= im(i,j+d)) && ...
                (im(i,j) >= im(i-d,j-d) && im(i,j) >= im(i+d,j+d) && ...
                im(i,j) >= im(i-d,j+d) && im(i,j) >= im(i+d,j-d))
            maxima(i, j) = 255;
        end
    end
end
end