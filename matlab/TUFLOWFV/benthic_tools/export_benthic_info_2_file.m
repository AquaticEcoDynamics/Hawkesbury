function export_benthic_info_2_file
%The function creates an AED2 Benthic IC file from an existing 2dm file and
%a spreadsheet containing variables and material zone information.


% The 2dm file with pre-configured material zones
bathy_file = 'example_bathy.2dm';

% Spreadsheet conatining the variables, material zone ID and the values
% that will be used in the file
benthic_info = 'Benthic_Info.xlsx';

%AED2 benthic filename that will be created
outfile = 'AED_Initial.csv';

%Directory to save the images to
outdir_plots = 'Images/';



%%%% Shouldn't need to change anything under here. Only if you have a huge
%%%% number of variables, or an odd 2DM file...

[XX,YY,nodeID,faces,Cell_X,Cell_Y,Cell_ID,Cell_Z,Mat] = tfv_get_node_from_2dm(bathy_file);


[~,headers] = xlsread(benthic_info,'A1:Z1');

[data,~]= xlsread(benthic_info,'A2:Z10000');

fid = fopen(outfile,'wt');

fprintf(fid,'ID,');

savedata = [];

for i = 2:length(headers)
    if i == length(headers)
        fprintf(fid,'%s\n',headers{i});
    else
        fprintf(fid,'%s,',headers{i});
    end
end
for i = 1:length(Cell_ID)
    fprintf(fid,'%i,',Cell_ID(i));
    
    ss = find(data(:,1) == Mat(i));
    
    savedata(i,1) = i;
    for j = 2:length(headers)
        savedata(i,j) = data(ss,j);
        if j == length(headers)
            
            fprintf(fid,'%4.4f\n',data(ss,j));
        else
            fprintf(fid,'%4.4f,',data(ss,j));
        end
    end
end
fclose(fid);

%save savedata.mat savedata -mat;
%Plotting



if ~exist(outdir_plots,'dir')
    mkdir(outdir_plots);
end

for i = 2:length(headers)
    filename = [outdir_plots,headers{i},'.png'];
    
    tfv_plot_init_condition(XX,YY,faces',savedata(:,i),filename,regexprep(headers{i},'_',' '));
end








function [XX,YY,nodeID,faces,Cell_X,Cell_Y,Cell_ID,Cell_Z,Mat] = tfv_get_node_from_2dm(filename)


fid = fopen(filename,'rt');

fline = fgetl(fid);
fline = fgetl(fid);
fline = fgetl(fid);
fline = fgetl(fid);


str = strsplit(fline);

inc = 1;
Mat(inc,1) = str2double(str{end});

switch str{1}
    case 'E4Q'
        for ii = 1:4
            faces(ii,inc) = str2double(str{ii + 2});
        end
    case 'E3T'
        for ii = 1:3
            faces(ii,inc) = str2double(str{ii + 2});
        end
        faces(4,inc) = str2double(str{3});
    otherwise
end

inc = inc + 1;
fline = fgetl(fid);
str = strsplit(fline);
while strcmpi(str{1},'ND') == 0
    Mat(inc,1) = str2double(str{end});
    switch str{1}
        case 'E4Q'
            for ii = 1:4
                faces(ii,inc) = str2double(str{ii + 2});
            end
        case 'E3T'
            for ii = 1:3
                faces(ii,inc) = str2double(str{ii + 2});
            end
            faces(4,inc) = str2double(str{3});
        otherwise
    end
    inc = inc + 1;
    fline = fgetl(fid);
    str = strsplit(fline);
    
end

inc = 1;

nodeID(inc,1) = str2double(str{2});
XX(inc,1) = str2double(str{3});
YY(inc,1) = str2double(str{4});
ZZ(inc,1) = str2double(str{5});

inc = 2;
fline = fgetl(fid);
str = strsplit(fline);

while strcmpi(str{1},'ND') == 1
    nodeID(inc,1) = str2double(str{2});
    XX(inc,1) = str2double(str{3});
    YY(inc,1) = str2double(str{4});
    ZZ(inc,1) = str2double(str{5});

    inc = inc + 1;
    fline = fgetl(fid);
    str = strsplit(fline);
    
end

fclose(fid);

Cell_X(1:length(faces),1) = NaN;
Cell_Y(1:length(faces),1) = NaN;
Cell_ID(1:length(faces),1) = NaN;
Cell_Z(1:length(faces),1) = NaN;


for ii = 1:length(faces)
    gg = polygeom(XX(faces(:,ii)),YY(faces(:,ii)));
    Cell_X(ii) = gg(2);
    Cell_Y(ii) = gg(3);
    Cell_ID(ii) = ii;
    Cell_Z(ii) = mean(ZZ(faces(:,ii)));
end

function tfv_plot_init_condition(X,Y,faces,data,filename,title)

vert(:,1) = X;
vert(:,2) = Y;

disp(['Plotting: ',title]);


figure

% axes('position',[0.1 0.6 0.4 0.3])
% plot([1:length(data)],data,'k');
% set(gca,'box','on');
% 
% set(gca,'XTick',get(gca,'XTick'),'fontsize',6);
% set(gca,'YTick',get(gca,'YTick'),'fontsize',6);


axes('position',[0 0 1 1]);

cdata = data;
fig.ax = patch('faces',faces,'vertices',vert,'FaceVertexCData',cdata);shading flat
axis equal

set(gca,'Color','None',...
    'box','on');

set(findobj(gca,'type','surface'),...
    'FaceLighting','phong',...
    'AmbientStrength',.3,'DiffuseStrength',.8,...
    'SpecularStrength',.9,'SpecularExponent',25,...
    'BackFaceLighting','unlit');

axis off
set(gca,'box','off');

text(0.1,0.95,regexprep(title,'_',' - '),...
        'Units','Normalized',...
        'Fontname','Candara',...
        'Fontsize',16);


cb = colorbar;

set(cb,'position',[0.9 0.2 0.01 0.4],...
    'units','normalized');

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 18;
ySize = 10;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])

