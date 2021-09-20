clear all; close all;

load hawkesbury_all.mat;


datearray = datenum(2010,01,01):01:datenum(2021,06,01);

hawkesbury_all = add_secondary_data(hawkesbury_all,datearray);

save hawkesbury_all_TNTP.mat hawkesbury_all -mat;