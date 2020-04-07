clear all; close all;

addpath(genpath('functions'));

sdatearray = [datenum(2013,07,01) datenum(2017,05,01)];
%sdatearray = datenum(2018,03,15);
% Rsdatearray = datenum(2017,11,01);
for bdb = 1:length(sdatearray)
    
    
    sdate = sdatearray(bdb);%datenum(2018,05,01);
    
    
    IC = create_IC_matfile(sdate);
    
    grid = 'D:\Github\Hawkesbury\model\UWA\HN_Cal_v4\geo\HawkesburyNepean_Detailed_021.2dm';

    [XX,YY,nodeID,faces,X,Y,ID] = tfv_get_node_from_2dm(grid);
    
    
    outdir = ['Images/',datestr(sdate,'yyyymmdd'),'/'];;
    
    if ~exist(outdir)
        mkdir(outdir);
    end
    
    headers = {...
        'Sal',...
        };
 
    headers_write = {...
        'Sal',...
        };
    
  
    
    
    
    
    
    sites = fieldnames(IC);
    
    for i = 1:length(headers)
        
        data.(headers{i}).Data = [];
        data.(headers{i}).X = [];
        data.(headers{i}).Y = [];
        
        inc = 1;
        
        for j = 1:length(sites)
            
            if isfield(IC.(sites{j}),headers{i})
                
                ss = find(IC.(sites{j}).(headers{i}).Date == sdate);
                
                if ~isempty(ss)
                    
                    data.(headers{i}).Data(inc,1) = IC.(sites{j}).(headers{i}).Data(ss(1));
                    data.(headers{i}).X(inc,1) = IC.(sites{j}).(headers{i}).X;
                    data.(headers{i}).Y(inc,1) = IC.(sites{j}).(headers{i}).Y;
                    
                    inc = inc + 1;
                    
                end
            end
        end
        disp(headers{i});
        if length(data.(headers{i}).X) > 3
            F = scatteredInterpolant(data.(headers{i}).X,data.(headers{i}).Y,data.(headers{i}).Data,'linear','nearest');
            
            interp.(headers{i}) = F(X,Y);
        else
            interp.(headers{i})(1:length(ID)) = 0;
        end
        
        tfv_plot_init_condition(XX,YY,faces',interp.(headers{i}),[outdir,headers{i},'.png'],headers{i})
        
        
    end
    
    disp('Writing the file.....');
    fid = fopen(['IC_AED2_',datestr(sdate,'yyyymmdd'),'.csv'],'wt');
    fprintf(fid,'ID,');
    for i = 1:length(headers_write)
        if i == length(headers_write)
            fprintf(fid,'%s\n',headers_write{i});
        else
            fprintf(fid,'%s,',headers_write{i});
        end
    end
    
    for j = 1:length(ID)
        fprintf(fid,'%d,',ID(j));
        for i = 1:length(headers)
            
            if i == length(headers)
                fprintf(fid,'%4.4f\n',interp.(headers{i})(j));
            else
                fprintf(fid,'%4.4f,',interp.(headers{i})(j));
            end
        end
    end
    
    fclose(fid);
    
    
end
