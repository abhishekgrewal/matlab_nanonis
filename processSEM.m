function [data, lineMean , lineStd, slope] = processSEM(data,header)
%processSTM corrects for the mean ans std variation, and does plane
%correction

%The lines are gaussian. The mean and std depends on the distance
%tip-sample, that changes during the measurment because of the drift, and
%on other things.

%Save mean and STDev
lineMean = nanmean(data,2);
lineStd = nanstd(data,0,2);

%Remove mean and STDev
data=(data-nanmean(data,2)*ones([1 size(data,2)]))./(nanstd(data,0,2)*ones([1 size(data,2)]));

%Remove slope
[data,slope] = processSxM(data,header);
  
%Renormalize
mnData=nanmean(data(:));
stdData=nanstd(data(:));

%Data
data = data - mnData;
data = data/stdData;


%idem for the slope
slope = slope-mnData;
slope = slope/stdData;


end