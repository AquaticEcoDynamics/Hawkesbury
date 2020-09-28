clear all; close all;

data = tfv_readnetcdf('lw.nc');

basedate = datenum(2012,01,01,01,00,00);


mtime = basedate + (data.time/24);

lw = squeeze(data.av_lwsfcdown(5,5,:));
figure
plot(mtime,lw,'.');datetick('x');


data = tfv_readnetcdf('wind_2012_2013.nc');

basedate = datenum(2012,01,01,01,00,00);


mtime = basedate + (data.time/24);

av_uwnd10m = squeeze(data.av_uwnd10m(5,5,:));

figure
plot(mtime,av_uwnd10m,'.');datetick('x');