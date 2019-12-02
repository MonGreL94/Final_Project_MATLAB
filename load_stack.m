function stack = load_stack(file_name)
number_of_images = size(imfinfo(file_name), 1);
img = imread(file_name, 1);
stack = zeros(size(img, 1), size(img, 2), number_of_images, 'uint8');
stack(:, :, 1) = img;
for i=2:number_of_images
    stack(:, :, i) = imread(file_name, i);
end
end