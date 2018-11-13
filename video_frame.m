
shuttleVideo = VideoReader('C:\Users\Asus\Desktop\matlab\CV_Project\walk\denis_walk.avi');
workingDir = 'C:\Users\Asus\Desktop\matlab\CV_Project';
ii = 1;

while hasFrame(shuttleVideo)
   img = readFrame(shuttleVideo);
   filename = [sprintf('%03d',ii) '.jpg'];
   fullname = fullfile(workingDir,'images1',filename);
   imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
   ii = ii+1;
end