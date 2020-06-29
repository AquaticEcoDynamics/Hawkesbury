clear all; close all;

shp = shaperead('../modeltools/gis/Transectpnt_HN_100.shp');

dist(1,1) = 0;

for i = 2:length(shp)
    
    dist(i,1) = sqrt(power((shp(i).X - shp(i-1).X),2) + power((shp(i).Y - shp(i-1).Y),2)) + dist(i-1,1);
    
end

dist = dist / 1000; % convert to km

distarray = [0:10:260];

for i = 1:length(distarray)
    
    [~,ind] = min(abs(dist - distarray(i)));
    S(i).X = shp(ind).X;
    S(i).Y = shp(ind).Y;
    S(i).Geometry = 'Point';
    S(i).Name = [num2str(distarray(i)),' km'];
end
shapewrite(S,'Distance_Markers.shp');