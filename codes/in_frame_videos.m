function [out] = in_frame_videos()


%% function to generate silhoutte of in frame images.....
% types of inframe videos
types = ["bend", "jack", "pjump", "wave1", "wave2"];
% nmae sof people in dataset
names = ["daria", "denis", "eli", "ido", "ira", "lena", "lyova", "moshe", "shahar"];
% loop to generate silhouette.
for i=1:5
    for j=1:9
        
        type = convertStringsToChars(types(i));
        name = convertStringsToChars(names(j));
        video = strcat(name,'_',type,'.avi');
        back = fname2bgname(video);
        vid_path = strcat('examples/',type,'/',name,'_',type,'.avi');
%         path = strcat('examples/', vid_path);

        savingpath = strcat('data_check/', type, '/',name,'_', type, '/');
        mkdir(savingpath);
        vid = VideoReader(vid_path);
        back_video = VideoReader(back);

        while hasFrame(back_video)
           img = readFrame(back_video);
        end
        bg = img;
        bg = rgb2gray(bg);
        count = 0;
        while hasFrame(vid)
            img = readFrame(vid);
            img = rgb2gray(img);
            sil = bg - img;
            sil = imbinarize(sil);
            sil = imclose(sil, ones(3,3));
           path1 = strcat(savingpath,num2str(count), '.jpg');
           imwrite(sil, path1);
           count = count + 1;
        end
    end
end


end
