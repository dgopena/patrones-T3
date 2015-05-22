% Setup local cluster
% ===================
if matlabpool('size') == 0 % checking to see if my pool is already open
  matlabpool open 8
end

% Load
% ====
files = loadDataset('oxbuild_images');
fileCount = size(files, 1);


% SIFT
% ====
for i=1:fileCount
  files(i).sift_f = [];
  files(i).sift_d = [];
end

parfor_progress(fileCount);
parfor i=1:fileCount
  % Load image
  name = files(i).name;
  img = imread(name);

  % Calculate SIFT
  [f, d] = vl_sift(single(gs(img)));
  files(i).sift_f = f;
  files(i).sift_d = d;

  % Report progress
  parfor_progress;
end
parfor_progress(0);
