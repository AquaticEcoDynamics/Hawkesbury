clear all; close all;

basedir = 'E:\Github 2018\Hawkesbury\data\';

shp = shaperead([basedir,'WQCalibration.shp']);

dirlist = dir([basedir,'*.csv']);
[conv,sstr ] = xlsread('Conversions.xlsx','A3:D10000');
nvars = sstr(:,2);
units = sstr(:,4);

hawkesbury = [];

for i = 1:length(dirlist)
    disp(dirlist(i).name);
    
    str = strsplit(dirlist(i).name,'_');
    
    site_ID = str{1};
    X =[];
    Y = [];
    for j = 1:length(shp)
        
        if strcmpi(shp(j).Site_Code,site_ID) == 1
            X = shp(j).X;
            Y = shp(j).Y;
            
        end
    end
    if isempty(X)
        stop
    end
    
    
    [snum,sstr] = xlsread([basedir,dirlist(i).name],'A2:T10000');
    
    mdate = datenum(sstr(:,1),'dd/mm/yyyy');
    
    for j = 1:length(nvars)
        
        sss = find(~isnan(snum(:,j)) == 1);
        if ~isempty(sss)
        hawkesbury.(site_ID).(nvars{j}).Data = snum(sss,j) * conv(j);
        hawkesbury.(site_ID).(nvars{j}).Date = mdate(sss,1);
        hawkesbury.(site_ID).(nvars{j}).Depth(1:length(sss),1) = 0;
        hawkesbury.(site_ID).(nvars{j}).X = X;
        hawkesbury.(site_ID).(nvars{j}).Y = Y;
        hawkesbury.(site_ID).(nvars{j}).Name = site_ID;
        hawkesbury.(site_ID).(nvars{j}).Units = units{j};
        end
    end
                 
    
    
end

save hawkesbury.mat hawkesbury -mat;

summerise_data(hawkesbury,'Images/','HN_Monitoring.shp');
        