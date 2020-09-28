clear all; close all;

load hawkesbury_all.mat;
sites = fieldnames(hawkesbury_all);

for i = 1:length(sites)
    vars = fieldnames(hawkesbury_all.(sites{i}));
    
    if isfield(hawkesbury_all.(sites{i}),'ECLOI')
        
        if strcmpi(hawkesbury_all.(sites{i}).ECLOI.Agency,'SWC') == 1
            hawkesbury_all.(sites{i}) = rmfield(hawkesbury_all.(sites{i}),'ECLOI');
        end
    end
end

save hawkesbury_all.mat hawkesbury_all -mat;
        
    