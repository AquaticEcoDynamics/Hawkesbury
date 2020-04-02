clear all; close all;

load ../Data_Import/hawkesbury_v2.mat;  

load ../Data_Import_2017/hawkes_2017.mat;

load ../Data_Import/ww_all.mat;

hawkesbury_all = hawkesbury_v2;

sites = fieldnames(hawkes_2017);

for i = 1:length(sites)
    hawkesbury_all.(sites{i}) = hawkes_2017.(sites{i});
end

sites = fieldnames(ww_all);

for i = 1:length(sites)
    hawkesbury_all.(['ww_',sites{i}]) = ww_all.(sites{i});
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

save hawkesbury_all.mat hawkesbury_all -mat
save('..\..\..\aed_matlab_modeltools\TUFLOWFV\polygon_timeseries_plotting\matfiles\hawkesbury_all.mat','hawkesbury_all','-mat');


sites = fieldnames(hawkesbury_all);

for i = 1:length(sites)
    vars = fieldnames(hawkesbury_all.(sites{i}));
    S(i).Name = regexprep(sites{i},'_',' ');
    S(i).Agency = hawkesbury_all.(sites{i}).(vars{1}).Agency;
    S(i).X = hawkesbury_all.(sites{i}).(vars{1}).X;
    S(i).Y = hawkesbury_all.(sites{i}).(vars{1}).Y;
    S(i).Geometry = 'Point';
end
shapewrite(S,'Validation_Sites.shp');