print(gcf,'-dpng',filename,'-opengl');

close;

function [ geom, iner, cpmo ] = polygeom( x, y )
%POLYGEOM Geometry of a planar polygon
%
%   POLYGEOM( X, Y ) returns area, X centroid,
%   Y centroid and perimeter for the planar polygon
%   specified by vertices in vectors X and Y.
%
%   [ GEOM, INER, CPMO ] = POLYGEOM( X, Y ) returns
%   area, centroid, perimeter and area moments of
%   inertia for the polygon.
%   GEOM = [ area   X_cen  Y_cen  perimeter ]
%   INER = [ Ixx    Iyy    Ixy    Iuu    Ivv    Iuv ]
%     u,v are centroidal axes parallel to x,y axes.
%   CPMO = [ I1     ang1   I2     ang2   J ]
%     I1,I2 are centroidal principal moments about axes
%         at angles ang1,ang2.
%     ang1 and ang2 are in radians.
%     J is centroidal polar moment.  J = I1 + I2 = Iuu + Ivv

% H.J. Sommer III - 02.05.14 - tested under MATLAB v5.2
%
% sample data
% x = [ 2.000  0.500  4.830  6.330 ]';
% y = [ 4.000  6.598  9.098  6.500 ]';
% 3x5 test rectangle with long axis at 30 degrees
% area=15, x_cen=3.415, y_cen=6.549, perimeter=16
% Ixx=659.561, Iyy=201.173, Ixy=344.117
% Iuu=16.249, Ivv=26.247, Iuv=8.660
% I1=11.249, ang1=30deg, I2=31.247, ang2=120deg, J=42.496
%
% H.J. Sommer III, Ph.D., Professor of Mechanical Engineering, 337 Leonhard Bldg
% The Pennsylvania State University, University Park, PA  16802
% (814)863-8997  FAX (814)865-9693  hjs1@psu.edu  www.me.psu.edu/sommer/

% begin function POLYGEOM

% check if inputs are same size
if ~isequal( size(x), size(y) ),
    error( 'X and Y must be the same size');
end

% number of vertices
[ x, ns ] = shiftdim( x );
[ y, ns ] = shiftdim( y );
[ n, c ] = size( x );

% temporarily shift data to mean of vertices for improved accuracy
xm = mean(x);
ym = mean(y);
x = x - xm*ones(n,1);
y = y - ym*ones(n,1);

% delta x and delta y
dx = x( [ 2:n 1 ] ) - x;
dy = y( [ 2:n 1 ] ) - y;

% summations for CW boundary integrals
A = sum( y.*dx - x.*dy )/2;
Axc = sum( 6*x.*y.*dx -3*x.*x.*dy +3*y.*dx.*dx +dx.*dx.*dy )/12;
Ayc = sum( 3*y.*y.*dx -6*x.*y.*dy -3*x.*dy.*dy -dx.*dy.*dy )/12;
Ixx = sum( 2*y.*y.*y.*dx -6*x.*y.*y.*dy -6*x.*y.*dy.*dy ...
    -2*x.*dy.*dy.*dy -2*y.*dx.*dy.*dy -dx.*dy.*dy.*dy )/12;
Iyy = sum( 6*x.*x.*y.*dx -2*x.*x.*x.*dy +6*x.*y.*dx.*dx ...
    +2*y.*dx.*dx.*dx +2*x.*dx.*dx.*dy +dx.*dx.*dx.*dy )/12;
Ixy = sum( 6*x.*y.*y.*dx -6*x.*x.*y.*dy +3*y.*y.*dx.*dx ...
    -3*x.*x.*dy.*dy +2*y.*dx.*dx.*dy -2*x.*dx.*dy.*dy )/24;
P = sum( sqrt( dx.*dx +dy.*dy ) );

% check for CCW versus CW boundary
if A < 0,
    A = -A;
    Axc = -Axc;
    Ayc = -Ayc;
    Ixx = -Ixx;
    Iyy = -Iyy;
    Ixy = -Ixy;
end

% centroidal moments
xc = Axc / A;
yc = Ayc / A;
Iuu = Ixx - A*yc*yc;
Ivv = Iyy - A*xc*xc;
Iuv = Ixy - A*xc*yc;
J = Iuu + Ivv;

% replace mean of vertices
x_cen = xc + xm;
y_cen = yc + ym;
Ixx = Iuu + A*y_cen*y_cen;
Iyy = Ivv + A*x_cen*x_cen;
Ixy = Iuv + A*x_cen*y_cen;

% principal moments and orientation
I = [ Iuu  -Iuv ;
    -Iuv   Ivv ];
[ eig_vec, eig_val ] = eig(I);
I1 = eig_val(1,1);
I2 = eig_val(2,2);
ang1 = atan2( eig_vec(2,1), eig_vec(1,1) );
ang2 = atan2( eig_vec(2,2), eig_vec(1,2) );

% return values
geom = [ A  x_cen  y_cen  P ];
iner = [ Ixx  Iyy  Ixy  Iuu  Ivv  Iuv ];
cpmo = [ I1  ang1  I2  ang2  J ];

% end of function POLYGEOM