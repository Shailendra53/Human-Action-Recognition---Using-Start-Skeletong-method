%% Program to extract Human silhoutte from video.

%// read the video:
reader = VideoReader('daria_walk.avi');
vid = {};
while hasFrame(reader)
    vid{end+1} = im2single(readFrame(reader));
end
%// simple background estimation using mean:
bg = mean( cat(4, vid{:}), 4 );
%// estimate foreground as deviation from estimated background:
fIdx = 41; %// do it for frame 43
size(vid)

%for fIdx=1:19
fg = sum( abs( vid{fIdx} - bg ), 3 ) > 0.25;
se = [1,1,1;1,1,1;1,1,1];
fg = imopen(fg,se);
figure;
subplot(131); imshow( bg ); 
subplot(132); imshow( vid{fIdx} );
subplot(133); imshow( fg );
%figure, imshow(fg);

BW2 = bwmorph(fg,'skel',Inf);
center = bwmorph(BW2,'remove');
figure, imshow(center);
%% till here center lines are extracted.
%% now extracting star points.
C = corner(center);


[m,n] = size(fg);
edge_img = edge(fg, 'Canny');
vector_points = bwtraceboundary(edge_img, [x_vec(1), y_vec(1)], 'W');
size(vector_points);

img_vec = zeros(m,n);

[r,c] = size(vector_points);
for i=1:r
    img_vec(vector_points(i,1), vector_points(i,2)) = 255;
end
x_vec = zeros(count);
y_vec = zeros(count);

counter = 0;
for i=1:m
    for j=1:n
        if edge_img(i,j) ~= 0
            counter = counter + 1;
            x_vec(counter) = i;
            y_vec(counter) = j;
            
        end
    end
end
xc = sum(x_vec)/counter
yc = sum(y_vec)/counter
figure, imshow(img_vec);
%plot(C(:,1),C(:,2),'r*');
[pm,pn] = size(C);
d = inf
hx = 0;
hy = 0;
for i=1:pm
    if pdist([y_vec(1), x_vec(1); C(i,1), C(i,2)]) < d
        hx = C(i,1);
        hy = C(i,2);
        d = pdist([y_vec(1), x_vec(1); C(i,1), C(i,2)])
    end
end
cdash = zeros(pm,pn);

hold on
plot(C(:,1),C(:,2),'r*');
plot(yc,xc,'b*');
inter = zeros(m,n);
figure, imshow(center);
for i=1:m
    for j=1:n
        if center(i,j) ~= 0 && fg(i,j) ~= 0
            inter(i,j) = 1;
        end
    end
end
figure, imshow(inter);

%end
