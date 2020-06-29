clear all; close all;

load D:\Github\Hawkesbury\matlab\modeltools\matfiles/hawkesbury_all.mat;


sites = fieldnames(hawkesbury_all);

for i = 1:length(sites)
    vars = fieldnames(hawkesbury_all.(sites{i}));
    
    S(i).X = hawkesbury_all.(sites{i}).(vars{1}).X;
    S(i).Y = hawkesbury_all.(sites{i}).(vars{1}).Y;
    S(i).Names = sites{i};
    S(i).Agency = hawkesbury_all.(sites{i}).(vars{1}).Agency;
    S(i).Geometry = 'Point';
    
end

shapewrite(S,'Field_Data_sites.shp');