% Get query directories
queryNames = ls('GroundTruths');

% Load queries
queries = arrayfun(@loadQuery, queryNames);