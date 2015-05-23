function [q] = loadQuery(qName)
%LOADQUERY Loads a query (on a given struct?)

  % Ensure input is a string (and not {str})
  qName = char(qName);

  % Save query name
  q.name = qName;
  
  % Load query
  % ==========
  dName = strcat('GroundTruths/', qName, '/', qName);
  f = fopen(strcat(dName, '_query.txt'));
  c = textscan(f, '%s');
  q.query = c{1};
  fclose(f);
  
  % Get image rel path
  str = q.query(1);
  str = str{1};
  datasetRoot = 'Datasets/oxbuild_images/';
  q.imgPath = strcat(strrep(str, 'oxc1_', datasetRoot), '.jpg');

  % Load groud truth
  % ================
  q.good        = fLines( strcat(dName, '_good.txt')  );
  q.junk        = fLines( strcat(dName, '_junk.txt')  );
  q.ok          = fLines( strcat(dName, '_ok.txt')    );
end

