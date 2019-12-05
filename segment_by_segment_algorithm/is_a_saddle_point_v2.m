function is_a_saddle = is_a_saddle_point_v2(fv, v)
is_a_saddle = false;
mins = find(~fv);
if length(mins) == 1
    fv = circshift(fv, -(mins(1) - 1));
    values = fv(1:length(fv)/4:end);
    if values(1) < v && values(2) > v && values(3) < v && values(4) > v
        is_a_saddle = true;
    end
end
end