clear all; close all;

addpath(genpath('Functions'));

% The files required.
fieldfile = '..\..\modeltools\matfiles\hawkesbury_all.mat';

defaults = xlsread('Defaults_2014_HN.xlsx','B3:I100');

outfile = 'init_conditions_2014_07_HN_WQ.csv';

grid = '..\..\..\model\UWA\HN_Cal_v4\geo\HawkesburyNepean_Detailed_021.2dm';

[XX,YY,nodeID,faces,X,Y,ID] = tfv_get_node_from_2dm(grid);

CHG_BAL_Calc = 1;

shpfile = '..\..\modeltools\gis\HN_Calibration_v2.shp';

% Date
sdate = datenum(2013,07,01);


vars = {...
    'nSAL',...
    'nTEMP',...
 'nWQ_NCS_SS1',...
'nWQ_OXY_OXY',...
'nWQ_SIL_RSI',...
'nWQ_NIT_AMM',...
'nWQ_NIT_NIT',...
'nWQ_PHS_FRP',...
'nWQ_PHS_FRP_ADS',...
'nWQ_OGM_DOC',...
'nWQ_OGM_POC',...
'nWQ_OGM_DON',...
'nWQ_OGM_PON',...
'nWQ_OGM_DOP',...
'nWQ_OGM_POP',...
'nWQ_PHY_GRN',...
'nWQ_PHY_BGA',...
'nWQ_PHY_FDIAT',...
'nWQ_PHY_MDIAT',...
'nWQ_TRC_AGE',...
'nECLOI',...
'nFC',...
'nENT',...
    };

writevars = {...
    'SAL',...
    'TEMP',...
    'WQ_1',...
    'WQ_2',...
    'WQ_3',...
    'WQ_4',...
    'WQ_5',...
    'WQ_6',...
    'WQ_7',...
    'WQ_8',...
    'WQ_9',...
    'WQ_10',...
    'WQ_11',...
    'WQ_12',...
    'WQ_13',...
    'WQ_14',...
    'WQ_15',...
    'WQ_16',...
    'WQ_17',...
    'WQ_18',...
    'WQ_19',...
    'WQ_20',...
    'WQ_21',...
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


fid = fopen('Mean_Initial_Condition.csv','wt');
fprintf(fid,'Variable,River,Coorong,Lakes\n');


sites = fieldnames(fdata);

for i = 1:length(vars)
    fprintf(fid,'%s,',vars{i});
    disp(['Now Processing: ',vars{i}]);
    
    % Initialise the variable
    init.(vars{i})(1:length(X),1) = default_value;
    
    inc = 1;
    
    temp = [];
    
    for j = 1:length(sites)
        
        if isfield(fdata.(sites{j}),vars{i})
            
            tdate = fdata.(sites{j}).(vars{i}).Date;
            
            [~,ind] = min(abs(tdate - sdate));
            
            if ~isempty(ind)
                
                tX = fdata.(sites{j}).(vars{i}).X;
                tY = fdata.(sites{j}).(vars{i}).Y;
                tZ = fdata.(sites{j}).(vars{i}).Data(ind);
                
                %                 if tZ < 0
                %                     tZ = 0;
                %                 end
                
                if ~isnan(tZ)
                    temp(inc,1) = tX;
                    temp(inc,2) = tY;
                    temp(inc,3) = tZ;
                    
                    inc = inc + 1;
                    
                    clear tY tX tZ;
                end
                
            end
            
        end
    end
    
    
    for j = 1:length(shp)
        
        inpol = inpolygon(X,Y,shp(j).X,shp(j).Y);
        
        
        
        if ~isempty(temp) % No Field Data
            inpol_temp = inpolygon(temp(:,1),temp(:,2),shp(j).X,shp(j).Y);
            
            sss = find(inpol_temp == 1);
            
            if ~isempty(sss) % No Data Within Polygon
                if length(sss) > 1
                    F = scatteredInterpolant(temp(inpol_temp,1),temp(inpol_temp,2),temp(inpol_temp,3),'linear','nearest');
                    
                    Z = F(X(inpol),Y(inpol));
                    
                    if ~isempty(Z) % Not enough points to create triangulation
                        
                        init.(vars{i})(inpol,1) = Z;
                        
                        clear Z;
                    else
                        init.(vars{i})(inpol,1) = mean(temp(inpol_temp,3));
                    end
                    
                else
                    init.(vars{i})(inpol,1) = temp(inpol_temp,3);
                end
            else
                init.(vars{i})(inpol,1) = defaults(i,j);%shp(j).Zone);
            end
            
        else
            init.(vars{i})(inpol,1) = defaults(i,j);%shp(j).Zone);
            
        end
        
        fprintf(fid,'%7.4f,',mean(init.(vars{i})(inpol,1)));
    end
    fprintf(fid,'\n');
    % Get rid of any NaN's
    ss = find(isnan(init.(vars{i})) == 1);
    ttt = find(~isnan(init.(vars{i})) == 1);
    
    init.(vars{i})(ss) = mean(init.(vars{i})(ttt));
    
    %     sss = find(init.(vars{i}) == 0);
    %     if ~isempty(sss)
    %         init.(vars{i})(sss) = mean(init.(vars{i}));
    %     end
    
    clear temp
