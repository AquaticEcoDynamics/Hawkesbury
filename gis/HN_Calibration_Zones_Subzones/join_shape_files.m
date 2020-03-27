clear all; close all;

base = shaperead('HN_Calibration_v2.shp');
new = shaperead('Merged_by_box.shp');

S = base;

inc = length(S) + 1

for i = 3:length(new)
    
    for k = 1:length(base)
        
        [~,on] = inpolygon(new(i).X,new(i).Y,base(k).X,base(k).Y);
        
        if sum(on) > 50
            
            base_name = base(k).Name;
            box_ID = num2str(new(i).Box);
            new_name = [base_name,'_Box_',box_ID];
            
            S(inc).Geometry = 'Polygon';
            S(inc).X = new(i).X;
            S(inc).Y = new(i).Y;
            S(inc).Zone = new_name;
            S(inc).Name = new_name;
            S(inc).Plot_Order = base(k).Plot_Order;
            
            inc = inc + 1;
        end
    end
end

shapewrite(S,'HN_Calibration_v3.shp');
    