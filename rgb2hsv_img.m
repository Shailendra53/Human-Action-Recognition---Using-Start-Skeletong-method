img = imread('C:\Users\Asus\Desktop\matlab\CV_Project\images\024.jpg');
hsv_img = rgb2hsv(img);
%figure, imshow(hsv_img);
extimg = img;
img = double(img);

[m,n,z] = size(img);

new_img = zeros(m,n,z);
new_img = double(new_img);

% hsv calculation.....
for i=1:m
    for j=1:n
        
        r = img(i,j,1)/255;
        g = img(i,j,2)/255;
        b = img(i,j,3)/255;
        
        cmax = max([r,g,b]);
        cmin = min([r,g,b]);
        
        delta = cmax - cmin;
        
        if delta == 0
            new_img(i,j,1) = 0;
        elseif cmax == r
            new_img(i,j,1) = 60*mod((g-b)/delta,6);
        elseif cmax == g
            new_img(i,j,1) = 60*(((b-r)/delta) + 2);
        elseif cmax == b
            new_img(i,j,1) = 60*(((r-g)/delta) + 4);
        end
        
        if cmax == 0
            new_img(i,j,2) = 0;
        else
            new_img(i,j,2) = delta/cmax;
        end
        
        new_img(i,j,3) = cmax;
        
    end
end

new_img2 = zeros(m,n,z);
new_img2 = double(new_img2);

% modified hls space.....
for i=1:m
    for j=1:n
        
        r = img(i,j,1);
        g = img(i,j,2);
        b = img(i,j,3);
        
        m = min(g,b);
        
        if r == m
            new_img2(i,j,1) = -1;
        elseif m == g
            new_img2(i,j,1) = 60*((b-r)/(m-r));
        elseif m == b
            new_img2(i,j,1) = 60*((r-g)/(m-r));
        end
        
        if new_img2(i,j,1) < 0
            new_img2(i,j,1) = new_img2(i,j,1) + 360;
        end
        
        new_img2(i,j,2) = (m+r)/2;
        
        if r == m
            new_img2(i,j,3) = 0;
        elseif new_img2(i,j,2) <= 0.5
            new_img2(i,j,3) = (m-r)/(m+r);
        else
            new_img2(i,j,3) = (m-r)/(2-m-r);
        end 
    end
end

figure, imshow(hsv_img(:,:,1));
figure, imshow(hsv_img(:,:,2));
figure, imshow(hsv_img(:,:,3));

%Split into RGB Channels
Red = hsv_img(:,:,1);
Green = hsv_img(:,:,2);
Blue = hsv_img(:,:,3);

%Get histValues for each channel
[yRed, x] = imhist(Red);
[yGreen, x] = imhist(Green);
[yBlue, x] = imhist(Blue);

%Plot them together in one plot
figure,plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue');

mm = mode(mode(hsv_img(:,:,2)))
%figure, imshow(img);
[m,n,z] = size(img);
nimg = zeros(m,n);


for i=1:m
    for j=1:n
        if hsv_img(i,j,2) > 0.3 && hsv_img(i,j,2) < .8
            nimg(i,j) = 255;
        end
    end
end

se = ones(5,5);
nimg = imdilate(nimg,se);
nimg = imdilate(nimg,se);
se = ones(7,7);
nimg = imerode(nimg,se);

for i=1:m
    for j=1:n
        if nimg(i,j) == 0
            extimg(i,j,:) = [0,0,0];
        end
    end
end

figure, imshow(nimg);
figure, imshow(extimg);

edge_img = edge(nimg, 'Canny');


%calculating centroid of the boundary.
count = 0;
x = 0;
y = 0;
for i=1:m
    for j=1:n
        if edge_img(i,j) ~= 0
            count = count + 1;
            x = x + i;
            y = y + j;
        end
    end
end

xc = uint8(x/count)
yc = uint8(y/count)

%edge_img(xc,yc) = 255;

figure, imshow(edge_img);

x_vec = zeros(count);
y_vec = zeros(count);

counter = 1;
for i=1:m
    for j=1:n
        if edge_img(i,j) ~= 0
            x_vec(counter) = i;
            y_vec(counter) = j;
            counter = counter + 1;
        end
    end
end

%figure, plot(x_vec,y_vec,'.');

vector_points = bwtraceboundary(edge_img, [x_vec(1), y_vec(1)], 'W');
size(vector_points);

img_vec = zeros(m,n);

[r,c] = size(vector_points);
for i=1:r
    img_vec(vector_points(i,1), vector_points(i,2)) = 255;
end

figure, imshow(img_vec);

distance_vector = zeros(r,1);

xc = double(xc);
yc = double(yc);

for i=1:r
    distance_vector(i) = sqrt((vector_points(i,1) - xc)^2 + (vector_points(i,2) - yc)^2);
end

distance_vector
disp('gdfgfd');
[dr, dc] = size(distance_vector);
q = [1:dr]
figure, plot(q,distance_vector);

smooth_vector = smooth(distance_vector);
figure, plot(q,smooth_vector);
findpeaks(smooth_vector)
[pks, pos] = findpeaks(smooth_vector)

[pr, pc]= size(pos);
    
new_img = zeros(m,n);
for i=2:pr
    if pos(i) - pos(i-1) < 20
        pos(i) = -1;
    end
end
for i=1:pr
    if pos(i) > 0
        new_img(vector_points(pos(i),1), vector_points(pos(i),2)) = 255;
        
    end
end
new_img(xc,yc) = 255;

figure, imshow(new_img);
hold on;
for i=1:pr
    if pos(i) > 0
         
        line([yc, vector_points(pos(i),2)], [xc, vector_points(pos(i),1)], 'color', [1,1,1]);
    end
end


%{
pi = 0;
pj = 0;

for i=1:m
    for j=1:n
        if edge_img(i,j) ~= 0
            pi = i;
            pj = j;
            break;
        end
    end
end
%}
