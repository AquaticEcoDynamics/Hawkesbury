clear all; close all;

addpath(genpath('../../../aed_matlab_modeltools/TUFLOWFV/tuflowfv/'));

[snum,sstr] = xlsread('../../data/Cattai/2129951_CattaiRidgeRd/2122951_CattaiRidgeRd_FlowwElev.xlsx','A12:E20000');

lspt = split(sstr(:,1),'T');

dat.mDate = datenum(lspt(:,1),'yyyy-mm-dd');
dat.H = snum(:,end);
dat.H = dat.H + 2;
filename = 'Tide.csv';

%load ../../../../data/store/hydro/dew_saltcreek.mat;





outdir = 'Images/Tide/';

if ~exist(outdir,'dir')
    mkdir(outdir)
end

data = tfv_readBCfile(filename);

vars = fieldnames(data);





data.WL_mAHD = [];
data.WL_mAHD = interp1(dat.mDate,dat.H,data.Date);


fid = fopen('Tide_v2.csv','wt');

for i = 1:length(vars)
    if i == length(vars)
        fprintf(fid,'%s\n',vars{i});
    else
                        if i == 1
                    fprintf(fid,'ISOTIME,');
                else
                    fprintf(fid,'%s,',vars{i});
                end
    end
end

for j = 1:length(data.Date)
    
    for i = 1:length(vars)
        
        if i == 1
            fprintf(fid,'%s,',datestr(data.Date(j),'dd/mm/yyyy HH:MM:SS'));
        else
            
            if i == length(vars)
                fprintf(fid,'%4.4f\n',data.(vars{i})(j));
            else
                fprintf(fid,'%4.4f,',data.(vars{i})(j));
            end
        end
    end
end
fclose(fid);

for i = 1:length(vars)
    
    if strcmpi(vars{i},'Date') == 0
        
        xdata = data.Date;
        ydata = data.(vars{i});
        
        
        figure('position',[555 635 1018 343]);
        plot(xdata,ydata,'k');
        
        title(regexprep(vars{i},'_',' '));
        
        x_array = xdata(1):(xdata(end)-xdata(1))/5:xdata(end);
        
        set(gca,'xtick',x_array,'xticklabel',datestr(x_array,'mm/yyyy'));
        
        xlim([xdata(1) xdata(end)]);
        
        
        filename = [outdir,vars{i},'.png'];
        
        saveas(gcf,filename);
        
        close
    end
end
        
 create_html_for_directory('Images/','Images/');       