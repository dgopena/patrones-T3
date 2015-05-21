% Load the Dataset Directory
files = loadDataset('oxbuild_images');

for f=files'
  img = imread(f.name);
  %process img

end

%profit
