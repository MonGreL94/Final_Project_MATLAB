function is_a_saddle = is_a_saddle_point_bad_version(fv, v)
is_a_saddle = false;
[m1, im1] = min(fv);
if m1 < v
    fv = circshift(fv, -(im1 - 1));
    iM1 = find(fv(2:end) > v) + 1;
    if ~isempty(iM1)
        iM1 = iM1(1);
        im2 = find(fv(iM1+1:end) < v) + iM1;
        if ~isempty(im2)
            im2 = im2(1);
            M2 = max(fv(im2+1:end));
            if M2 > v
                is_a_saddle = true;
            end
        end
    end
end
end