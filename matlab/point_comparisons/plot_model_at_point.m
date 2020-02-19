clear all; close all;

ncfile = 'I:\Hawkesbury\HN_Cal_v3\output\HN_Cal_warmup_WQ_TR01_TO_TR10_p.nc';
ncfile2 = 'I:\Hawkesbury\HN_Cal_v3\output\HN_Cal_warmup_WQ_TR01_TO_TR10.nc';

outdir = 'I:\Hawkesbury\Plots\';

datearray = [datenum(2005,11,25):6/24:datenum(2005,11,27,00,00,00)];

%varname = 'WQ_DIAG_LND_SB';
varname = 'TRACE_2';

%___________________
data = tfv_readnetcdf(ncfile);
mtime  = tfv_readnetcdf(ncfile,'time',1);

surface_data = data.(varname)(data.idx3(data.idx3 > 0),:);

X = 281838.05;
Y = 6212888.35;


pnt(1,1) = X;
pnt(1,2) = Y;

geo_x = double(data.cell_X);
geo_y = double(data.cell_Y);
dtri = DelaunayTri(geo_x,geo_y);
pt_id = nearestNeighbor(dtri,pnt);

%________________

data2 = tfv_readnetcdf(ncfile2);
mtime2  = tfv_readnetcdf(ncfile2,'time',1);

surface_data2 = data2.(varname)(data.idx3(data.idx3 > 0),:);

X = 281838.05;
Y = 6212888.35;


pnt(1,1) = X;
pnt(1,2) = Y;

geo_x = double(data2.cell_X);
geo_y = double(data2.cell_Y);
dtri = DelaunayTri(geo_x,geo_y);

pt_id2 = nearestNeighbor(dtri,pnt);

%____________________

figure('position',[1000.33333333333          917.666666666667                      1004                       420]);
plot(mtime.Time,surface_data(pt_id,:),'b');hold on
plot(mtime2.Time,surface_data2(pt_id2,:),'r');hold on


xlim([datearray(1) datearray(end)]);
set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'dd/mm HH:MM'));

legend({'With Profiles';'Without Profiles'});
grid on;
xlabel('Time');
ylabel('Trace 2 (SiO2 mmol/m^3)');
title('Surface Concentration at N91');
saveas(gcf,[outdir,'SiO2 @ N91.png']);

clear all; close all; fclose all;