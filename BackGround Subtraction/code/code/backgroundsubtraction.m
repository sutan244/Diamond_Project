img = imread("C:\Users\tansu\Desktop\10345765889.png");


% Data from task a
[height, width] = size(img);
center_x = floor(width/6);
center_y = floor(height/2);
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

% Convert the output image back to uint8 and display it
output_img = uint8(output_img * 255);
figure;
imshow(rgb2gray(output_img));
title('Affine Transform Image');

% Function to extract sector images
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
