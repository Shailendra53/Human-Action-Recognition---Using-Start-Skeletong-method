%% Program to extract Human silhoutte from video.

%// read the video:
reader = VideoReader('C:\Users\Asus\Desktop\matlab\CV_Project\run\ido_run.avi');
vid = {};
while hasFrame(reader)
    vid{end+1} = im2single(readFrame(reader));
end
%// simple background estimation using mean:
bg = mean( cat(4, vid{:}), 4 );
%// estimate foreground as deviation from estimated background:
fIdx = 41; %// do it for frame 43
size(vid)

for fIdx=1:50
fg = sum( abs( vid{fIdx} - bg ), 3 ) > 0.25;
se = ones(3,3)
fg = imopen(fg,se);
%{
figure;
subplot(131); imshow( bg ); 
subplot(132); imshow( vid{fIdx} );
subplot(133); imshow( fg );
%}
%figure, imshow(fg);

BW2 = bwmorph(fg,'skel',Inf);
center = bwmorph(BW2,'remove');
%figure, imshow(center);
%% till here center lines are extracted.
%% now extracting star points.
C = corner(center);


[m,n] = size(fg);
edge_img = edge(fg, 'Canny');

%calculating centroid of the boundary.
count = 0;
x = 0;
y = 0;


%edge_img(xc,yc) = 255;

%figure, imshow(edge_img);

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

vector_points = bwtraceboundary(edge_img, [x_vec(1), y_vec(1)], 'W');
[vr,vc] = size(vector_points);
xc = uint8(sum(vector_points(:,1))/vr)
yc = uint8(sum(vector_points(:,2))/vr)

%{
hold on
plot(vector_points(1,2),vector_points(1,1),'.');
plot(vector_points(310,2),vector_points(310,1),'r*');
plot(vector_points(73,2),vector_points(73,1),'b*');
plot(vector_points(151,2),vector_points(151,1),'g*');
plot(vector_points(267,2),vector_points(267,1),'y*');
hold off
%}
img_vec = zeros(m,n);

[r,c] = size(vector_points);
for i=1:r
    img_vec(vector_points(i,1), vector_points(i,2)) = 255;
end

%figure, imshow(img_vec);

distance_vector = zeros(r,1);

xc = double(xc);
yc = double(yc);

for i=1:r
    distance_vector(i) = sqrt((vector_points(i,1) - xc)^2 + (vector_points(i,2) - yc)^2);
end

[dr, dc] = size(distance_vector);
q = [1:dr];
%figure, plot(q,distance_vector);
distance_vector
smooth_vector = smooth(distance_vector);
%figure, plot(q,smooth_vector);
%findpeaks(smooth_vector);
[pks, pos] = findpeaks(smooth_vector);

[pr, pc]= size(pos);

if pr < 5
pos(pr+1,1) = 1;
pks(pr+1,1) = smooth_vector(1);

pos(pr+2,1) = ceil(vr/5);
pks(pr+2,1) = smooth_vector(ceil(vr/5));
pos(pr+3,1) = ceil(2*vr/5);
pks(pr+3,1) = smooth_vector(ceil(2*vr/5));
pos(pr+4,1) = ceil(3*vr/5);
pks(pr+4,1) = smooth_vector(ceil(3*vr/5));
pos(pr+5,1) = ceil(4*vr/5);
pks(pr+5,1) = smooth_vector(ceil(4*vr/5));
end
[pr, pc]= size(pos);
new_img = zeros(m,n);
angle = zeros(pr,1);
pos
pks
%{
figure, imshow(new_img);
hold on;
for i=1:pr
    if pos(i) > 0
         
        line([yc, vector_points(pos(i),2)], [xc, vector_points(pos(i),1)], 'color', [1,1,1]);
    end
end
hold off
%}
comp_angle = 5;
index = 1;
while sum(pos >0) > 5
    for p=1:pr
        for c=1:pr

            if pos(p) ~= -1 && pos(c) ~= -1 && c ~= p

                slope1 = (vector_points(pos(c),2) - yc)/(vector_points(pos(c),1) - xc);
                slope2 = (vector_points(pos(p),2) - yc)/(vector_points(pos(p),1) - xc);
                angle = atan((slope2 - slope1)/(1 + slope1*slope2))*180/pi;
                if abs(angle) < comp_angle && abs(vector_points(pos(c),1) - vector_points(pos(p),1)) < 10
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
    pos
    comp_angle = comp_angle + 1;
    
  %{  
figure, imshow(new_img);
hold on;
for i=1:pr
    if pos(i) > 0
         
        line([yc, vector_points(pos(i),2)], [xc, vector_points(pos(i),1)], 'color', [1,1,1]);
    end
end
hold off
%}
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
end