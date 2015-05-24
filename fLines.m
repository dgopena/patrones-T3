function [lines] = fLines(fileName)
%FLINES Gets the file lines

  f = fopen(fileName);
  fCell = textscan(f,'%s','Delimiter','\r\n');
  lines = fCell{1};
  fclose(f);
end

