clear all; close all;

load ../Data_Import_2017/hawkesbury_all.mat;
load ../Data_Import/hawkesbury.mat;


sites = fieldnames(hawkesbury);

for i = 1:length(sites)
    
    if ~isfield(hawkesbury_all,sites{i})
        hawkesbury_all.(sites{i}) = hawkesbury.(sites{i});
    else
        
        vars = fieldnames(hawkesbury.(sites{i}));

        for j = 1:length(vars)
            if ~isfield(hawkesbury_all.(sites{i}),vars{j})
                hawkesbury_all.(sites{i}).(vars{j}) = hawkesbury.(sites{i}).(vars{j});
            else
                xdata = [];
                ydata = [];
                xdata = hawkesbury.(sites{i}).(vars{j}).Date;
                ydata = hawkesbury.(sites{i}).(vars{j}).Data;
                
                for k = 1:length(xdata)
                    
                    sss = find(hawkesbury_all.(sites{i}).(vars{j}).Date == xdata(k) & ...
                        hawkesbury_all.(sites{i}).(vars{j}).Data == ydata(k));
                    
                    if isempty(sss)
                        hawkesbury_all.(sites{i}).(vars{j}).Date = [hawkesbury_all.(sites{i}).(vars{j}).Date;xdata(k)];
                        hawkesbury_all.(sites{i}).(vars{j}).Data = [hawkesbury_all.(sites{i}).(vars{j}).Data;ydata(k)];
                        hawkesbury_all.(sites{i}).(vars{j}).Depth = [hawkesbury_all.(sites{i}).(vars{j}).Depth;0];
                    end
                    
                end
                
                [hawkesbury_all.(sites{i}).(vars{j}).Date,ind] = sort(hawkesbury_all.(sites{i}).(vars{j}).Date);
                hawkesbury_all.(sites{i}).(vars{j}).Data = hawkesbury_all.(sites{i}).(vars{j}).Data(ind);
                hawkesbury_all.(sites{i}).(vars{j}).Depth = hawkesbury_all.(sites{i}).(vars{j}).Depth(ind);
            end
        end
    end
end
            

fid = fopen('Data Summary v6.csv','wt');

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
                    
                    
save('..\..\..\aed_matlab_modeltools\TUFLOWFV\polygon_timeseries_plotting\matfiles\hawkesbury_all.mat','hawkesbury_all','-mat');                     
                    
                
                
                
                
                
        
        
    




