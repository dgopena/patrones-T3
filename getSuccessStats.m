function [ meanPrecision, meanRecall, retrievalTime, allItems ] = getSuccessStats(successStatus)
%GETSUCCESSSTATS Summary of this function goes here
  good = 0;
  goodCount = sum(successStatus);
  meanPrecision = 0;
  meanRecall = 0;
  allItems = 0;
  for i=1:length(successStatus)
    if(successStatus(i))
      good = good + 1;
      if(good == goodCount)
        allItems = i;
      end
    end
    
    precision = good/i;
    recall = good/goodCount;

    meanPrecision = meanPrecision + precision;
    meanRecall    = meanRecall    + recall;
  end
  
  meanPrecision = meanPrecision / length(successStatus);
  meanRecall    = meanRecall    / length(successStatus);
  retrievalTime = good / allItems;
end

