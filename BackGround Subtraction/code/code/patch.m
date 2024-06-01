% Read image
img = imread("/Users/maoabear/Desktop/截屏2024-03-19 下午9.18.41.png");
grayImg = rgb2gray(img);

% Get image size
[height, width] = size(grayImg);

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
    rect = grayImg(:, left:right);

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
                    other_rect = grayImg(:, left_patch:right_patch);

                    % Extract the patch at the same position
                    other_patch = other_rect(max(1, j-2):min(height, j+2), max(1, k-2):min(rect_width, k+2));
                    [h,w] = size(other_patch);
                    

                    % Calculate and accumulate the residual
                    
                    mean = mean + sum(sum(abs(patch - other_patch)))/(h*w);
                    
                    
                end
            end
            residual_img(j, left+k-1) =  mean/7;
        end
    end
end

% Display the residual image
imshow(residual_img,[]);
