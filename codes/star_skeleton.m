function [skeleton, features] = star_skeleton(image, pp)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% extracting contour of human silhoutte.
features = zeros(6,3);

% image = imread(image);
% image = imbinarize(image);
% image = imopen(image, ones(5,5));
[m,n] = size(image);
skeleton = zeros(m,n);
edge_img = edge(image, 'Canny');
% figure, imshow(edge_img);

%% tracing contour in order and calculating centroid of the boundary.
count = 0;
x = 0;
y = 0;
x_vec = [1];
y_vec = [1];
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
if size(x_vec) <= 1
    return
end
vector_points = bwtraceboundary(edge_img, [x_vec(1), y_vec(1)], 'W');
[vr,vc] = size(vector_points);  % size of vector points.
% centroid of the star skeleton.
xc = double(sum(vector_points(:,1))/vr);
yc = double(sum(vector_points(:,2))/vr);

%% calculating distance of each point from centroid.

distance_vector = zeros(vr,1);
for i=1:vr
    distance_vector(i) = sqrt((vector_points(i,1) - xc)^2 + (vector_points(i,2) - yc)^2);
end

try 
    [pks, pos] = findpeaks(distance_vector);
    [pr, pc] = size(pos);
catch ME
    return
end
%% adding extra points.
if pr < 5
    pos(pr+1,1) = 1;
    pks(pr+1,1) = distance_vector(1);
    pos(pr+2,1) = ceil(vr/5);
    pks(pr+2,1) = distance_vector(ceil(vr/5));
    pos(pr+3,1) = ceil(2*vr/5);
    pks(pr+3,1) = distance_vector(ceil(2*vr/5));
    pos(pr+4,1) = ceil(3*vr/5);
    pks(pr+4,1) = distance_vector(ceil(3*vr/5));
    pos(pr+5,1) = ceil(4*vr/5);
    pks(pr+5,1) = distance_vector(ceil(4*vr/5));
end
[pr, pc] = size(pos);
comp_angle = 5;
iter = 0;
while sum(pos >0) > 5
    for p=1:pr
        for c=1:pr

            if pos(p) ~= -1 && pos(c) ~= -1 && c ~= p

                slope1 = double((vector_points(pos(c),2) - yc)/(vector_points(pos(c),1) - xc));
                slope2 = double((vector_points(pos(p),2) - yc)/(vector_points(pos(p),1) - xc));
                angle = atan((slope2 - slope1)/(1 + slope1*slope2))*180/pi;
                if abs(angle) < comp_angle && (abs(vector_points(pos(c),1) - vector_points(pos(p),1)) < 10 )
                    if pks(c) > pks(p)
                        pos(p) = -1;
                    else
                        pos(c) = -1;
                        c=c+1;
                   end
                end
            end
        end
    end
    if iter > 100
        break
    end
    iter = iter + 1;
    comp_angle = comp_angle + 1;
end
new_img = zeros(m,n);

for i=1:pr
    if pos(i) > 0
        new_img(vector_points(pos(i),1), vector_points(pos(i),2)) = 255;
        
    end
end
xc = uint8(xc);
yc = uint8(yc);
new_img(xc,yc) = 255;
xc = double(xc);
yc = double(yc);
% new_img(100,10) = 255;
% f = figure;
% figure,imshow(new_img);
% hold/ on;
dis = sqrt((m/2 - xc)^2 + (n/2 - yc)^2);
features(1,:) = [yc,xc,dis/90.0];
it = 2;
for i=1:pr
    if pos(i) > 0
        
        angle = atan(double((vector_points(pos(i),2) - yc)/(vector_points(pos(i),1) - xc)))*180/pi;
        double(vector_points(pos(i),2) - yc);
        double(vector_points(pos(i),1) - xc) ;
        if (vector_points(pos(i),2) - yc) == 0 || (vector_points(pos(i),1) - xc) == 0 
            angle = 0;
        elseif (vector_points(pos(i),2) - yc) > 0 && (vector_points(pos(i),1) - xc) < 0
            angle = 180 - abs(angle);
        elseif (vector_points(pos(i),2) - yc) < 0 && (vector_points(pos(i),1) - xc) < 0
            angle = abs(angle) + 180;
        elseif (vector_points(pos(i),2) - yc) < 0 && (vector_points(pos(i),1) - xc) > 0
            angle = 360 - abs(angle);
        end
        features(it,:) = [vector_points(pos(i),2), vector_points(pos(i),1), angle/360.0];
        new_img = func_line(new_img, xc, yc, vector_points(pos(i),1), vector_points(pos(i),2), 255);
%         line([yc, vector_points(pos(i),2)], [xc, vector_points(pos(i),1)], 'color', [1,1,1]);
        it = it + 1;
        if it > 6
            break
        end
    end
end
% hold off;

skeleton = new_img;
% figure, imshow(new_img);
end

