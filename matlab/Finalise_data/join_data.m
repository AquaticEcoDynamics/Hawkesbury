clear all; close all;

addpath(genpath('seawater'));

load ../Data_Import/hawkesbury_v2.mat;  

load ../Data_Import_2017/hawkes_2017.mat;
load ../Data_Import_2017/sc_2017.mat;

load ../Data_Import/ww_all.mat;

hawkesbury_all = hawkesbury_v2;

sites = fieldnames(hawkes_2017);

for i = 1:length(sites)
    hawkesbury_all.(sites{i}) = hawkes_2017.(sites{i});
end

sites = fieldnames(sc_2017);

for i = 1:length(sites)
    hawkesbury_all.(sites{i}) = sc_2017.(sites{i});
end

sites = fieldnames(ww_all);

for i = 1:length(sites)
    
    if strcmpi(sites{i},'WISEMANS_FERRY__Box_10_B__') == 0
    
     hawkesbury_all.(['ww_',sites{i}]) = ww_all.(sites{i});
    else
        
       ss =  'ww_WISEMANS_FERRY__Box_10_B';
       hawkesbury_all.(ss) = ww_all.(sites{i});
    end
end

% sites = fieldnames(hawkesbury_all);
% avars = []; 
% for i = 1:length(sites)
%     t = fieldnames(hawkesbury_all.(sites{i}));
%     
%     avars = [avars;t];
% end
% 
% uvars = unique(avars);


shp = shaperead('Validation_Sites.shp');


sites = fieldnames(hawkesbury_all);

for i = 1:length(shp)
    
    site = regexprep(shp(i).Name,' ','_');
    
    vars = fieldnames(hawkesbury_all.(site));
    
    for j = 1:length(vars)
        
        if isfield(hawkesbury_all,site)
            hawkesbury_all.(site).(vars{j}).X = shp(i).X;
            hawkesbury_all.(site).(vars{j}).Y = shp(i).Y;
        else
            stop;
        end
            
    end
end
    
sites = fieldnames(hawkesbury_all);

for i = 1:length(sites)
    if isfield(hawkesbury_all.(sites{i}),'COND')
 
        salinity = conductivity2salinity(hawkesbury_all.(sites{i}).COND.Data);
        
        if isfield(hawkesbury_all.(sites{i}),'SAL')
            
            xdata = hawkesbury_all.(sites{i}).COND.Date;
            zdata = hawkesbury_all.(sites{i}).COND.Depth;
            
            hawkesbury_all.(sites{i}).SAL.Date =[hawkesbury_all.(sites{i}).SAL.Date;xdata];
            hawkesbury_all.(sites{i}).SAL.Depth = [hawkesbury_all.(sites{i}).SAL.Depth;zdata];
            hawkesbury_all.(sites{i}).SAL.Data =[hawkesbury_all.(sites{i}).SAL.Data;salinity];
            
        else
            hawkesbury_all.(sites{i}).SAL = hawkesbury_all.(sites{i}).COND;
            hawkesbury_all.(sites{i}).SAL.Data = salinity;
        end
    end
    
    if isfield(hawkesbury_all.(sites{i}),'SAL')
        hawkesbury_all.(sites{i}).SAL.Data(hawkesbury_all.(sites{i}).SAL.Data < 0) = NaN;
    end
    
    
end



save hawkesbury_all.mat hawkesbury_all -mat
save('..\modeltools\matfiles\hawkesbury_all.mat','hawkesbury_all','-mat');

sites = fieldnames(hawkesbury_all);
avars = []; 
for i = 1:length(sites)
    t = fieldnames(hawkesbury_all.(sites{i}));
    
    avars = [avars;t];
end

uvars = unique(avars);

% sites = fieldnames(hawkesbury_all);
% 
% for i = 1:length(sites)
%     vars = fieldnames(hawkesbury_all.(sites{i}));
%     S(i).Name = regexprep(sites{i},'_',' ');
%     S(i).Agency = hawkesbury_all.(sites{i}).(vars{1}).Agency;
%     S(i).X = hawkesbury_all.(sites{i}).(vars{1}).X;
%     S(i).Y = hawkesbury_all.(sites{i}).(vars{1}).Y;
%     S(i).Geometry = 'Point';
% end
% shapewrite(S,'Validation_Sites.shp');

