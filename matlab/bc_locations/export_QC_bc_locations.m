clear all; close all;

fid = fopen('include_files/HN_Cal.fvstp','rt');

fidout = fopen('QC_WWTP_bcs.csv','wt');

fprintf(fidout,'Site,X,Y\n');

while ~feof(fid)
    fline = fgetl(fid);
    
    str = strsplit(fline,',');
    
    
    
    if strcmpi(str{1},'bc == QC') == 1
        filepath = strsplit(str{end},'/');
        thefile = filepath{end};
        fprintf(fidout,'%s,%s,%s\n',thefile,str{2},str{3});
    end
end
fclose(fid);
fclose(fidout);