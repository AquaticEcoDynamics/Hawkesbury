clear all; close all;

load ../Data_Import/hawkesbury_v2.mat;  

load hawkes_2017.mat;

hawkesbury_all = hawkesbury_v2;

sites = fieldnames(hawkes_2017);

for i = 1:length(sites)
    hawkesbury_all.(sites{i}) = hawkes_2017.(sites{i});
end

sites = fieldnames(hawkesbury_all);
avars = []; 
for i = 1:length(sites)
    t = fieldnames(hawkesbury_all.(sites{i}));
    
    avars = [avars;t];
end

uvars = unique(avars);

save hawkesbury_all.mat hawkesbury_all -mat
save('..\..\..\aed_matlab_modeltools\TUFLOWFV\polygon_timeseries_plotting\matfiles\hawkesbury_all.mat','hawkesbury_all','-mat'); 