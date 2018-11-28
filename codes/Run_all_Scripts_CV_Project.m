%% Extracting Silhouette from given videos.

disp('Generating silhouettes');
in_frame_videos();
out_frame_videos();
disp('Silhouettes Generated');

%% dataset generating part.....

disp('Generating Dataset from Human Silhouettes.');
dataset_generation();
disp('Dataset Generated.');
disp('Now Use python module "RunTrainingModel.py" to train the model on generated training data.');


%% Running python module.

%  commandStr = 'python cnn.py';
%  [status, commandOut] = system(commandStr);
%  commandOut
%  if status==0
%      fprintf('squared result is %s\n',commandOut);
%  end