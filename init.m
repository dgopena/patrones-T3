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


%% VLAD encoding
sample = getRandomPerm([nonQueries.sift_d],100000);
sample = single(sample);  % vl_kmeans uses single precision


%% Cluster and assignment building
disp('Building clusters...');
% Build clusters
[C256, A256, ENERGY256] = vl_kmeans(sample, 256);
[C128, A128, ENERGY128] = vl_kmeans(sample, 128);
[ C64,  A64,  ENERGY64] = vl_kmeans(sample,  64);
disp('Done.');

%C corresponds to the centers.
%A is the assignment of each data to a center


%% obtenemos nearest neighbors para VLAD
centers = C64;
numClusters = 64;

kdtree = vl_kdtreebuild(centers) ;
[nn, distances] = vl_kdtreequery(kdtree, centers, single(sample)) ;

%% assignment matrix

assignments = zeros(numClusters,100000, 'single') ;
assignments(sub2ind(size(assignments), double(nn), 1:numel(nn))) = 1 ;

%assignments = zeros(numClusters,100000);
%assignments(sub2ind(size(assignments), nn, 1:length(nn))) = 1;
%%
N = length(files);
vlad = cell(N,1);
vladVectors = cell(N,1);

for i=1:N
    files(i).vlad = [];
end

disp('Calculating vlad');
parfor_progress(N);
parfor i=1:N
  vlad{i} = vl_vlad(single(files(i,1).sift_d),centers,assignments);
  vladVector = vlad{i};
  vlad{i} = reshape(vlad{i},[128,numClusters]);
  files(i,1).vlad = vladVector;
  parfor_progress;
end
parfor_progress(0);

%% Load queries
%  ============
disp('Loading Query files');
% Load query files
% ----------------
queries = arrayfun(@loadQuery, ls('GroundTruths'));
fprintf('  Found %d Query files\n', size(queries, 1));

%hago un struct para obtener el vlad de las queries
queryData = [];
for i=1:size(queries, 1)
  queryData(i).vlad = [];
  queryData(i).index = [];
  queryData(i).path   = '';
end

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
      queryData(q).vlad = files(f).vlad;
      queryData(q).index = f;
      queryData(q).path = files(f).path;
      break;
    end
  end
  parfor_progress;
end
parfor_progress(0);
queryData = queryData';
clear f;
clear q;
% Remove queries
nonQueries(i) = [];
clear i;
fprintf('  %d files are not on a query\n', size(nonQueries, 1));

%% calculo de distancias por query
euclidDist = cell(size(queryData),size(nonQueries)); %distance of each non-query towards each query
hellinDist = cell(size(queryData),size(nonQueries));

parfor_progress(size(queryData));
for q = 1:size(queryData)
    targetVlad = queryData(q).vlad;
    for f = 1:size(nonQueries)
        sampleVlad = files(f).vlad;
        % euclidean
        euclidDist{q,f} = norm(targetVlad - sampleVlad);
        
    end
    parfor_progress;
end
parfor_progress(0);
