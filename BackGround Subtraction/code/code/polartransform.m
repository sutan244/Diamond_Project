% 读取图像
img = imread("C:\Users\tansu\Desktop\10345765889.png");

% 转换图像
rectImg = polarToRect(img);

% 显示图像
imshow(rectImg);

function rectImg = polarToRect(img)
    % 获取图像的大小
    [M, N, ~] = size(img);
    
    % 创建极坐标网格
    [rho, theta] = meshgrid(linspace(0, 540, M), linspace(-pi, pi, N));
    
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


