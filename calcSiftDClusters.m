

% Get a sample of 100k sift_d descriptors
a = getRandomPerm([nonQueries.sift_d], 100000);
% vl_kmeans uses single precision numbers
a = single(a);

% Build Clusters
[C256, A256, ENERGY256] = vl_kmeans(a, 256);
[C128, A128, ENERGY128] = vl_kmeans(a, 128);
[ C64,  A64,  ENERGY64] = vl_kmeans(a,  64);

% Cx has x 'words'
% Ax has the 'labels' for the data from a (useless)
% ENERGYx "the energy of the solution (or an upper bound for the ELKAN algorithm) as well"

