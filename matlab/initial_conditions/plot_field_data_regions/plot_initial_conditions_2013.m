clear all; close all;

addpath(genpath('Functions'));

% The files required.


fieldfile = '..\..\modeltools\matfiles\hawkesbury_all.mat';

% defaults = xlsread('Defaults_v3_BB_2009.xlsx','B2:I100');
%
% outfile = 'init_conditions_mid2009.csv';
%
% grid = 'Lakes_Only_ASS_v3_Substrate.2dm';
%
% [XX,YY,nodeID,faces,X,Y,ID] = tfv_get_node_from_2dm(grid);

CHG_BAL_Calc = 1;

shpfile = '..\..\modeltools\gis\HN_Calibration_v2.shp';

% Date
sdate = datenum(2017,05,01);



vars = {...
    'WQ_NCS_SS1',...
    'WQ_OXY_OXY',...
    'WQ_SIL_RSI',...
    'WQ_NIT_AMM',...
    'WQ_NIT_NIT',...
    'WQ_PHS_FRP',...
    'WQ_PHS_FRP_ADS',...
    'WQ_OGM_DOC',...
    'WQ_OGM_POC',...
    'WQ_OGM_DON',...
    'WQ_OGM_PON',...
    'WQ_OGM_DOP',...
    'WQ_OGM_POP',...
    'WQ_PHY_GRN',...
    'WQ_PHY_BGA',...
    'WQ_PHY_FDIAT',...
    'WQ_PHY_MDIAT',...
    'WQ_TRC_AGE',...
    'WQ_DIAG_TOT_TN',...
    'WQ_DIAG_TOT_TP',...
    'WQ_DIAG_PHY_TCHLA',...
    'ECLOI',...
    'ENT',...
    'FC',...
    };






default_value = 0;


% Processing
%__________________________________________________________________________

% Load Field data
temp = load(fieldfile);
tt = fieldnames(temp);

fdata = temp.(tt{1}); clear temp tt;

%fdata = clip_fielddata(fdata,datenum(2014,07,01));

shp = shaperead(shpfile);





sites = fieldnames(fdata);

for i = 1:length(vars)
    for j = 1:length(sites)
        for k = 1:length(shp)
            init.(vars{i}).(['zone',num2str(k)]).Data = [];
            init.(vars{i}).(['zone',num2str(k)]).Date = [];
        end
    end
end
for i = 1:length(vars)
    disp(['Now Processing: ',vars{i}]);
    
    
    
    for j = 1:length(sites)
        if isfield(fdata.(sites{j}),vars{i})
            %disp(['Building Sites']);
            for k = 1:length(shp)
                %disp(['Inpol']);
                
                inpol = inpolygon(fdata.(sites{j}).(vars{i}).X,fdata.(sites{j}).(vars{i}).Y,shp(k).X,shp(k).Y);
                
                
                if inpol
                    
                    ZZ(:,1) = fdata.(sites{j}).(vars{i}).Data;
                    DD(:,1) = fdata.(sites{j}).(vars{i}).Date;
                    
                    init.(vars{i}).(['zone',num2str(k)]).Data = [init.(vars{i}).(['zone',num2str(k)]).Data;ZZ];
                    init.(vars{i}).(['zone',num2str(k)]).Date = [init.(vars{i}).(['zone',num2str(k)]).Date;DD];
                    init.(vars{i}).(['zone',num2str(k)]).Name = shp(k).Name;
                    
                    clear ZZ DD
                    
                end
            end
            
        end
    end
end

save init.mat init -mat;


outdir = ['Images_',datestr(sdate,'yyyy_mm'),'/'];

if ~exist(outdir,'dir')
    mkdir(outdir);
end

fid = fopen([outdir,'Values.csv'],'wt');

fprintf(fid,'Var,');
for i = 1:length(shp)
    fprintf(fid,'%s,',shp(i).Name);
end
fprintf(fid,'\n');



vars = fieldnames(init);
for i = 1:length(vars)
    fprintf(fid,'%s,',vars{i});
    zones = fieldnames(init.(vars{i}));
    figure('position',[8          48        1743         930]);
    for j = 1:length(zones)
        subplot(3,3,j)
        mean_val = 0;
        if ~isempty(init.(vars{i}).(['zone',num2str(j)]).Date)
            
            datearray = [sdate-50:10:sdate+50];
            
            [xdata_d,ydata_d] = process_daily(init.(vars{i}).(['zone',num2str(j)]).Date,init.(vars{i}).(['zone',num2str(j)]).Data);
            
            
            ss = find(xdata_d >= datearray(1) & xdata_d <= datearray(end));
            
            plot(xdata_d(ss),ydata_d(ss),'.K');hold on
            yl = get(gca,'ylim');
            
            bb = find(~isnan(ydata_d(ss)));
            if ~isempty(bb)
                mean_val = mean(ydata_d(ss(bb)));
            else
                mean_val = 0;
            end
            
            
            
            title([regexprep(vars{i},'_',' '),' Zone:',num2str(j),' ',init.(vars{i}).(['zone',num2str(j)]).Name]);
            plot([sdate sdate],[0 yl(2)],':r');
            plot([datearray(1) sdate],[mean_val mean_val],':r');
            
            text(0.9,0.9,num2str(mean_val),'units','normalized');
            
            %plot([datearray(1) sdate],yl,':r');
            
            xlim([datearray(1) datearray(end)]);
            
            set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'dd-mm'));
            
            
            fprintf(fid,'%4.4f,',mean_val);
            
            
        else
            fprintf(fid,'Unknown,');
        end
    end
    fprintf(fid,'\n');
    fin_dir = [outdir,num2str(i),'_',vars{i}];
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end
    img_name = [fin_dir,'.png'];
    
    
    saveas(gcf,img_name);
    
    close;
end
fclose(fid);



