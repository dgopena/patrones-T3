function [d] = ls(dirName)
  d = dir(dirName);
  isub = [d(:).isdir]; %# returns logical vector
  d = {d(isub).name}';
  d(ismember(d,{'.','..'})) = [];
end

