clear all; close all;

basedir = '../../data/Updated/Finalised/';


shp = shaperead([basedir,'WQMonitoringSites_HNCatchments_AllOrganisations.shp']);

dirlist = dir([basedir,'*.csv']);
[conv,sstr ] = xlsread('Conversions_v2.xlsx','A2:D10000');
old = sstr(:,1);
nvars = sstr(:,2);
units = sstr(:,4);

hawkesbury_v2 = [];

for i = 1:length(dirlist)
    %disp(dirlist(i).name);
    
    agency = [];
    
    td = regexprep(dirlist(i).name,'_Final.csv','');
    td = regexprep(td,'_Nutrients','');
    
    %     disp(td);
    
    str = strsplit(td,'_');
    
    if strcmpi(str{1},'SWC') == 1 ...
            & strcmpi(str{2},'USDS') == 1
        site_ID = str{3};
        
        agency = 'SWC';
    end
    
    if strcmpi(str{1},'SWC') == 1 ...
            & strcmpi(str{2},'USDS') == 0
        site_ID = str{2};
        agency = 'SWC';
    end
    
    if strcmpi(str{1},'WNSW') == 1 ...
            site_ID = str{2};
        agency = 'WNSW';
    end
    
%     if strcmpi(str{1},'SWC') == 0 ...
%             & strcmpi(str{1},'WNSW') == 0
%         
%         site_ID = regexprep(td,'_',' ');
%     end
    
     if strcmpi(str{1},'EES') == 1
        
        site_ID = regexprep(td,'_',' ');
        %site_ID = regexprep(site_ID,'EES ','');
        agency = 'DPIE-bouy';
     end
    
     if strcmpi(str{1},'Hornsby') == 1
        
        site_ID = regexprep(td,'_',' ');
        %site_ID = regexprep(site_ID,'Hornsby ','');
        agency = 'Hornsby';
    end
    
    disp(site_ID);
    
    
    X =[];
    Y = [];
    for j = 1:length(shp)
        
        if strcmpi(shp(j).Name,site_ID) == 1
            X = shp(j).X;
            Y = shp(j).Y;
            
        end
    end
    if isempty(X)
        stop
    end
    
    if isempty(agency)
        stop;
    end
        
    
    [~,headers] = xlsread([basedir,dirlist(i).name],'B1:T1');
    [~,sstr] = xlsread([basedir,dirlist(i).name],'A2:A500000','basic');
    
    if strcmpi(agency,'DPIE-bouy') == 1
        
        for bb = 1:length(sstr(:,1))
            
            ft = strsplit(sstr{bb,1},' ');
            
            if length(ft) == 1
                mdate(bb,1) = datenum(ft{1},'dd/mm/yyyy');
                
            else
                if strcmpi(ft{3},'AM') == 1
                    mdate(bb,1) = datenum(sstr{bb,1},'dd/mm/yyyy HH:MM:SS AM');
                else
                    mdate(bb,1) = datenum(sstr{bb,1},'dd/mm/yyyy HH:MM:SS PM');
                end
            end
        end
        
        
    else
        
    
    mdate = datenum(sstr(:,1),'dd/mm/yyyy');
    end
    
    site_ID = regexprep(site_ID,' ','_');
    
    
    for j = 1:length(headers)
        
        [snum,~,scell] = xlsread([basedir,dirlist(i).name],[char(65+j),'2:',char(65+j),'500000']);
        
%         if length(snum) < length(mdate)
%             stop;
%         end
        
        ttt = find(strcmpi(old,headers{j}) == 1);
        
        if ~isempty(snum)
                sss = find(~isnan(snum)==1);
                inc = 1;
                for k = 1:length(mdate)
                    
                    val = scell{k};
                    
                    if ~isempty(val)
                    
                        hawkesbury_v2.(site_ID).(nvars{ttt}).Data(inc,1) = val * conv(ttt);
                        hawkesbury_v2.(site_ID).(nvars{ttt}).Date(inc,1) = mdate(k,1);
                        inc = inc + 1;
                
                    end
                end
                hawkesbury_v2.(site_ID).(nvars{ttt}).Depth(1:length(hawkesbury_v2.(site_ID).(nvars{ttt}).Date),1) = 0;
                hawkesbury_v2.(site_ID).(nvars{ttt}).X = X;
                hawkesbury_v2.(site_ID).(nvars{ttt}).Y = Y;
                hawkesbury_v2.(site_ID).(nvars{ttt}).Name = site_ID;
                hawkesbury_v2.(site_ID).(nvars{ttt}).Units = units{j};
                hawkesbury_v2.(site_ID).(nvars{ttt}).Agency = agency;
        end
    end
    
    
    
end


sites = fieldnames(hawkesbury_v2);

for i = 1:length(sites)
    if isfield(hawkesbury_v2.(sites{i}),'WQ_DIAG_TOT_TSS')
        hawkesbury_v2.(sites{i}).WQ_NCS_SS1 = hawkesbury_v2.(sites{i}).WQ_DIAG_TOT_TSS;
    end
end


save hawkesbury_v2.mat hawkesbury_v2 -mat;

sites = fieldnames(hawkesbury_v2);
nvars = [];
for i = 1:length(sites)
    vars = fieldnames(hawkesbury_v2.(sites{i}));
    nvars = [nvars;vars];
end
unique(nvars)





