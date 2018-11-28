function [out] = dataset_generation()
%% Actions list
dir = ["bend", "jack", "pjump", "wave1", "wave2", "run", "walk", "side", "skip", "jump"];

%% Training data generation.....
% names of the people in train dataset.
names = ["daria", "denis", "eli", "ido", "ira", "lena", "lyova"];
% dataset matrix.....
data = zeros(1, 15, 6);

% corresponding label matrix.....
label = zeros(1,1);
count = 0;
% loop to update data and label matrix.....
for i=1:10
    for j=1:7
        count = count + 1;
        label(count,1) = i-1;
        
        cc = 1;
        for k =1:28
            path = strcat('data_check/', dir(i), '/', names(j), '_', dir(i), '/', num2str(k), '.jpg');
            path = convertStringsToChars(path);
            img = imread(path);
            img = imbinarize(img);
            img = imopen(img, ones(5,5));
            [skeleton, features] = star_skeleton(img);
            data(count, cc, :) = features(:,3);
            cc = cc + 1;
        end
        
    end
end

% saving matrix data to .mat file for model training..
save('save_dataset_train1.mat', 'data');
save('save_label_train1.mat', 'label');

%% Test data generation.....
% names of the people in test dataset.
names = ["moshe", "shahar"];
% dataset matrix.....
data = zeros(1, 15, 6);
% corresponding label matrix.....
label = zeros(1,1);
count = 0;
% loop to update data and label matrix.....
for i=1:10
    for j=1:2
        count = count + 1;
        label(count,1) = i-1;
        
        cc = 1;
        for k =1:28
            path = strcat('data_check/', dir(i), '/', names(j), '_', dir(i), '/', num2str(k), '.jpg');
            path = convertStringsToChars(path);
            img = imread(path);
            img = imbinarize(img);
            img = imopen(img, ones(5,5));
            [skeleton, features] = star_skeleton(img);
            data(count, cc, :) = features(:,3);
            cc = cc + 1;
        end
        
    end
end

% saving test matrix for testing models....
save('save_dataset_test1.mat', 'data');
save('save_label_test1.mat', 'label');

end

