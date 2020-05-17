clear all; close all;

filename = '..\..\data\Updated\Sydney Water wet weather intensive.xlsx';

% 'Wet weather Nov 2018'
% 'Dry weather May 2017'

[snum,sstr] = xlsread(filename,'Dry weather May 2017','D5:I112');

lat = snum(:,1);
lon = snum(:,2);
site_desc = sstr(:,1);

[snum,sstr] = xlsread('WW_Conversion.xlsx','A3:C24');

AED_Name = sstr(:,2);
conv = snum(:,1);

[~,~,datacell] = xlsread(filename,'Wet weather Nov 2018','H5:AC113');
[~,~,datecell] = xlsread(filename,'Wet weather Nov 2018','D5:D113');
[~,~,sitecell] = xlsread(filename,'Wet weather Nov 2018','B5:B113');


%_______________________________________________________________________

% A Check to see if site details are available.
% for i = 1:length(sitecell)
%     thesite = sitecell{i};
%
%     sss = find(strcmpi(site_desc,thesite) == 1);
%
%     if isempty(sss)
%         if ~isnan(thesite)
%             disp(thesite);
%         end
%     end
% end

%lets assume that no site is repeated for now....


ww = [];

for i = 1:length(datecell)
    thesite = sitecell{i};
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
        thedate = datecell{i};
        
        if ~isnan(thedate)
            
            mdate = datenum(thedate,'dd/mm/yyyy');
            
            for j = 1:length(AED_Name)
                thedata = datacell{i,j};
                
                if ~isnumeric(thedata)
                    thedata = str2num(thedata);
                end
                
                if ~isnan(thedata)
                    
                    if strcmpi(AED_Name{j},'Ignore') == 0
                        
                        thedata = thedata * conv(j);
                        
                        sss = find(strcmpi(site_desc,thesite) == 1);
                        
                        if ~isempty(sss)
                            
                            disp([thenewsite,' ',AED_Name{j},' ',num2str(thedata)]);
                            
                            ww.(thenewsite).(AED_Name{j}).Date = mdate;
                            ww.(thenewsite).(AED_Name{j}).Data = thedata;
                            ww.(thenewsite).(AED_Name{j}).Depth = 0;
                            ww.(thenewsite).(AED_Name{j}).Lon = lon(sss(1));
                            ww.(thenewsite).(AED_Name{j}).Lat = lat(sss(1));
                            ww.(thenewsite).(AED_Name{j}).Agency = 'SWC-ww';
                            
                        end
                    end
                end
            end
        end
    end
end

save ww.mat ww -mat;











