% 读取图像
img = imread("C:\Users\tansu\Desktop\41c0c96618d3de6b371c9eb52c4cad4.png");

% 转换图像
rectImg = polarToRect(img);

% 显示图像
figure;
imshow(rectImg);

%Cartesian to Polar
function rectImg = polarToRect(img)
    % 获取图像的大小
    [M, N, ~] = size(img);
    
    % 创建极坐标网格
    [rho, theta] = meshgrid(linspace(0, 525, M), linspace(-pi, pi, N));
    
    % 创建直角坐标网格
    [X, Y] = meshgrid((1:N)-720, (1:M)-720);
    
    % 将极坐标网格转换为直角坐标网格
    [x, y] = pol2cart(theta, rho);
    
    % 对每个通道进行插值
    for k = 1:size(img, 3)
        channel = img(:,:,k);
        rectImg(:,:,k) = interp2(X, Y, double(channel), x, y, 'linear', 0);
    end
    
    % 将图像转换回原来的数据类型
    rectImg = cast(rectImg, class(img));
    rectImg = imrotate(rectImg, -90);
end
%Cartesian back to Polar
function img = rectToPolar(rectImg)
    % 获取图像的大小
    [M, N, ~] = size(rectImg);
    % 创建直角坐标网格
    [X, Y] = meshgrid((1:N)-720, (1:M)-720);
    % 将直角坐标网格转换为极坐标网格
    [theta, rho] = cart2pol(X, Y);
    % 将极坐标网格的范围调整为原始图像的范围
    theta = mod(theta, 2*pi);
    rho = rho * 525 / max(rho(:));
    % 对每个通道进行插值
    img = zeros(size(rectImg));
    for k = 1:size(rectImg, 3)
        channel = rectImg(:,:,k);
        img(:,:,k) = interp2(X, Y, double(channel), rho, theta, 'linear', 0);
    end
    % 将图像转换回原来的数据类型
    img = cast(img, class(rectImg));
    img = imrotate(img, 90);
end

% Read image

grayImg = rgb2gray(rectImg);
gauss_img = imgaussfilt(grayImg,2);

% Get image size
[height, width] = size(gauss_img);

% Calculate width of each rectangle
rect_width = width / 8;
rect_width = floor(rect_width);
% Initialize residual image
residual_img = zeros(height, width);

% For each rectangle
for i = 1:8
    % Calculate boundaries of the rectangle
    left = (i-1) * rect_width + 1;
    right = i * rect_width;
    % Extract the rectangle
    rect = gauss_img(:, left:right);

    % For each pixel in the rectangle
    for j = 1:height
        for k = 1:rect_width
            % Create a 5x5 patch
            patch = rect(max(1, j-2):min(height, j+2), max(1, k-2):min(rect_width, k+2));

            % For the remaining 7 rectangles
            mean = 0;
            for l = 1:8
                if l~=i
                    % Calculate boundaries of the rectangle
                    left_patch = (l-1) * rect_width + 1;
                    right_patch = l * rect_width;

                    % Extract the rectangle
                    other_rect = gauss_img(:, left_patch:right_patch);

                    % Extract the patch at the same position
                    other_patch = other_rect(max(1, j-2):min(height, j+2), max(1, k-2):min(rect_width, k+2));
                    [h,w] = size(other_patch);
                    
                    % Calculate and accumulate the residual
                    if ssim(patch, other_patch) < 0.3
                       mean = mean + sum(sum(abs(patch - other_patch)))/(h*w);        
                    end           

                end
            end
            residual_img(j, left+k-1) =  mean/7;
        end
    end
end

% Display the residual image
figure;
imshow(residual_img,[]);






