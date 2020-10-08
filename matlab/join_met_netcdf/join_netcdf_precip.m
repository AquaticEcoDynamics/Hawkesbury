clear all; close all;

basedir = 'D:\Github\Hawkesbury\model\UWA\HN_Cal_v6\bc\Meteorological\';

basename = 'Reprojected_Modified_JBFA516397_accum_prcp';

ncfile1 = [basename,'_2012.nc'];
ncfile2 = [basename,'_2013.nc'];
ncfile3 = [basename,'_2014.nc'];
ncfile4 = [basename,'_2015.nc'];
ncfile5 = [basename,'_2017.nc'];
ncfile6 = [basename,'_2018.nc'];

years = [2012 2013 2014 2015 2017 2018];

basedate = datenum(2012,01,01,01,00,00);

outnc = 'Precip.nc';

var = 'accum_prcp';

%copyfile([basedir,ncfile1],outnc,'f');

data.nc1 = tfv_readnetcdf([basedir,ncfile1],'names',{var;'time';'easting';'northing'});

easting = data.nc1.easting;
northing = data.nc1.northing;


ntime = data.nc1.time;
ndata = data.nc1.(var);
for i = 2:length(years)
    
    site = ['nc',num2str(i)];
    filename = ['Reprojected_Modified_JBFA516397_accum_prcp_',num2str(years(i)),'.nc'];
    
    hourdate = [];
    
    data.(site) = tfv_readnetcdf([basedir,filename],'names',{var;'time'});
    
    
    
    byear = years(i);
    
    mdate = datenum(byear,01,01,01,00,00) + (data.(site).time/ 24);
    
    hourdate = round((mdate - basedate)* 24);
    
    ntime = [ntime;hourdate];
    
    ndata = cat(3,ndata,data.(site).(var));

end

[sx,sy,sz] = size(ndata);


ncid = netcdf.create(outnc, 'NC_CLOBBER');

time_dimID = netcdf.defDim(ncid,'time',sz); %time
y_dimID = netcdf.defDim(ncid,'northing',sy);%latitude
x_dimID = netcdf.defDim(ncid,'easting',sx);%longitude

time_varid = netcdf.defVar(ncid,'time','double',time_dimID);
x_varid = netcdf.defVar(ncid,'easting','double',x_dimID);
y_varid = netcdf.defVar(ncid,'northing','double',y_dimID);


u_varid = netcdf.defVar(ncid,var,'double',[y_dimID,x_dimID,time_dimID]);

% Time
netcdf.putAtt(ncid,time_varid,'long_name','time');
netcdf.putAtt(ncid,time_varid,'units','hours since 2012-01-01 01:00:00');
% Lat
netcdf.putAtt(ncid,y_varid,'units','metres');
netcdf.putAtt(ncid,y_varid,'long_name','northing');
netcdf.putAtt(ncid,y_varid,'projection','MGA56 GDA94');
% Long
netcdf.putAtt(ncid,x_varid,'units','metres');
netcdf.putAtt(ncid,x_varid,'long_name','easting');
netcdf.putAtt(ncid,x_varid,'projection','MGA56 GDA94');

% The Var
netcdf.putAtt(ncid,u_varid,'units','kg m-2');
netcdf.putAtt(ncid,u_varid,'long_name','accum_prcp');

netcdf.endDef(ncid);


disp('Writing Time');
netcdf.putVar(ncid,time_varid,0,sz,ntime);
netcdf.putVar(ncid,y_varid,0,sy,northing);
netcdf.putVar(ncid,x_varid,0,sx,easting);

% U Data
disp('Writing U');
netcdf.putVar(ncid,u_varid,[0,0,0],[sx,sy,sz],ndata);

netcdf.close(ncid)% Close the file.

