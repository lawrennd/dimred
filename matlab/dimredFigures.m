% DIMREDFIGURES Plot some of the figures used in the Book.

% DIMRED

suffix = 'Interspeech';
fontName = 'helvetica';
close all
colordef white
randn('seed', 1e6)
rand('seed', 1e6)

printDiagram = 1;
model = dimredPlotMog(5, 200);
if exist('printDiagram') & printDiagram
  mogPrintPlot(model, [], ['Artificial', suffix], 1);
end

model = dimredPlotMog(20, 200);
if exist('printDiagram') & printDiagram
  mogPrintPlot(model, [], ['Artificial', suffix], 2);
end


% Oil with missing data.
figure
[Y, lbls] = lvmLoadData('oil');
missing = rand(size(Y));
Y(find(missing>0.9)) = NaN;
X = ppcaEmbed(Y, 2);
lvmTwoDPlot(X, lbls, getSymbols(3));
set(gca, 'fontname', fontName);
set(gca, 'fontsize', 20);
printPlot(['oilMissing90Project', suffix], '../tex/diagrams/', '../html/')

figure
[Y, lbls] = lvmLoadData('oil');
missing = rand(size(Y));
Y(find(missing>0.8)) = NaN;
X = ppcaEmbed(Y, 2);
X = X(:, 2:-1:1);
lvmTwoDPlot(X, lbls, getSymbols(3));
set(gca, 'fontname', fontName);
set(gca, 'fontsize', 20);
printPlot(['oilMissing80Project', suffix], '../tex/diagrams/', '../html/')

figure
[Y, lbls] = lvmLoadData('oil');
missing = rand(size(Y));
Y(find(missing>0.7)) = NaN;
X = ppcaEmbed(Y, 2);
X = X(:, 2:-1:1);
X(:, 2) = -X(:, 2);
lvmTwoDPlot(X, lbls, getSymbols(3));
set(gca, 'fontname', fontName);
set(gca, 'fontsize', 20);
printPlot(['oilMissing70Project', suffix], '../tex/diagrams/', '../html/')


figure
[Y, lbls] = lvmLoadData('oil');
missing = rand(size(Y));
Y(find(missing>0.5)) = NaN;
X = ppcaEmbed(Y, 2);
X(:, 2) = -X(:, 2);
lvmTwoDPlot(X, lbls, getSymbols(3));
set(gca, 'fontname', fontName);
set(gca, 'fontsize', 20);
printPlot(['oilMissing50Project', suffix], '../tex/diagrams/', '../html/')

figure
[Y, lbls] = lvmLoadData('oil');
X = ppcaEmbed(Y, 2);
lvmTwoDPlot(X, lbls, getSymbols(3));
set(gca, 'fontname', fontName);
set(gca, 'fontsize', 20);
printPlot(['oilMissingFullProject', suffix], '../tex/diagrams/', '../html/')

% One dimensional Gaussian Egg
%x1 = linspace(-3, -2, 100);
x2 = linspace(-3, -1.05, 100);
x3 = linspace(-1.05, -0.95, 100);
x4 = linspace(-.95, .95, 100);
x5 = linspace(.95, 1.05, 100);
x6 = linspace(1.05, 3, 100);
%x7 = linspace(2, 3, 100);

%y1 = 1/sqrt(2*pi)*exp(-x1.*x1/2);
y2 = 1/sqrt(2*pi)*exp(-x2.*x2/2);
y3 = 1/sqrt(2*pi)*exp(-x3.*x3/2);
y4 = 1/sqrt(2*pi)*exp(-x4.*x4/2);
y5 = 1/sqrt(2*pi)*exp(-x5.*x5/2);
y6 = 1/sqrt(2*pi)*exp(-x6.*x6/2);
%y7 = 1/sqrt(2*pi)*exp(-x7.*x7/2);

%y1 = [0 y1 0];
%x1 = [-3 x1 -2];

y2 = [0 y2 0];
x2 = [-3 x2 -1.05];

y3 = [0 y3 0];
x3 = [-1.05 x3 -.95];

y4 = [0 y4 0];
x4 = [-.95 x4 .95];

y5 = [0 y5 0];
x5 = [.95 x5 1.05];

y6 = [0 y6 0];
x6 = [1.05 x6 3];

%y7 = [0 y7 0];
%x7 = [2 x7 3];

figure
%plot(x1, y1, 'k-')
hold on
plot(x2, y2, 'k-')
plot(x3, y3, 'k-')
plot(x4, y4, 'k-')
plot(x5, y5, 'k-')
plot(x6, y6, 'k-')
%plot(x7, y7, 'k-')
axis off
plot2svg(['../tex/diagrams/gaussian', suffix, '.svg'])


