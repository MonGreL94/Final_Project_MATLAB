function is_a_saddle = is_a_saddle_point(fv, v)
% disp('fv:');
% disp(fv);
is_a_saddle = false;
M1 = max(fv);
M2 = max(fv(fv < M1));
mins = find(~fv);
for imin=1:length(mins)
    fvsh = circshift(fv, -(mins(imin) - 1));
%     disp('fv dopo ' + string(imin) + '-esimo shift');
%     disp(fvsh);
    values = fvsh(1:length(fvsh) / 4:end);
    if (((values(2) == M1) && (values(4) == M2)) || ((values(2) == M2) && (values(4) == M1)) || ((values(2) == M1) && (values(4) == M1))) && (values(2) > v) && (values(3) < v) && (values(4) > v)
        is_a_saddle = true;
    end
end
end