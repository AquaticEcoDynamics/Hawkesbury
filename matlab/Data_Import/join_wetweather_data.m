clear all; close all;

load ww.mat;
load dw1.mat;
load dw2.mat;

ww_all = ww;

sites = fieldnames(dw1);

for i = 1:length(sites)
    
    vars = fieldnames(dw1.(sites{i}));
    
    if isfield(ww_all,sites{i})
        
        for j = 1:length(vars)
            if isfield(ww_all.(sites{i}),vars{j})
                
                ww_all.(sites{i}).(vars{j}).Date = [ww_all.(sites{i}).(vars{j}).Date;dw1.(sites{i}).(vars{j}).Date];
                ww_all.(sites{i}).(vars{j}).Data = [ww_all.(sites{i}).(vars{j}).Data;dw1.(sites{i}).(vars{j}).Data];
                ww_all.(sites{i}).(vars{j}).Depth = [ww_all.(sites{i}).(vars{j}).Depth;dw1.(sites{i}).(vars{j}).Depth];
            else
                ww_all.(sites{i}).(vars{j}) = dw1.(sites{i}).(vars{j});
            end
        end
        
        
        
    else
        ww_all.(sites{i}) = dw1.(sites{i});
    end
    
end

sites = fieldnames(dw2);

for i = 1:length(sites)
    
    vars = fieldnames(dw2.(sites{i}));
    
    if isfield(ww_all,sites{i})
        
        for j = 1:length(vars)
            if isfield(ww_all.(sites{i}),vars{j})
                
                ww_all.(sites{i}).(vars{j}).Date = [ww_all.(sites{i}).(vars{j}).Date;dw2.(sites{i}).(vars{j}).Date];
                ww_all.(sites{i}).(vars{j}).Data = [ww_all.(sites{i}).(vars{j}).Data;dw2.(sites{i}).(vars{j}).Data];
                ww_all.(sites{i}).(vars{j}).Depth = [ww_all.(sites{i}).(vars{j}).Depth;dw2.(sites{i}).(vars{j}).Depth];
            else
                ww_all.(sites{i}).(vars{j}) = dw2.(sites{i}).(vars{j});
            end
        end
        
        
        
    else
        ww_all.(sites{i}) = dw2.(sites{i});
    end
    
end


sites = fieldnames(ww_all);

for i = 1:length(sites)
    vars = fieldnames(ww_all.(sites{i}));
    for j = 1:length(vars)
        
        [ww_all.(sites{i}).(vars{j}).X, ww_all.(sites{i}).(vars{j}).Y] = ll2utm (ww_all.(sites{i}).(vars{j}).Lon, ...
            ww_all.(sites{i}).(vars{j}).Lat);
        
    end
end

save ww_all.mat ww_all -mat;
        
