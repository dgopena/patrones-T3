
% Get a sample of 100k sift_d descriptors
a = getRandomPerm([files.sift_d], 100000);


% Build Clusters
[C256, A256, ENERGY256] = vl_kmeans(single(a), 256);
[C128, A128, ENERGY128] = vl_kmeans(single(a), 128);
[ C64,  A64,  ENERGY64] = vl_kmeans(single(a),  64);

% Cx has x 'words'
% Ax has the 'labels' for the data from a (useless)
% ENERGYx "the energy of the solution (or an upper bound for the ELKAN algorithm) as well"



