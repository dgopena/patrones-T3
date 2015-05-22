%%Just testing some random builds with random data.
%to test with sift descriptor soon.

numFeatures = 5000 ;
dimension = 2 ;
data = rand(dimension,numFeatures) ;

numDataToBeEncoded = 1000;
dataToBeEncoded = rand(dimension,numDataToBeEncoded);

numClusters = 30 ;
centers = vl_kmeans(data, numClusters);

kdtree = vl_kdtreebuild(centers) ;
nn = vl_kdtreequery(kdtree, centers, dataToBeEncoded) ;

assignments = zeros(numClusters,numDataToBeEncoded);
%assignments(sub2ind(size(assignments), numClusters, 1:length(nn))) = 1;

for j=1:length(nn)
    for i=1:numClusters
        assignments(i,j)=1;
    end
end
enc = vl_vlad(dataToBeEncoded,centers,assignments);