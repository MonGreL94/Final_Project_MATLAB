function is_a_saddle = is_a_saddle_point_v2(fv, v)
is_a_saddle = false;
[m1, im1] = min(fv);
if m1 < v
    fv = circshift(fv, -im1);
    im2 = length(fv) / 2;
    m2 = fv(im2);
    if m2 < v
        [M1, iM1] = max(fv);
        if M1 > v
            fv = circshift(fv, -iM1);
            iM2 = length(fv) / 2;
            M2 = fv(iM2);
            if M2 > v
                is_a_saddle = true;
            end
        end
    end
end
end