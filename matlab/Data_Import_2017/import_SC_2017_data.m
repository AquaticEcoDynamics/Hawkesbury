clear all; close all;
%___________________________________________________________

filename = '../../data/All_SouthCreekData/Hawkesbury South Creek.xls';

[~,site_info] = xlsread(filename,'B2:B67');

site_name = regexprep(site_info,' ','_');
usites = unique(site_name);
%___________________________________________________________
[snum,~] = xlsread(filename,'D2:E67');

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

[~,sdate] = xlsread(filename,'AD2:AD67');

mdate = datenum(sdate,'dd/mm/yyyy');

%___________________________________________________________


[snum,sstr] = xlsread('conversion.xlsx','B2:C100');

AED_Name = sstr(:,1);
conv = snum(:,1);

%___________________________________________________________

[data,~] = xlsread(filename,'G2:CB67');
%___________________________________________________________

sc_2017 = [];

for i = 1:length(usites)
    for j = 1:length(AED_Name)
        if j < 8
            Dep = sed_depth;
        else
            Dep = water_depth;
        end
        
        
        sss = find(strcmpi(site_name,usites{i}) == 1);
        
        if strcmpi(AED_Name{j},'Ignore') == 0
            
            if data(sss,j) < 9999
            
            sc_2017.(usites{i}).(AED_Name{j}).Data(:,1) = data(sss,j) * conv(j);
            sc_2017.(usites{i}).(AED_Name{j}).Date(:,1) = mdate(sss);
            sc_2017.(usites{i}).(AED_Name{j}).Depth(:,1) = Dep(sss);
            sc_2017.(usites{i}).(AED_Name{j}).X = X(sss(1));
            sc_2017.(usites{i}).(AED_Name{j}).Y = Y(sss(1));
            sc_2017.(usites{i}).(AED_Name{j}).Agency = 'DPIE-sc';
            end
        end
    end
end

save sc_2017.mat sc_2017 -mat
save('..\modeltools\matfiles\sc_2017.mat','sc_2017','-mat');          
avars = []; 

sites = fieldnames(sc_2017);

for i = 1:length(sites)
    t = fieldnames(sc_2017.(sites{i}));
    
    avars = [avars;t];
end

uvars = unique(avars);
        
        





