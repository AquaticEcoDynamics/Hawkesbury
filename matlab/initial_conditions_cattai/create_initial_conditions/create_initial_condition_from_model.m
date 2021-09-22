clear all; close all;

addpath(genpath('functions'));

ncfile = 'I:\Hawkesbury\HN_Cal_v4\output\HN_Cal_2017_HYDRO.nc';

timestep = 10;

vars = {'H',...
    'SAL',...
    'TEMP',...
    };

data = tfv_readnetcdf(ncfile,'timestep',timestep);

filename = 'init_conditions_2017_05_HN_TFV.csv';

fid = fopen(filename,'wt');

fprintf(fid,'ID,');
for i = 1:length(vars)
    fprintf(fid,'%s,',vars{i});
end
fprintf(fid,'\n');

for i = 1:length(vars)
    
    if strcmpi(vars,'H') == 0
        
        cdata.(vars{i}) = data.(vars{i})(data.idx3(data.idx3 > 0));
    else
        
        cdata.(vars{i}) = data.(vars{i});
    end
    
end

for i = 1:length(cdata.(vars{1}))
    fprintf(fid,'%s,',num2str(i));
    
    for j = 1:length(vars)
        if j == length(vars)
            fprintf(fid,'%5.4f\n',cdata.(vars{j})(i));
        else
            fprintf(fid,'%5.4f,',cdata.(vars{j})(i));
        end
    end
end

fclose(fid);


