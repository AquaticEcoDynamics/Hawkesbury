clear all; close all;

S = shaperead('Transectpnt_HN_100.shp');


int = 1;

Dist(1:length(S),1) = NaN;
Dist(1) = 0;

for i = 2:length(S)
    
    dd = sqrt(power(S(i).X - S(i-1).X,2) + power(S(i).Y - S(i-1).Y,2));
    
    Dist(i) = Dist(i-1)+ dd;
    
end
    
Dist = Dist / 1000;

markers = [0:10:max(Dist)];

for i = 1:length(markers)
    
    [~,m] = min(abs(Dist - markers(i)));
    
        D(int) = S(m);
        int = int + 1;
end
for i = 1:length(markers)   
D(i).Distance = [num2str(markers(i)),' km'];
end
shapewrite(D,'HN_Distances.shp')
    
    