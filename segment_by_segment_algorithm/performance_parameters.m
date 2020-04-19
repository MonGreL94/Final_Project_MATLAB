function [TP, FP, FN, TP_error_array] = performance_parameters(expected, predicted)
TP = 0;
FP = 0;
FN = 0;
TP_error_array = NaN(size(expected, 1), 1, "double");

performance_threshold = compute_performance_threshold(expected);

for i=1:size(expected, 1)
    best_pred = NaN;
    best_dist_pred = NaN;
    for j=1:size(predicted, 1)
        new_dist = norm([expected(i, 1) - predicted(j, 1), expected(i, 2) - predicted(j, 2)]);
        if isnan(best_dist_pred) || (new_dist < best_dist_pred)
            best_pred = j;
            best_dist_pred = new_dist;
        end
    end
    if best_dist_pred < performance_threshold
        TP = TP + 1;
        TP_error_array(i) = best_dist_pred;
        predicted(best_pred, :) = [];
    else
        FN = FN + 1;
    end
end
for k=1:size(predicted, 1)
    FP = FP + 1;
end
TP_error_array = TP_error_array(~isnan(TP_error_array));
end