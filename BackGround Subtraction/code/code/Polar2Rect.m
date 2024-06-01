% 读取图像
img = imread("C:\Users\tansu\Desktop\Polar&Cartesian\AfterPolar.png");
% 将图像转换为双精度类型
img = im2double(img);
% 将图像转换回极坐标
rectImg = polarToRect(img);
% 显示图像
imwrite(rectImg, "C:\Users\tansu\Desktop\Polar&Cartesian\AfterRect.png");

% Polar to Rectangular
function rectImg = polarToRect(img)
% 获取图像的大小
[M, N, ~] = size(img);
% 创建极坐标网格
[rho, theta] = meshgrid(linspace(0, 1, M), linspace(-pi, pi, N));
% 创建直角坐标网格
[X, Y] = pol2cart(theta, rho);
% 对每个通道进行插值
rectImg = zeros(M, N, size(img, 3));
for k = 1:size(img, 3)
    channel = img(:,:,k);
    rectImg(:,:,k) = interp2(X, Y, channel, Y, X, 'linear', 0);
end
% 将图像转换回原来的数据类型
rectImg = cast(rectImg, class(img));
rectImg = imrotate(rectImg, 90);
end