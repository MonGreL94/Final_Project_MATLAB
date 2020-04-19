function [precision, recall, f1_score, mean_error, error_variance] = performance_indices(TP, FP, FN, TP_error_array)
if (TP + FP) ~= 0
    precision = TP / (TP + FP);
else
    precision = 0;
end
if (TP + FN) ~= 0
    recall = TP / (TP + FN);
else
    recall = 0;
end
if (precision + recall) ~= 0
    f1_score = 2 * precision * recall / (precision + recall);
else
    f1_score = 0;
end
mean_error = mean(TP_error_array);
error_variance = var(TP_error_array);
end