end

if CHG_BAL_Calc == 1
    
    if isfield(init,'nWQ_GEO_UBALCHG')
        
        init.nWQ_GEO_UBALCHG = calc_chgbal(init);
        
    end
    
    if isfield(init,'WQ_GEO_UBALCHG')
        init.WQ_GEO_UBALCHG = calc_chgbal(init);
    end
end



%% Hack for SS11

% ss = find(init.WQ_TRC_SS11 == 0);
% init.WQ_TRC_SS11(ss) =



fclose(fid);

vert(:,1) = XX;
vert(:,2) = YY;


save('init.mat','init','XX','YY','-mat');


outdir = 'Images/';

if ~exist(outdir)
    mkdir(outdir);
end

disp('Plotting');

for i = 1:length(vars)
    
    figure
    
    axes('position',[0.05 0.05 0.4 0.8]);
    
    cdata = init.(vars{i});
    fig.ax = patch('faces',faces','vertices',vert,'FaceVertexCData',cdata);shading flat
    axis equal
    
    set(gca,'Color','None',...
        'box','on');
    
    set(findobj(gca,'type','surface'),...
        'FaceLighting','phong',...
        'AmbientStrength',.3,'DiffuseStrength',.8,...
        'SpecularStrength',.9,'SpecularExponent',25,...
        'BackFaceLighting','unlit');
    
    axis off
    set(gca,'box','off');
    
%     xlim([331084.169394841          400699.760664682]);
%     ylim([6091384.91517857          6195808.30208333]);
    
    cb = colorbar;
    
    set(cb,'position',[0.45 0.2 0.01 0.4],...
        'units','normalized');
    
    %     text(0.1,0.1,regexprep(vars{i},'_',' '),...
    %         'Units','Normalized',...
    %         'Fontname','Candara',...
    %         'Fontsize',16);
    
    axes('position',[0.55 0.05 0.4 0.8]);
    
    cdata = init.(vars{i});
    fig.ax = patch('faces',faces','vertices',vert,'FaceVertexCData',cdata);shading flat
    axis equal
    
    set(gca,'Color','None',...
        'box','on');
    
    set(findobj(gca,'type','surface'),...
        'FaceLighting','phong',...
        'AmbientStrength',.3,'DiffuseStrength',.8,...
        'SpecularStrength',.9,'SpecularExponent',25,...
        'BackFaceLighting','unlit');
    
    axis off
    set(gca,'box','off');
%     xlim([295790.068735384          399991.600875585]);
%     ylim([5961441.91170081          6117744.20991111]);
%     
    cb = colorbar;
    
    set(cb,'position',[0.9 0.2 0.01 0.4],...
        'units','normalized');
    
    text(-0.2,0.95,regexprep(vars{i},'_',' '),...
        'Units','Normalized',...
        'Fontname','Candara',...
        'Fontsize',16);
    
    
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');
    xSize = 18;
    ySize = 10;
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'paperposition',[0 0 xSize ySize])
    
    print(gcf,'-dpng',[outdir,vars{i},'.png'],'-opengl');
    
    close;
    
end






disp('Writing the File');

fid = fopen(outfile,'wt');

fprintf(fid,'ID,');

for i = 1:length(vars)
    
    %     if strcmpi(vars{i},'H') == 1
    %         writevar = 'WL';
    %     else
    %         writevar = vars{i};
    %     end
    %
    %     writevar = regexprep(writevar,'WQ_','');
    
    if i == length(vars)
        fprintf(fid,'%s\n',writevars{i});
    else
        fprintf(fid,'%s,',writevars{i});
    end
end

for i = 1:length(init.(vars{4}))
    fprintf(fid,'%s,',num2str(i));
    
    for j = 1:length(vars)
        if j == length(vars)
            fprintf(fid,'%5.4f\n',init.(vars{j})(i));
        else
            fprintf(fid,'%5.4f,',init.(vars{j})(i));
        end
    end
end

fclose(fid);






