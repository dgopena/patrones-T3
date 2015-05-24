%% Setup local cluster
%  ===================
disp('Setting up local cluter');
if matlabpool('size') == 0 % checking to see if my pool is already open
  disp('  Initializing thread pool');
  matlabpool open 8
else
  disp('  Thread pool was already initialized');
end


%% Load files and calculate features
%  =================================
disp('Loading Dataset');
calc




%% Load queries
%  ============
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
parfor_progress(size(files));
for f=1:size(files)
  for q=1:size(queries)
    if(strcmp(queries(q).imgPath, files(f).path))
      % If the file is a query mark it for removal
      i = [i f];  % Preallocating won't gain too much (only 55 queries)
      break;
    end
  end
  parfor_progress;
end
parfor_progress(0);
clear f;
clear q;
% Remove queries
nonQueries(i) = [];
clear i;
fprintf('  %d files are not on a query\n', size(nonQueries, 1));







%% VLAD encoding
sample = getRandomPerm([nonQueries.sift_d],100000);
sample = single(sample);  % vl_kmeans uses single precision


%% Cluster and assignment building
disp('Building clusters...');
% Build clusters
Codewords256 = vl_kmeans(sample, 256);
Codewords128 = vl_kmeans(sample, 128);
Codewords64  = vl_kmeans(sample,  64);
disp('Done.');




%% obtenemos nearest neighbors para VLAD

% TODO: Move to a function
visualWords = Codewords64;

kdtree = vl_kdtreebuild(visualWords) ;
[nn, distances] = vl_kdtreequery(kdtree, visualWords, sample) ;

%% assignment matrix

assignments = zeros(size(visualWords,2),100000, 'single') ;
assignments(sub2ind(size(assignments), double(nn), 1:numel(nn))) = 1 ;

%assignments = zeros(size(visualWords,2),100000);
%assignments(sub2ind(size(assignments), nn, 1:length(nn))) = 1;
%%
N = length(files);
vlad = cell(N,1);

disp('Calculating vlad');
parfor_progress(N);
parfor i=1:N
  vlad{i} = vl_vlad(single(files(i,1).sift_d),visualWords,assignments);
  vlad{i} = reshape(vlad{i}, [128,size(visualWords,2)]);
  parfor_progress;
end
parfor_progress(0);

