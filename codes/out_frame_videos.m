function [out] = out_frame_videos()

foregroundDetector = vision.ForegroundDetector('NumGaussians', 3,'NumTrainingFrames', 200);
str = ["walk", "run", "jump", "side", "skip"];
names = ["daria", "denis", "eli", "ido", "ira", "lena", "lyova", "moshe", "shahar"];

for j=1:5
    for k=1:9
        path = strcat('./examples/', str(j), '/', names(k), '_', str(j), '.avi');
        path = convertStringsToChars(path);
        try
            reader = VideoReader(path);
        catch e
            disp(e)
        end
        vid = {};
        while hasFrame(reader)
            vid{end+1} = im2single(readFrame(reader));
        end
        [m,n] = size(vid);
        bg = mean( cat(4, vid{:}), 4 );
        qpath = strcat('data_check/',str(j), '/', names(k), '_', str(j), '/');
        mkdir(qpath);
        for i = 1:n
            fg = sum( abs( vid{i} - bg ), 3 ) > 0.25;
            imshow(fg); title('Foreground');
            p = strcat(qpath, num2str(i), '.jpg');
            p = convertStringsToChars(p);
            imwrite(fg, p);
        end
    end  
end

% mat1 = matfile('classification_masks.mat')
% feature_dict = mat1.aligned_masks
% x = feature_dict.daria_bend
% x = rshape


% [dzx dzy] = gradient( depth_map ); %// horizontal and vertical derivatives of depth map
% n = cat( 3, dzx, dzy, ones(size(dzx)) );
% n = bsxfun( @rdivide, n, sqrt( sum( n.^2, 3 ) ) ); %// normalize to unit length




% 
% % dir = ["bend", "jack", "pjump", "wave1", "wave2", "run", "walk", "side", "skip", "jump"]
% % types = ["side", "skip", "walk", "wave1", "wave2"]
% % names = ["daria"; "denis"; "eli"; "ido";"ira"; "lena";"lyova";"moshe";"shahar"]
% % 
% % for t = 1:6
% %     for n = 1:9
% % 
% %         dir = strcat('./dataset/', 'wave1', '/', names(n), '_', 'wave1');
% %         mkdir(dir);
% type = 'jump'
% name = strcat('shahar_',type);
% % names(n)
% video = strcat(name,'/')
% % back
% % back = fname2bgname(video)
% type = strcat(type,'/');
% 
% cpath = strcat(type, video)
% path = strcat('dataset/', cpath)
% 
% savingpath = strcat('dataset_img/', type,name,'/');
% 
% 
% % vid = VideoReader(path);
% i = 1;
% % shuttleVideo = VideoReader(back);
% % 
% % while hasFrame(shuttleVideo)
% %    img = readFrame(shuttleVideo);
% % end
% % bg = img;
% % bg = rgb2gray(bg);
% for i=5:45
% %    img = readFrame(vid);
%    %f = figure, imshow(img);
% %    img = rgb2gray(img);
% %    r = bg - img;
% %    r = imbinarize(r);
% %    
%     rr = strcat(path, num2str(i), '.jpg');
%     r = imread(rr);
%     r = imbinarize(r);
%     r = imclose(r, ones(3,3));
% %     figure, imshow(r);
%    path1 = strcat(savingpath,num2str(i));
%    path1 = strcat(path1,'.jpg');
%    [skel,feat] = star_skeleton(r, path1);
% %    figure, imshow(r)
% %    p = edge(r,'Canny');
% %    imshow(r);
% %   figure, imshow(skel);
%    
%    imwrite(skel, path1);
% %    i = i + 1;
% end

end