% Two dimensional Gaussian egg
figure
piVals = linspace(-pi, pi, 200)';
x = [sin(piVals) 0.6*cos(piVals)];
xl = x*0.95;
line(xl(:, 1), xl(:, 2), 'linewidth', 2);
xl = x*1.05;
line(xl(:, 1), xl(:, 2), 'linewidth', 2);
xl = x*3;
line(xl(:, 1), xl(:, 2), 'linewidth', 2);
%xl = x*3;
%line(xl(:, 1), xl(:, 2), 'linewidth', 2);
axis off
plot2svg(['../tex/diagrams/gaussian2', suffix, '.svg'])


randn('seed', 1e7)
x = linspace(-1, 1, 30);
y = linspace(-1, 1, 30);
[xMat, yMat] = meshgrid(x, y);

X = [xMat(:), yMat(:)];
kern = kernCreate(X, 'mlp');
K = kernCompute(kern, X);
z = gsamp(zeros(size(K, 1), 1), K, 1);
zMat = reshape(z, 30, 30);

surf(xMat, yMat, zMat);
shading faceted
colormap pink
axis off
plot2svg(['../tex/diagrams/manifoldData', suffix, '.svg'])

figure
surf(xMat, yMat, zeros(size(zMat)))
set(gca, 'cameraposition',  [0.5000    0.5000    9.1603])
set(gca, 'cameraupvector', [0 1 0])
shading faceted
colormap pink
axis off
plot2svg(['../tex/diagrams/manifoldLatent', suffix, '.svg'])


figure
dimredDimensionMass(['dimensionMass', suffix], fontName)

figure 
a = randn(2);
a = a*a';
Y = gsamp([0, 0], a, 300);
a = plot(Y(:, 1), Y(:, 2), 'r.');
set(a, 'markersize', 10);
set(gca, 'fontsize', 20)
set(gca, 'fontName', fontName);
zeroAxes(gca);
printPlot(['twoDGaussianSamples', suffix], '../tex/diagrams/', '../html/')


figure
Y = randn(100, 1000);
dimredPlotSquaredDistances(Y, ['gaussianDistances100', suffix]);

figure
Y = randn(1000, 1000);
dimredPlotSquaredDistances(Y, ['gaussianDistances1000', suffix]);



figure
W = randn(1000, 2);
covMat = W*W' +1e-2*eye(1000);
Y = gsamp(zeros(1, 1000), covMat, 1000);
v = dimredPlotSquaredDistances(Y, ['correlatedGaussianDistances1000', suffix]);


% normalise data to be variance 1 for each dimension.
varY = var(Y);
stdY = sqrt(varY);
Y = Y./repmat(stdY, size(Y, 1), 1);

d = triu(dist2(Y, Y));
v = d(find(d>eps));

% Normalise distances to be 1.
v = 2*v/mean(v);

figure
[vals, x] = hist(v, 50);
vals = vals/(sum(vals)*mean(x(2:end) - x(1:end-1) ));

bar(x, vals);
hold on
a = xlabel('squared distance');
set(a, 'fontname', fontName);
set(a, 'fontsize', 25);
x = linspace(0, 6, 100);
ha = plot(x, gammaPdf(x, size(W, 2)/2, size(W, 2)/4), 'k-');
set(ha, 'linewidth', 3);
set(gca, 'xlim', [0, 6]);
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
if printDiagram
  printPlot(['correlatedGaussianDistances2', suffix], '../tex/diagrams/', '../html')
end

figure
Y = lvmLoadData('spellman');
v = dimredPlotSquaredDistances(Y, ['spellmanDistances', suffix]);

figure
Y = lvmLoadData('stick');
v = dimredPlotSquaredDistances(Y, ['stickDistances', suffix]);

figure
Y = lvmLoadData('oil');
v = dimredPlotSquaredDistances(Y, ['oilDistances', suffix]);

figure
Y = lvmLoadData('grid_vowels');
v = dimredPlotSquaredDistances(Y, ['grid_vowelsDistances', suffix]);

lims = [-6 6];
figure
x = linspace(lims(1), lims(2), 200);
y1 = 1/sqrt(2*pi)*exp(-0.5*((x-0.5).*(x-0.5)));
y2 = 1/sqrt(2*pi)*exp(-0.5*((x+0.5).*(x+0.5)));
ha = plot(x, y1, 'k-')
hold on, 
ha = [ha plot(x, y2, 'k--')];
ha = [ha plot(x, 0.5*(y1+y2), 'k:')];
ha = [ha plot(x, y1./(y1+y2), 'k.-')];
set(ha, 'linewidth', 3)
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
set(gca, 'xlim', [lims(1) lims(2)])
printPlot(['gaussianPosteriors1sd', suffix], '../tex/diagrams/', '../html/')

figure
x = linspace(lims(1), lims(2), 200);
y1 = 1/sqrt(2*pi)*exp(-0.5*((x-1).*(x-1)));
y2 = 1/sqrt(2*pi)*exp(-0.5*((x+1).*(x+1)));
ha = plot(x, y1, 'k-')
hold on, 
ha = [ha plot(x, y2, 'k--')];
ha = [ha plot(x, 0.5*(y1+y2), 'k:')];
ha = [ha plot(x, y1./(y1+y2), 'k.-')];
set(ha, 'linewidth', 3)
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
set(gca, 'xlim', [lims(1) lims(2)])
printPlot(['gaussianPosteriors2sd', suffix], '../tex/diagrams/', '../html/')

