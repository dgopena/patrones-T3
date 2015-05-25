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
    pathMod = strrep(files(f).path, '\', '/');
    if(strcmp(queries(q).imgPath, pathMod))
      % If the file is a query mark it for removal
      i = [i f];  % Preallocating won't gain too much (only 55 queries)
      queries(q).index_f = f;
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
%Codewords256 = vl_kmeans(sample, 256);
%Codewords128 = vl_kmeans(sample, 128);
Codewords64  = vl_kmeans(sample,  64);
disp('Done.');


%% obtenemos nearest neighbors para VLAD
visualWords = Codewords64;
numClusters = 64;

kdtree = vl_kdtreebuild(visualWords) ;
[nn, distances] = vl_kdtreequery(kdtree, visualWords, single(sample)) ;

%% assignment matrix

assignments = zeros(size(visualWords,2), 100000, 'single') ;
assignments(sub2ind(size(assignments), double(nn), 1:numel(nn))) = 1 ;


N = length(files);
vlad = cell(N,1);
vladVectors = cell(N,1);

for i=1:N
  files(i).vlad = [];
end
disp('Calculating vlad');
parfor_progress(N);
parfor i=1:N
  vlad{i} = vl_vlad(single(files(i,1).sift_d), visualWords, assignments);
  vladVector = vlad{i};
  vlad{i} = reshape(vlad{i},[128,size(visualWords,2)]);
  files(i,1).vlad = vladVector;
  parfor_progress;
end
parfor_progress(0);



%% calculo de distancias por query
euclidDist = zeros(size(queries, 1), size(nonQueries, 1)); %distance of each non-query towards each query
hellinDist = zeros(size(queries, 1), size(nonQueries, 1));

disp('Computing query results');
parfor_progress(size(queries, 1));
for q = 1:size(queries)
  targetVlad = files(queries(q).index_f).vlad;
  for f = 1:size(nonQueries)
    % Compute distances to query's VLAD descriptor
    euclidDist(q,f) = norm(files(f).vlad - targetVlad);
    hellinDist(q,f) = norm(sqrt(abs(files(f).vlad)) - sqrt(abs(targetVlad)));
  end
  clear targetVlad;

  parfor_progress;
end
parfor_progress(0);
