img = imread("/Users/maoabear/Desktop/Diamond/VVS1/10352964627(G)-R1-Darkfield-01.png");
grayImg = rgb2gray(img);

% data from task a
center_x = 600;
center_y = 600;
radius = 470;
sector_angle = 45;

for k = 0:7
    original_angle = k*45;
    % Extract the reference sector image
    reference_sector = extract_sector(grayImg, center_x, center_y, radius, original_angle , sector_angle);

    u_sum = double(zeros(size(grayImg))); % Initialize image sum to zero
    for j = 1:7
        start_angle = j * sector_angle;
        current_sector = extract_sector(grayImg, center_x, center_y, radius, start_angle, sector_angle);
        % Rotate current_sector to the same position as reference_sector
        rotation_angle = start_angle - original_angle;
        rotated_current_sector = imrotate(current_sector, rotation_angle, 'crop');
        u_sum = u_sum + double(rotated_current_sector); % Accumulate each rotated sector image
    end
    v_0 = double(u_sum / 7); % Calculate the average value

    % Background subtraction
    r_0 = reference_sector - v_0;

    % Adjust the image range to 0-255 and display
    r_0_min = min(r_0(:));
    r_0_max = max(r_0(:));
    r_0_range = r_0_max - r_0_min;
    r_0_shifted = r_0 - r_0_min;
    r_0_scaled = uint8((r_0_shifted / r_0_range) * 255);
    
    % Display the transformed r_0 image
    subplot(2, 4, k+1);
    imshow(r_0_scaled);
    title(sprintf('u_%d', k));   
end

% 提取扇形图像的函数
function sector_image = extract_sector(image, center_x, center_y, radius, start_angle, sector_angle)
    % 创建一个与原始图像相同大小的全黑图像
    sector_image = double(zeros(size(image)));
    
    % 对于图像中的每个像素(x, y)
    for x = 1:size(image, 2)
        for y = 1:size(image, 1)
            % 计算像素(x, y)到圆心的距离
            distance = sqrt((x - center_x)^2 + (y - center_y)^2);
            
            % 计算像素(x, y)到圆心的角度
            angle = atan2d(y - center_y, x - center_x);
            
            % 将角度映射到0-360度范围
            if angle < 0
                angle = angle + 360;
            end
            
            % 判断像素(x, y)是否在扇形区域内
            if distance <= radius && angle >= start_angle && angle < start_angle + sector_angle
                % 如果是扇形区域内的像素，则将其值赋为原始图像对应位置的像素值
                sector_image(y, x) = image(y, x);
            end
        end
    end
end

