function [gs] = gs(img)
  d = size(size(img), 2);
  if(d>2)  % Color image
    gs = rgb2gray(img);
  else  % Grayscale image
    gs = img;
  end
end
