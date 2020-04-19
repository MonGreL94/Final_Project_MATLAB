function performance_threshold = compute_performance_threshold(expected)
current_threshold = NaN;
for i=1:size(expected, 1)-1
    for j=i+1:size(expected, 1)
        new_threshold = norm([expected(i, 1) - expected(j, 1), expected(i, 2) - expected(j, 2)]);
        if isnan(current_threshold) || (new_threshold < current_threshold)
            current_threshold = new_threshold;
        end
    end
end
performance_threshold = current_threshold / 2;
end