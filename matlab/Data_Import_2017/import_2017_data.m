clear all; close all;
%___________________________________________________________

[~,site_info] = xlsread('Hawkesbury main channel.xls','B2:B145');

site_name = regexprep(site_info,' ','_');
usites = unique(site_name);
%___________________________________________________________
[snum,~] = xlsread('Hawkesbury main channel.xls','D2:E145');

lat = snum(:,1);
lon = snum(:,2);
for i = 1:length(lat)
    [X(i), Y(i)] = ll2utm (lon(i), lat(i));
end
%___________________________________________________________

%[sed_depth,~] = xlsread('Hawkesbury main channel.xls','G2:G145');
sed_depth(1:length(site_name),1) = -10;

water_depth(1:length(site_name),1) = 0;

%___________________________________________________________

[~,sdate] = xlsread('Hawkesbury main channel.xls','AD2:AD145');

mdate = datenum(sdate,'dd/mm/yyyy');

%___________________________________________________________


[snum,sstr] = xlsread('conversion.xlsx','B2:C100');

AED_Name = sstr(:,1);
conv = snum(:,1);

%___________________________________________________________

[data,~] = xlsread('Hawkesbury main channel.xls','G2:CB145');
%___________________________________________________________

hawkes_2017 = [];

for i = 1:length(usites)
    for j = 1:length(AED_Name)
        if j < 8
            Dep = sed_depth;
        else
            Dep = water_depth;
        end
        
        
        sss = find(strcmpi(site_name,usites{i}) == 1);
        
        if strcmpi(AED_Name{j},'Ignore') == 0
            
            hawkes_2017.(usites{i}).(AED_Name{j}).Data(:,1) = data(sss,j) * conv(j);
            hawkes_2017.(usites{i}).(AED_Name{j}).Date(:,1) = mdate(sss);
            hawkes_2017.(usites{i}).(AED_Name{j}).Depth(:,1) = Dep(sss);
            hawkes_2017.(usites{i}).(AED_Name{j}).X = X(sss(1));
            hawkes_2017.(usites{i}).(AED_Name{j}).Y = Y(sss(1));
            hawkes_2017.(usites{i}).(AED_Name{j}).Agency = 'DPIE-mc';
            
        end
    end
end

save hawkes_2017.mat hawkes_2017 -mat
save('..\..\..\aed_matlab_modeltools\TUFLOWFV\polygon_timeseries_plotting\matfiles\hawkes_2017.mat','hawkes_2017','-mat');          
avars = []; 

sites = fieldnames(hawkes_2017);

for i = 1:length(sites)
    t = fieldnames(hawkes_2017.(sites{i}));
    
    avars = [avars;t];
end

uvars = unique(avars);
        
        





