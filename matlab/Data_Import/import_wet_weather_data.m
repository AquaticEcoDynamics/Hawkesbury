clear all; close all;

filename = '..\..\data\Updated\Sydney Water wet weather intensive.xlsx';

% 'Wet weather Nov 2018'
% 'Dry weather May 2017'

[snum,sstr] = xlsread(filename,'Dry weather May 2017','D5:I112');

lat = snum(:,1);
lon = snum(:,2);
site_desc = sstr(:,1);

