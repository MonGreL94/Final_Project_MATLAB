clear; close all; clc;

metrics = ["euclidean", "quasi-euclidean", "chessboard", "cityblock"];
files = dir("C:\Users\scald\Desktop\dataset\matrix");

for m=1:length(metrics)

    metric = metrics(m)

    all_TP = 0;
    all_FP = 0;
    all_FN = 0;
    all_TP_error_array = [];
    
    for i=3:length(files)
        segmented_img = struct2array(load("C:\Users\scald\Desktop\dataset\matrix\" + string(files(i).name)));
        expected = struct2array(load("C:\Users\scald\Desktop\dataset\labels\" + string(files(i).name)));

        [saddle_points, minima_coords] = get_saddle_points(segmented_img, metric);
        [saddle_points_rows, saddle_points_cols] = compute_centroids(saddle_points);
        [splitted_segmented_img, new_segments] = draw_splitting_lines(segmented_img, minima_coords);
        [new_segmented_img, new_color_segmented_img] = recoloring_segmented_img(splitted_segmented_img, new_segments);

        predicted = [saddle_points_cols, saddle_points_rows];
        [TP, FP, FN, TP_error_array] = performance_parameters(expected, predicted);

        all_TP = all_TP + TP;
        all_FP = all_FP + FP;
        all_FN = all_FN + FN;
        all_TP_error_array = [all_TP_error_array; TP_error_array];

%         figure;
%         imshow(segmented_img, []);
%         colormap("default");
%         figure;
%         imshow(splitted_segmented_img);
%         colormap("default");
%         figure;
%         imshow(new_segmented_img);
%         colormap("default");
%         figure;
%         imshow(new_color_segmented_img);
%         colormap("default");
%         hold on;
%         scatter(predicted(:, 1), predicted(:, 2), 'r*');
%         scatter(expected(:, 1), expected(:, 2), 'g*');

        save("C:\Users\scald\Desktop\dataset\performance\v2_gt\" + metric + "\labels\" + string(files(i).name), "predicted");
        imwrite(new_segmented_img, "C:\Users\scald\Desktop\dataset\performance\v2_gt\" + metric + "\new_segmented\" + erase(string(files(i).name), ".mat") + ".jpg");
        imwrite(new_color_segmented_img, "C:\Users\scald\Desktop\dataset\performance\v2_gt\" + metric + "\new_color_segmented\" + erase(string(files(i).name), ".mat") + ".jpg");
    end

    [precision, recall, f1_score, mean_error, error_variance] = performance_indices(all_TP, all_FP, all_FN, all_TP_error_array)

end