function is_a_saddle = is_a_saddle_point_v2(fv, v)
is_a_saddle = false;
mins = find(~fv);
% if length(mins) == 1
for imin=1:length(mins)
    fv = circshift(fv, -(mins(imin) - 1));
    values = fv(1:length(fv)/4:end);
    if (values(2) == max(fv(:)) || values(4) == max(fv(:))) && v && values(2) > v && values(3) < v && values(4) > v
        is_a_saddle = true;
    end
end
% end
end