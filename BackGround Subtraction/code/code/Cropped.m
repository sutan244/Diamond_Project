function cropped_img = crop_image_to_1440x1440(img)
    % 获取原始图像的大小
    [original_height, original_width, num_channels] = size(img);
    
    % 目标尺寸
    target_size = 1440;
    
    % 计算裁剪的起始点
    start_height = floor((original_height - target_size) / 2) + 1;
    start_width = floor((original_width - target_size) / 2) + 1;
    
    % 确保裁剪范围在图像范围内
    end_height = start_height + target_size - 1;
    end_width = start_width + target_size - 1;
    
    % 裁剪图像
    cropped_img = img(start_height:end_height, start_width:end_width, :);
end
% 读取原始图像
img = imread('C:\Users\tansu\Desktop\64234ead19cfb1724b8bb4c9eee09c3.png');

% 调用函数裁剪图像
cropped_img = crop_image_to_1440x1440(img);

% 显示裁剪后的图像
imshow(cropped_img);

% 保存裁剪后的图像
imwrite(cropped_img, 'C:\Users\tansu\Desktop\cropped.png');