clear all; close all;

load ww.mat;

filename = '..\..\data\Updated\Sydney Water wet weather intensive.xlsx';

% 'Wet weather Nov 2018'
% 'Dry weather May 2017'

[snum,sstr] = xlsread(filename,'Dry weather May 2017','D5:I112');

lat = snum(:,1);
lon = snum(:,2);
site_desc = sstr(:,1);
sdate = sstr(:,2);

[datacell,~] = xlsread(filename,'Dry weather May 2017','J5:S112');

[snum,sstr] = xlsread('dw_conversion_1.xlsx','A2:C11');

AED_Name = sstr(:,2);
conv = snum(:,1);

dw1 = [];

for i = 1:length(sdate)
    thesite = site_desc{i};
    if ~isnan(thesite)
        thenewsite = regexprep(thesite,' ','_');
        thenewsite = regexprep(thenewsite,'/','_');
        thenewsite = regexprep(thenewsite,',','_');
        thenewsite = regexprep(thenewsite,'-','_');
        thenewsite = regexprep(thenewsite,'__','_');
        
        if strcmpi(thenewsite,'Badgeries_Creek_at_Elizabeth_Drive_Bridge_upstream_of_the_confluence_with_South_Creek') == 1
            thenewsite = 'Badgeries_Creek_at_Elizabeth_Drive';
        end
        if strcmpi(thenewsite,'Kemps_Creek_at_Elizabeth_Drive_Bridge_upstream_of_the_confluence_with_South_Creek') == 1
            thenewsite = 'Kemps_Creek_at_Elizabeth_Drive';
        end        
        if strcmpi(thenewsite,'Kemps_Creek_at_Elizabeth_Drive_Bridge_upstream_of_the_confluence_with_South_Creek') == 1
            thenewsite = 'Kemps_Creek_at_Elizabeth_Drive';
        end   
        if strcmpi(thenewsite,'South_Creek_at_Elizabether_Drive_Bridge_upstream_of_the_confluence_with_Badgerys_Creek') == 1
            thenewsite = 'South_Creek_at_Elizabether_Drive';
        end  
        if strcmpi(thenewsite,'South_Creek_at_Richmond_Road_Bridge_upstream_Eastern_Creek_inflow') == 1
            thenewsite = 'South_Creek_at_Richmond_Road_Bridge';
        end         
        if strcmpi(thenewsite,'Eastern_Creek_at_Richmond_Rd_upstream_of_junction_with_Breakfast_Creek') == 1
            thenewsite = 'Eastern_Creek_at_Richmond_Rd';
        end 
        
        if strcmpi(thenewsite,'Eastern_Creek_at_Garfield_Road_Bridge_downstream_Breakfast_Creek') == 1
            thenewsite = 'Eastern_Creek_at_Garfield_Road';
        end  
        thedate = sdate{i};
        
        if ~isnan(thedate)
            
            mdate = datenum(thedate,'dd/mm/yyyy');
            
            for j = 1:length(AED_Name)
                thedata = datacell(i,j);
                
                if ~isnumeric(thedata)
                    thedata = str2num(thedata);
                end
                
                if ~isnan(thedata)
                    
                    if strcmpi(AED_Name{j},'Ignore') == 0
                        
                        thedata = thedata * conv(j);
                        
                        sss = find(strcmpi(site_desc,thesite) == 1);
                        
                        if ~isempty(sss)
                            
                            disp([thenewsite,' ',AED_Name{j},' ',num2str(thedata)]);
                            
                            dw1.(thenewsite).(AED_Name{j}).Date = mdate;
                            dw1.(thenewsite).(AED_Name{j}).Data = thedata;
                            dw1.(thenewsite).(AED_Name{j}).Depth = 0;
                            dw1.(thenewsite).(AED_Name{j}).Lon = lon(sss(1));
                            dw1.(thenewsite).(AED_Name{j}).Lat = lat(sss(1));
                            dw1.(thenewsite).(AED_Name{j}).Agency = 'SWC-ww';
                            
                        end
                    end
                end
            end
        end
    end
end

save dw1.mat dw1 -mat;