img = imread("C:\Users\tansu\Desktop\10363313859.png");

% Data from task a
center_x = 600;
center_y = 600;
radius = 470;
sector_angle = 45;

circle_image = zeros(size(img)); % Initialize the circle image

for k = 0:7
    % Extract the reference sector image for k
    original_angle = k*45;
    reference_sector = extract_sector(img, center_x, center_y, radius, original_angle , sector_angle);
    % Calculate the average of reference images
    u_sum = double(zeros(size(img)));  % Initialize the sum image to zero
    for j = 1:7
        start_angle = j * sector_angle;
        current_sector = extract_sector(img, center_x, center_y, radius, start_angle, sector_angle);
        rotation_angle = start_angle - original_angle;
        rotated_current_sector = imrotate(current_sector, rotation_angle, 'crop');
        u_sum = u_sum + double(rotated_current_sector);  % Accumulate each sector image
        
    end
    v_0 = u_sum / 7;  % Calculate the average
    % Background subtraction
    r_0 = reference_sector - v_0;
    
    % Adjust the image range to 0-255
    r_0_min = min(r_0(:));
    r_0_max = max(r_0(:));
    r_0_range = r_0_max - r_0_min;
    r_0_shifted = r_0 - r_0_min;
    r_0_scaled = (r_0_shifted / r_0_range) * 255;
    
    % Add the scaled r_0 image to the circle image
    circle_image = circle_image + r_0_scaled;
end

% Display the complete circle image
figure;
imshow(uint8(circle_image));
title('Affine Transform Image');

% Function to extract sector images
function sector_image = extract_sector(image, center_x, center_y, radius, start_angle, sector_angle)
    % Create a fully black image of the same size as the original image
    sector_image = double(zeros(size(image)));
    
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
                sector_image(y, x, :) = image(y, x, :);
            end
        end
    end
end