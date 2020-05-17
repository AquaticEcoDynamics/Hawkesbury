clear all; close all;

fid = fopen('include_files/HN_Cal.fvnsbc','rt');

fidout = fopen('nodestring_bcs.csv','wt');

fprintf(fidout,'Site,Nodestring ID\n');

while ~feof(fid)
    fline = fgetl(fid);
    
    str = strsplit(fline,',');
    
    
    
    if strcmpi(str{1},'bc == Q') == 1
        filepath = strsplit(str{end},'/');
        thefile = filepath{end};
        fprintf(fidout,'%s,%s\n',thefile,str{2});
    end
end
fclose(fid);
fclose(fidout);