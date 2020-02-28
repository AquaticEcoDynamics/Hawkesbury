clear all; close all;

[snum,sstr] = xlsread('QC_bcs.csv','A2:C10000');

inc = 1;
for i = 1:length(sstr)
    S(inc).X = snum(i,1);
    S(inc).Y = snum(i,2);
    S(inc).Name = regexprep(sstr{i},'.csv','');
    S(inc).Type = 'Element Inflow';
    S(inc).Geometry = 'Point';
    
    inc = inc + 1;
end
[snum,sstr] = xlsread('QC_WWTP_bcs.csv','A2:C10000');

for i = 1:length(sstr)
    S(inc).X = snum(i,1);
    S(inc).Y = snum(i,2);
    S(inc).Name = regexprep(sstr{i},'.csv','');
    S(inc).Type = 'WWTP Inflow';
    S(inc).Geometry = 'Point';
    
    inc = inc + 1;
end
    
shapewrite(S,'QC_BCs.shp');