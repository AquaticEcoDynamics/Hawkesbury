clear all; close all;

addpath(genpath('C:\Users\00065525\Github\aed_matlab_modeltools\TUFLOWFV\tuflowfv'));

dirlist = dir('*.nc');

for i = 1:length(dirlist)
    
    data = tfv_readnetcdf(dirlist(i).name);
    
    mdate = datenum(2012,01,01) + (data.time/24);
    
    vars = fieldnames(data);
    
    for j = 1:length(vars)
        
        A = size(data.(vars{j}));
        
        if length(A) == 3
            figure
            
            plot(mdate,squeeze(data.(vars{j})(10,10,:)));
            datetick('x');
            
            saveas(gcf,[dirlist(i).name,'_',vars{j},'.png']);
            
            close;
        end
    end
end
    