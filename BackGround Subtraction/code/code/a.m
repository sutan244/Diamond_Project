%attain pictures in the dataset
folder = "C:\Users\tansu\Desktop\10355792576_left_frame_0001_processed.png";
filePattern = fullfile(folder,'*.png');
pngFiles = dir(filePattern);
centersMatrix = [];
for i = 1:length(pngFiles)
    filename = fullfile(folder,pngFiles(i).name);
    Img = imread(filename);
    % gray scale image
    grayImg = rgb2gray(Img);
    % binarization
    binaryImg = imbinarize(grayImg);
    % imfindcircles detect center of diamond
    [centers,radius,metric] = imfindcircles(binaryImg, [300 600], "ObjectPolarity","bright", "Sensitivity", 1);
    [maxRadiusValue, maxRadiusIndex] = max(radius);
    center = centers(maxRadiusIndex, :);
    %fixed point
    ref_x = 0;
    ref_y = 0;
    aligned_centers = [center(:, 1) - ref_x, center(:, 2) - ref_y];
    center(:,1);
    % polar transform
    [theta, r] = cart2pol(aligned_centers(:, 1), aligned_centers(:, 2));
    centersMatrix = [centersMatrix; [theta, r]];
end
