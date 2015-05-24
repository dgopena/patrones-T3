% Check existing Saved Data
% =========================
if exist('Datasets/oxbuild.mat', 'file')
  if ~exist('files', 'var')
    disp('  Loading previously computed data (Datasets/oxbuild.mat)');
    load('Datasets/oxbuild.mat');
  else
    disp('  Not overwriting "files", data was probably already loaded');
  end
  return
end

% Load
% ====
disp('  Loading files and calculating features');
files = loadDataset('oxbuild_images');
fileCount = size(files, 1);


% SIFT
% ====
for i=1:fileCount
  files(i).sift_f = [];
  files(i).sift_d = [];
  files(i).path   = '';
end


parfor_progress(fileCount);
parfor i=1:fileCount
  % Load image
  files(i).path = files(i).name;
  files(i).name = strrep(files(i).path, 'Datasets/oxbuild_images/', '');
  img = imread(files(i).path);

  % Calculate SIFT
  [f, d] = vl_sift(single(gs(img)));
  files(i).sift_f = f;
  files(i).sift_d = d;

  % Report progress
  parfor_progress;
end
parfor_progress(0);

disp('Saving features to "Datasets/oxbuild.mat"');
save('Datasets/oxbuild.mat', 'files');