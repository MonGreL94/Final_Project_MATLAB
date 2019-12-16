function [TP, FP, FN, precision, recall, f1_score, mean_error, error_variance, error] = performance_evaluation(expected, predicted)
tp = zeros(size(expected, 1), 1, 'logical');
fp = ones(size(predicted, 1), 1, 'logical');
fn = zeros(size(expected, 1), 1, 'logical');
error = zeros(size(expected, 1), 1);
for i=1:size(expected, 1)
    best_pred = 1;
    best_dist_pred = norm([expected(i, 1) - predicted(1, 1), expected(i, 2) - predicted(1, 2)]);
    for j = 2:size(predicted, 1)
        if fp(j)
            actual_dist = norm([expected(i, 1) - predicted(j, 1), expected(i, 2) - predicted(j, 2)]);
            if actual_dist < best_dist_pred
                best_pred = j;
                best_dist_pred = actual_dist;
            end
        end
    end
    if best_dist_pred < 5
        error(i) = best_dist_pred;
        tp(i) = 1;
        fp(best_pred) = 0;
    else
        fn(i) = 1;
    end
end
TP = sum(tp);
FP = sum(fp);
FN = sum(fn);
precision = TP / (TP + FP);
recall = TP / (TP + FN);
f1_score = 2 * (precision * recall) / (precision + recall);
error = error(tp);
mean_error = mean(error);
error_variance = var(error);
end