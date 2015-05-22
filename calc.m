% Setup
% =====
procCount = 8;


% Load
% ====
files = loadDataset('oxbuild_images');
fileCount = size(files, 1);


% SIFT
% ====
parfor_progress(idivide(fileCount, int16(20)));
parfor(i=1:fileCount, procCount)
  % Load image
  name = files(i).name;
  img = imread(name);

  % Calculate SIFT
  [files(i).sift_f, files(i).sift_d] = sift(img);

  % Report progress
  if(mod(i, 20)==0)
    parfor_progress;
  end
end
parfor_progress(0);
