clear all; close all;

data = tfv_readnetcdf('Temp.nc');

basedate = datenum(2012,01,01,01,00,00);


mtime = basedate + (data.time/24);

lw = squeeze(data.av_temp_scrn(5,5,:));
figure
plot(mtime,lw,'.');datetick('x');

hold on

data2 = tfv_readnetcdf('D:\Github\Hawkesbury\model\UWA\HN_Cal_v5\bc\Meteorological\Temp.nc');

basedate = datenum(2013,01,01,01,00,00);


mtime2 = basedate + (data2.time/24);

lw2 = squeeze(data2.av_temp_scrn(5,5,:));


plot(mtime2,lw2,'.');datetick('x');