figure
x = linspace(lims(1), lims(2), 200);
y1 = 1/sqrt(2*pi)*exp(-0.5*((x-3).*(x-3)));
y2 = 1/sqrt(2*pi)*exp(-0.5*((x+3).*(x+3)));
ha = plot(x, y1, 'k-')
hold on, 
ha = [ha plot(x, y2, 'k--')];
ha = [ha plot(x, 0.5*(y1+y2), 'k:')];
ha = [ha plot(x, y1./(y1+y2), 'k.-')];
set(ha, 'linewidth', 3)
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
set(gca, 'xlim', [lims(1) lims(2)])
printPlot(['gaussianPosteriors6sd', suffix], '../tex/diagrams/', '../html/')

figure
x = linspace(lims(1), lims(2), 200);
y1 = 1/sqrt(2*pi)*exp(-0.5*((x-4).*(x-4)));
y2 = 1/sqrt(2*pi)*exp(-0.5*((x+4).*(x+4)));
ha = plot(x, y1, 'k-')
hold on, 
ha = [ha plot(x, y2, 'k--')];
ha = [ha plot(x, 0.5*(y1+y2), 'k:')];
ha = [ha plot(x, y1./(y1+y2), 'k.-')];
set(ha, 'linewidth', 3)
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
set(gca, 'xlim', [lims(1) lims(2)])
printPlot(['gaussianPosteriors8sd', suffix], '../tex/diagrams/', '../html/')

figure
gridsize = 10;
randn('seed', 1e7)
x = linspace(-.5, .5, gridsize);
y = linspace(-.5, .5, gridsize);
[xMat, yMat] = meshgrid(x, y);
X = [xMat(:), yMat(:)];
kern = kernCreate(X, 'rbf');
K = kernCompute(kern, X);
z = gsamp(zeros(size(K, 1), 1), K, 3)';
%z = z + randn(size(z))*0.01;
a = plot3(z(:, 1), z(:, 2), z(:, 3), 'r.');
set(a, 'markersize', 30)
axis off
ind = findNeighbours(z, 4);
for i = 1:gridsize*gridsize
  nn = 4;
  if i<gridsize+1
    nn = nn-1;
  end
  if i>gridsize*(gridsize-1)
    nn = nn-1;
  end
  if ~rem(i-1, gridsize)
    nn = nn-1; 
  end
  if ~rem(i, gridsize)
    nn = nn-1;
  end
  for j = 1:nn
    h = line([z(i, 1) z(ind(i, j), 1)], ...
         [z(i, 2) z(ind(i, j), 2)], ...
         [z(i, 3) z(ind(i, j), 3)]);
    set(h, 'linewidth', 2, 'color', [0 0 0]);
  end
end

set(gca, ...
    'CameraPosition', [7.48674 -0.230665 1.60925], ...
    'CameraPositionMode', 'manual', ...
    'CameraTarget', [0 0.5 0.6], ...
    'CameraTargetMode', 'auto', ...
    'CameraUpVector', [0.77909 -0.100531 -0.948464], ...
    'CameraUpVectorMode', 'manual', ...
    'CameraViewAngle', [18.7757], ...
    'CameraViewAngleMode', 'auto')
	
plot2svg(['../tex/diagrams/neighboursGridLatent', suffix, '.svg'])


figure
a = plot3(z(:, 1), z(:, 2), z(:, 3), 'k.');
set(a, 'markersize', 30)
axis off
ind = findNeighbours(X, 4);
for i = 1:gridsize*gridsize
  nn = 4;
  if i<gridsize+1
    nn = nn-1;
  end
  if i>gridsize*(gridsize-1)
    nn = nn-1;
  end
  if ~rem(i-1, gridsize)
    nn = nn-1; 
  end
  if ~rem(i, gridsize)
    nn = nn-1;
  end
  for j = 1:nn
    h = line([z(i, 1) z(ind(i, j), 1)], ...
         [z(i, 2) z(ind(i, j), 2)], ...
         [z(i, 3) z(ind(i, j), 3)]);
    set(h, 'linewidth', 2, 'color', [0 0 0]);
  end
end

set(gca, ...
    'CameraPosition', [7.48674 -0.230665 1.60925], ...
    'CameraPositionMode', 'manual', ...
    'CameraTarget', [0 0.5 0.6], ...
    'CameraTargetMode', 'auto', ...
    'CameraUpVector', [0.77909 -0.100531 -0.948464], ...
    'CameraUpVectorMode', 'manual', ...
    'CameraViewAngle', [18.7757], ...
    'CameraViewAngleMode', 'auto')

plot2svg(['../tex/diagrams/neighboursGridData', suffix, '.svg'])
