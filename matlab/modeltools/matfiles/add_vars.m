% Before running make sure to back up your matfile

load hawkesbury_all.mat

sites = fieldnames(hawkesbury_all);

for i = 1:length(sites)
    
    if isfield(hawkesbury_all.(sites{i}),'ECLOI') == 1
        hawkesbury_all.(sites{i}).ECOLI = hawkesbury_all.(sites{i}).ECLOI;
        hawkesbury_all.(sites{i}).WQ_TRC_TR2 = hawkesbury_all.(sites{i}).ECLOI;
    end
    
     if isfield(hawkesbury_all.(sites{i}),'ENT') == 1
        hawkesbury_all.(sites{i}).WQ_TRC_TR4 = hawkesbury_all.(sites{i}).ENT;
     end   
end

save hawkesbury_all.mat hawkesbury_all -mat;

