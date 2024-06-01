input_folder = '/Users/hanyufeng/fsdownload/finally';  % 输入文件夹路径
output_folder = '/Users/hanyufeng/fsdownload/final';  % 输出文件夹路径
% 获取输入文件夹中的所有图像文件路径
image_files = dir(fullfile(input_folder, '*.png'));  % 假设图像文件扩展名为.png

% 遍历每个图像文件
for i = 1:numel(image_files)
    % 构建输入和输出文件的完整路径
    input_file = fullfile(input_folder, image_files(i).name);
    output_file = fullfile(output_folder, image_files(i).name);

    % 读取图像
    img = imread(input_file);

% Data from task a
center_x = 600;
center_y = 600;
radius = 470;
sector_angle = 45;

% Initialize the output image
output_img = zeros(size(img));

% Process each color channel separately
for channel = 1:3
    grayImg = double(img(:,:,channel)) / 255;  % Convert to double and normalize

    circle_image = zeros(size(grayImg)); % Initialize the circle image

    for k = 0:7
        original_angle = k*45;
        % Extract the reference sector image
        reference_sector = extract_sector(grayImg, center_x, center_y, radius, original_angle , sector_angle);

        u_sum = zeros(size(grayImg)); % Initialize image sum to zero
        for j = 1:7
            start_angle = j * sector_angle;
            current_sector = extract_sector(grayImg, center_x, center_y, radius, start_angle, sector_angle);
            % Rotate current_sector to the same position as reference_sector
            rotation_angle = start_angle - original_angle;
            rotated_current_sector = imrotate(current_sector, rotation_angle, 'crop');
            u_sum = u_sum + rotated_current_sector; % Accumulate each rotated sector image
        end
        v_0 = u_sum / 7; % Calculate the average value

        % Background subtraction
        r_0 = reference_sector - v_0;

        % Adjust the image range to 0-1 and add to the circle image
        r_0_min = min(r_0(:));
        r_0_max = max(r_0(:));
        r_0_range = r_0_max - r_0_min;
        r_0_shifted = r_0 - r_0_min;
        r_0_scaled = (r_0_shifted / r_0_range);

        % Add the scaled r_0 image to the circle image
        circle_image = circle_image + r_0_scaled;

        % Normalize the circle image to 0-1 range after each addition
        circle_image = (circle_image - min(circle_image(:))) / (max(circle_image(:)) - min(circle_image(:)));
    end

    % Store the processed channel in the output image
    output_img(:,:,channel) = circle_image;
end

    imwrite(rgb2gray(output_img), output_file);
end

function sector_image = extract_sector(image, center_x, center_y, radius, start_angle, sector_angle)
    % Create a fully black image of the same size as the original image
    sector_image = zeros(size(image));
    
    % For each pixel (x, y) in the image
    for x = 1:size(image, 2)
        for y = 1:size(image, 1)
            % Calculate the distance from the pixel (x, y) to the center
            distance = sqrt((x - center_x)^2 + (y - center_y)^2);
            
            % Calculate the angle from the pixel (x, y) to the center
            angle = atan2d(y - center_y, x - center_x);
            
            % Map the angle to the range of 0-360 degrees
            if angle < 0
                angle = angle + 360;
            end
            
            % Check if the pixel (x, y) is within the sector region
            if distance <= radius && angle >= start_angle && angle < start_angle + sector_angle
                % If it's a pixel within the sector region, assign its value to the corresponding position in the original image
                sector_image(y, x) = image(y, x);
            end
        end
    end
end
