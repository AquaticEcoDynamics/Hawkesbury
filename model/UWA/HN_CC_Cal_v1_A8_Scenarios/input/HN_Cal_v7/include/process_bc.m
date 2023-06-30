clear all; close all;

fid = fopen('HN_Cal_v6.fvelbc','rt');

out = fopen('ELBC.csv','wt');

while ~feof(fid)
    
    fline = fgetl(fid);
    
    sp = split(fline,'==');
    
    sp = regexprep(sp,' ','');
    
    if strcmpi(sp{1},'bc') == 1
        fprintf(out,'%s\n',fline);
    end
end
fclose all;