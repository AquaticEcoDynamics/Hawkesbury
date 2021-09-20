function lowerlakes = add_secondary_data(lowerlakes,datearray)
sites = fieldnames(lowerlakes);

for i = 1:length(sites)
    
    disp(sites{i});
    
    if isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TN') &  isfield(lowerlakes.(sites{i}),'WQ_DIAG_TOT_TP')
        TN = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TN',sites{i},'Surface',datearray);
        TP = create_interpolated_dataset(lowerlakes,'WQ_DIAG_TOT_TP',sites{i},'Surface',datearray);
        
       
        
        if ~isempty(TN) & ~isempty(TP) 
            
            TNTP = TN./TP;
            
            [Lia,Locb] = ismember(floor(lowerlakes.(sites{i}).WQ_DIAG_TOT_TN.Date),datearray);
            
          
            ttt = find(Locb > 0);
            lowerlakes.(sites{i}).TNTP = lowerlakes.(sites{i}).WQ_DIAG_TOT_TN;
            
            lowerlakes.(sites{i}).TNTP.Date = [];
            lowerlakes.(sites{i}).TNTP.Data = [];
            lowerlakes.(sites{i}).TNTP.Depth = [];
            
            
            
            lowerlakes.(sites{i}).TNTP.Date = datearray(Locb(ttt));
            lowerlakes.(sites{i}).TNTP.Data = TNTP(Locb(ttt));
            lowerlakes.(sites{i}).TNTP.Depth(1:length(ttt)) = 0;
            
            
            clear TN Amm Nit;
        end
        
    end
   
    
end

end

function var = create_interpolated_dataset(data,varname,site,depth,mtime)
% A Function to take a AED data structure, site and variable and create an
% interpolated dataset for use in creation of the input files

if isfield(data.(site),varname)
    
    t_depth = data.(site).(varname).Depth;
    tt_data = data.(site).(varname).Data;
    
    tt_date = data.(site).(varname).Date;
    
    u_date = unique(tt_date);
    
    t_data(1:length(u_date)) = NaN;
    t_date(1:length(u_date)) = NaN;
%     for iii = 1:length(u_date)
%         sss = find(tt_date == u_date(iii));
%         
%         switch depth
%             case 'Bottom'
%                 [~,ind] = min(t_depth(sss));
%             case 'Surface'
%                 [~,ind] = max(t_depth(sss));
%             otherwise
%                 disp('Not a valid depth name');
%         end
%         
%         t_data(iii) = tt_data(sss(ind));
%         t_date(iii) = data.(site).(varname).Date(sss(ind));
%     end


t_data = tt_data;
t_date = tt_date;

% for bdb = 1:length(t_date)
%     t_date(bdb) = t_date(bdb) + rand/1000;
% end
% [t_date,ind] = sort(t_date);
% t_data = t_data(ind);

    
    ss = find(~isnan(t_data) == 1);
    
    [t_date_s,ind] = unique(t_date(ss));
    t_data_s = t_data(ss(ind));
    
    
    if length(ss) > 1

        if max(t_date(ss)) > mtime(1)
            
            var = interp1(t_date_s,t_data_s,mtime,'linear',mean(t_data(ss)));
            var(var < 0) = 0;
            
        else
            var = [];
        end
    else
        var = [];
    end
    
else
    var = [];
    
end
end






















