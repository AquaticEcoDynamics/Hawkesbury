clear all;close all;

varname = 'WQ_DIAG_TOT_TN';

shp = shaperead('HN_Calibration_v2.shp');

load hawkesbury.mat;


sites = fieldnames(hawkesbury);

mDate = [];
mData = [];

for i = 1:length(sites)
    
    if isfield(hawkesbury.(sites{i}),varname)
        if inpolygon(hawkesbury.(sites{i}).(varname).X,hawkesbury.(sites{i}).(varname).Y,shp(4).X,shp(4).Y)
            mDate = [mDate;hawkesbury.(sites{i}).(varname).Date];
            mData = [mData;hawkesbury.(sites{i}).(varname).Data];
        end
    end
end

% Create a mega monthly array

datearray = datenum(1990,[01:01:480],15);

range.Date = datearray;
range.low(1:length(datearray),1) = NaN;
range.high(1:length(datearray),1) = NaN;


dv = datevec(datearray);
dvf = datevec(mDate);

for i = 1:12
    
    sss = find(dvf(:,2) == i);
    
    if ~isempty(sss)
        
        P = prctile(mData(sss),[10 90]);
        
        tt = find(dv(:,2) == i);
        
        range.low(tt) = P(1);
        range.high(tt) = P(2);
        
    end
end
        
        
    
    
    





