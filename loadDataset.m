function [ files ] = loadDataset( datasetName )
  files = rdir(strcat('Datasets\', datasetName,'\*jpg'));
end

