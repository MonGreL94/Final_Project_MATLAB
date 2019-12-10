file_names = dir('..\dataset');
for i=1:length(file_names)
    img = imread('..\dataset\' + string(file_names(i)));
end