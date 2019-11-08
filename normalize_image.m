function normalized_img = normalize_image(img)
input_min = min(img, [], 'all');
input_max = max(img, [], 'all');
output_min = 0;
output_max = 1;
normalized_img = output_min + ((output_max - output_min) / (input_max - input_min)) * (img - input_min);
end