clear all; close all;

load ../Data_Import_2017/hawkesbury_all.mat;

fid = fopen('Data Summary.csv','wt');

sites = fieldnames(hawkesbury_all);

avars = [];

for i = 1:length(sites)
    vars = fieldnames(hawkesbury_all.(sites{i}));
    avars = [avars;vars];
end
uvars = unique(avars);

fprintf(fid,'Site Name,');

for i = 1:length(uvars)
    fprintf(fid,'%s Start,%s End,%s Num,',uvars{i},uvars{i},uvars{i});
end
fprintf(fid,'\n');

for i = 1:length(sites)
    fprintf(fid,'%s,',sites{i});
    
    for j = 1:length(uvars)
        if isfield(hawkesbury_all.(sites{i}),uvars{j})
            sd = min(hawkesbury_all.(sites{i}).(uvars{j}).Date);
            ed = max(hawkesbury_all.(sites{i}).(uvars{j}).Date);
            sss = find(~isnan(hawkesbury_all.(sites{i}).(uvars{j}).Data) == 1);
            nm = length(sss);
            
            fprintf(fid,'%s,%s,%d,',datestr(sd,'dd/mm/yyyy'),datestr(ed,'dd/mm/yyyy'),nm);
        else
            fprintf(fid,',,,');
        end
    end
    fprintf(fid,'\n');
end
fclose(fid);
            
    
    




    