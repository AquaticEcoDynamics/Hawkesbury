clear all; close all;

shp = shaperead('Transectpnt_HN_100.shp');

for i = 1:length(shp)
    shp(i).km = shp(i).cngmeters / 1000;
end

shapewrite(shp,'Transectpnt_HN_100.shp');