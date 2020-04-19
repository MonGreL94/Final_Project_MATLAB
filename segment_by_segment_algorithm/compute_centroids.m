function [centroids_rows, centroids_cols] = compute_centroids(connected_components)
centroids_array = struct2array(regionprops(bwconncomp(connected_components, 8), "Centroid"));
centroids_rows = zeros(length(centroids_array)/2, 1);
centroids_cols = zeros(length(centroids_array)/2, 1);
for i=1:2:length(centroids_array)
    centroids_cols(ceil(i/2)) = centroids_array(i);
    centroids_rows(ceil(i/2)) = centroids_array(i + 1);
end
end