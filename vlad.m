function [f,d] = vlad(img)
  [f,d] = vl_sift(single(rgb2gray(img)));
end

