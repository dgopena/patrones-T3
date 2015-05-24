% Setup local cluster
% ===================
disp('Setting up local cluter');
if matlabpool('size') == 0 % checking to see if my pool is already open
  disp('  Initializing thread pool');
  matlabpool open 8
else
  disp('  Thread pool was already initialized');
end


% Load files and calculate features
% =================================
disp('Loading Dataset');
calc




% Load queries
% ============
disp('Loading Query files');
% Load query files
% ----------------
queries = arrayfun(@loadQuery, ls('GroundTruths'));
fprintf('  Found %d Query files\n', size(queries, 1));


% Build nonQueries
% ----------------
disp('Building nonQuery list');
% Assume all files are not from a query
nonQueries = files;
i = [];
for f=1:size(files)
  for q=1:size(queries)
    if(strcmp(queries(q).imgPath, files(f).path))
      % If the file is a query mark it for removal
      i = [i f];  % Preallocating won't gain too much (only 55 queries)
      break;
    end
  end
end
clear f;
clear q;
% Remove queries
nonQueries(i) = [];
clear i;
fprintf('  %d files are not on a query\n', size(nonQueries, 1));
