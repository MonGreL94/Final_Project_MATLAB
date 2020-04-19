clear; close all; clc;

metrics = ["euclidean", "quasi-euclidean", "chessboard", "cityblock"];

stack = load_stack('..\images\labelled-stack.tif');

for m=1:length(metrics)

    metric = metrics(m)

    for i=1:size(stack, 3)
        i
        segmented_img = stack(:, :, i);
        
        [saddle_points, minima_coords] = get_saddle_points(segmented_img, metric);
        [saddle_points_rows, saddle_points_cols] = compute_centroids(saddle_points);
        splitted_segmented_img = draw_splitting_lines_cells(segmented_img, minima_coords);
        [new_segmented_img, new_color_segmented_img] = recoloring_segmented_cells_img(splitted_segmented_img, [85, 128, 152]);
        predicted = [saddle_points_cols, saddle_points_rows];
        
        figure;
        imshow(segmented_img);
        colormap("default");
        hold on;
        scatter(predicted(:, 1), predicted(:, 2), 'r*');
%         figure;
%         imshow(splitted_segmented_img);
%         colormap("default");
%         figure;
%         imshow(new_segmented_img);
%         colormap("default");
%         figure;
%         imshow(new_color_segmented_img);
%         colormap("default");
        
        save("C:\Users\scald\Desktop\leaf_cells_dataset_performance\v2\" + metric + "\labels\layer" + i, "predicted");
        imwrite(new_segmented_img, "C:\Users\scald\Desktop\leaf_cells_dataset_performance\v2\" + metric + "\new_segmented\layer" + i + ".jpg");
        imwrite(new_color_segmented_img, "C:\Users\scald\Desktop\leaf_cells_dataset_performance\v2\" + metric + "\new_color_segmented\layer" + i + ".jpg");
    end
end