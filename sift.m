function [f,d] = sift(img)
  [f,d] = vl_sift(single(gs(img)));
end

