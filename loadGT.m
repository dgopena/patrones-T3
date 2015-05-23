queryNames = ls('GroundTruths');
qSize = size(queryNames);

queries = repmat(struct('name', '', 'queryString', '', 'pqString', '', 'good',[], 'ok', [], 'junk', []), qSize, 1);
for i=1:size(queryNames)
  qName = char(queryNames(i));
  queries(i).name = qName;

  dName = strcat('GroundTruths/', qName, '/', qName);
  queries(i).good        = fLines( strcat(dName, '_good.txt')  );
  queries(i).junk        = fLines( strcat(dName, '_junk.txt')  );
  queries(i).ok          = fLines( strcat(dName, '_ok.txt')    );
  queries(i).queryString = fLines( strcat(dName, '_query.txt') );
  
  f = fopen(strcat(dName, '_query.txt'));
  inCell = textscan(f, '%s');
  queries(i).pqString    = inCell{1};
  fclose(f);
end