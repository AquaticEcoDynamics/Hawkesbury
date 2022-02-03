clear all; close all;

addpath(genpath('functions'));

ncfile = 'Y:\Cattai\HN_CC_Cal_v1_A1_2017\output\HN_Cal_2017_2018_3D_wq_WQ.nc';

timestep = 20;

vars = {'H',...
    'SAL',...
    'TEMP',...
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
    };

data = tfv_readnetcdf(ncfile,'timestep',timestep);

filename = 'init_conditions_2017_05_HN_CC.csv';

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


