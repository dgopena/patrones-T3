
calc; %SIFT descriptors are calculated

%% VLAD encoding
sample = getRandomPerm([files.sift_d],100000);

%%Cluster and assignment building
disp('Building clusters...');
%Build clusters
[C256, A256, ENERGY256] = vl_kmeans(single(sample), 256);
%[C128, A128, ENERGY128] = vl_kmeans(single(sample), 128);
%[C64, A64, ENERGY64] = vl_kmeans(single(sample), 64);
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
for i=1:N
    display(strcat('Processing image--', int2str(i)));
    vlad{i} = vl_vlad(single(files(i,1).sift_d),centers,assignments);
end

%% Load queries
queries = arrayfun(@loadQuery, ls('GroundTruths'));