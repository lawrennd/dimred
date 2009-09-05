% BOOKFIGURES Plot some of the figures used in the Book.


fontName = 'times';
close all
colordef white
randn('seed', 1e6)
rand('seed', 1e6)

printDiagram = 1;
model = dimredPlotMog(5, 200);
if exist('printDiagram') & printDiagram
  mogPrintPlot(model, [], 'ArtificialBook', 1);
end

model = dimredPlotMog(20, 200);
if exist('printDiagram') & printDiagram
  mogPrintPlot(model, [], 'ArtificialBook', 2);
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
print -depsc ../tex/diagrams/oilMissing90Project_book.eps

figure
[Y, lbls] = lvmLoadData('oil');
missing = rand(size(Y));
Y(find(missing>0.8)) = NaN;
X = ppcaEmbed(Y, 2);
X = X(:, 2:-1:1);
lvmTwoDPlot(X, lbls, getSymbols(3));
set(gca, 'fontname', fontName);
set(gca, 'fontsize', 20);
print -depsc ../tex/diagrams/oilMissing80Project_book.eps

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
print -depsc ../tex/diagrams/oilMissing70Project_book.eps


figure
[Y, lbls] = lvmLoadData('oil');
missing = rand(size(Y));
Y(find(missing>0.5)) = NaN;
X = ppcaEmbed(Y, 2);
X(:, 2) = -X(:, 2);
lvmTwoDPlot(X, lbls, getSymbols(3));
set(gca, 'fontname', fontName);
set(gca, 'fontsize', 20);
print -depsc ../tex/diagrams/oilMissing50Project_book.eps

figure
[Y, lbls] = lvmLoadData('oil');
X = ppcaEmbed(Y, 2);
lvmTwoDPlot(X, lbls, getSymbols(3));
set(gca, 'fontname', fontName);
set(gca, 'fontsize', 20);
print -depsc ../tex/diagrams/oilFullProject_book.eps

% One dimensional Gaussian Egg
%x1 = linspace(-3, -2, 100);
x2 = linspace(-3, -1.05, 100);
x3 = linspace(-1.05, -0.95, 100);
x4 = linspace(-.95, .95, 100);
x5 = linspace(.95, 1.05, 100);
x6 = linspace(1.05, 3, 100);
%x7 = linspace(2, 3, 100);

y1 = 1/sqrt(2*pi)*exp(-x1.*x1/2);
y2 = 1/sqrt(2*pi)*exp(-x2.*x2/2);
y3 = 1/sqrt(2*pi)*exp(-x3.*x3/2);
y4 = 1/sqrt(2*pi)*exp(-x4.*x4/2);
y5 = 1/sqrt(2*pi)*exp(-x5.*x5/2);
y6 = 1/sqrt(2*pi)*exp(-x6.*x6/2);
y7 = 1/sqrt(2*pi)*exp(-x7.*x7/2);

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
plot2svg('../tex/diagrams/gaussian_book.svg')


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
plot2svg('../tex/diagrams/gaussian2_book.svg')




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
plot2svg('../tex/diagrams/manifoldData_book.svg')

figure
surf(xMat, yMat, zeros(size(zMat)))
set(gca, 'cameraposition',  [0.5000    0.5000    9.1603])
set(gca, 'cameraupvector', [0 1 0])
shading faceted
colormap pink
axis off
plot2svg('../tex/diagrams/manifoldLatent_book.svg')


figure
x = 0:1:10;
D = 2.^x;
lim1 = .95;
lim2 = 1.05;
lim3 = 2;
lim4 = 3;

y = cumGamma(lim1*lim1, D/2, D/2);
y2 = cumGamma(lim2*lim2, D/2, D/2);
y3 = cumGamma(lim3*lim3, D/2, D/2);
y4 = cumGamma(lim4*lim4, D/2, D/2);

xp1 = [x(1) x x(end) x(1)];
p1 = [0 y 0 0]
xp2 = [x(1) x x(end:-1:1)];
p2 = [y(1) y2 y(end:-1:1)];
xp3 = [x(1) x x(end:-1:1)];
p3 = [y2(1) y4 y2(end:-1:1)];
%xp4 = [x(1) x x(end:-1:1)];
%p4 = [y3(1) y4 y3(end:-1:1)];
patch(xp1, p1, [1 1 0]);
patch(xp2, p2, [0 0.7 .5]);
patch(xp3, p3, [1 1 1]);
%patch(xp4, p4, [230 150 20]/255);
xtick = get(gca, 'xtick');
for i = 1:length(xtick)
  xtickLabel{i} =  num2str(2^xtick(i));
end
set(gca, 'xticklabel', xtickLabel);

set(gca, 'ytick', [0 0.25 0.5 0.75 1]);
a = xlabel('dimension');
set(a, 'fontname', fontName);
set(a, 'fontsize', 25);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
print -depsc ../tex/diagrams/dimensionMass_book.eps

figure 
a = randn(2);
a = a*a';
Y = gsamp([0, 0], a, 300);
a = plot(Y(:, 1), Y(:, 2), 'r.');
set(a, 'markersize', 10);
set(gca, 'fontsize', 20)
set(gca, 'fontName', fontName);
zeroAxes(gca);
print -depsc ../tex/diagrams/twoDGaussianSamples_book.eps


figure
Y = randn(100, 1000);
% normalise data to be variance 1 for each dimension.
varY = var(Y);
stdY = sqrt(varY);
Y = Y./repmat(stdY, size(Y, 1), 1);

d = triu(dist2(Y, Y));
v = d(find(d>eps));

% Normalise distances to be 1.
v = 2*v/mean(v);
gaussianVarV = var(v);

[vals, x] = hist(v, 50);
vals = vals/(sum(vals)*mean(x(2:end) - x(1:end-1) ));

bar(x, vals);
hold on
a = xlabel('squared distance');
set(a, 'fontname', fontName);
set(a, 'fontsize', 25);
x = linspace(0, 6, 100);
ha = plot(x, gammaPdf(x, size(Y, 2)/2, size(Y, 2)/4), 'k-');
set(ha, 'linewidth', 3);
set(gca, 'xlim', [0, 6]);
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
print -depsc ../tex/diagrams/gaussianDistances100_book.eps

figure
Y = randn(1000, 1000);
% normalise data to be variance 1 for each dimension.
varY = var(Y);
stdY = sqrt(varY);
Y = Y./repmat(stdY, size(Y, 1), 1);

d = triu(dist2(Y, Y));
v = d(find(d>eps));

% Normalise distances to be 1.
v = 2*v/mean(v);
gaussianVarV = var(v);

[vals, x] = hist(v, 50);
vals = vals/(sum(vals)*mean(x(2:end) - x(1:end-1) ));

bar(x, vals);
hold on
a = xlabel('squared distance');
set(a, 'fontname', fontName);
set(a, 'fontsize', 25);
x = linspace(0, 6, 100);
ha = plot(x, gammaPdf(x, size(Y, 2)/2, size(Y, 2)/4), 'k-');
set(ha, 'linewidth', 3);
set(gca, 'xlim', [0, 6]);
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
print -depsc ../tex/diagrams/gaussianDistances1000_book.eps


figure
W = randn(1000, 2);
covMat = W*W' +1e-2*eye(1000);
Y = gsamp(zeros(1, 1000), covMat, 1000);
% normalise data to be variance 1 for each dimension.
varY = var(Y);
stdY = sqrt(varY);
Y = Y./repmat(stdY, size(Y, 1), 1);

d = triu(dist2(Y, Y));
v = d(find(d>eps));

% Normalise distances to be 1.
v = 2*v/mean(v);
correlatedGaussianVarV = var(v);

[vals, x] = hist(v, 50);
vals = vals/(sum(vals)*mean(x(2:end) - x(1:end-1) ));

bar(x, vals);
hold on
a = xlabel('squared distance');
set(a, 'fontname', fontName);
set(a, 'fontsize', 25);
x = linspace(0, 6, 100);
ha = plot(x, gammaPdf(x, size(Y, 2)/2, size(Y, 2)/4), 'k-');
set(ha, 'linewidth', 3);
set(gca, 'xlim', [0, 6]);
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
print -depsc ../tex/diagrams/correlatedGaussianDistances_book.eps

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
print -depsc ../tex/diagrams/correlatedGaussianDistances2_book.eps

figure
Y = lvmLoadData('spellman');
% normalise data to be variance 1 for each dimension.
varY = var(Y);
stdY = sqrt(varY);
indToRemove = find(stdY<0.02);
Y(:, indToRemove) = [];
stdY(indToRemove) = [];
Y = Y./repmat(stdY, size(Y, 1), 1);

d = triu(dist2(Y, Y));
v = d(find(d>eps));

% Normalise distances to be 1.
v = 2*v/mean(v);
spellmanVarV = var(v);


[vals, x] = hist(v, 50);
vals = vals/(sum(vals)*mean(x(2:end) - x(1:end-1) ));

bar(x, vals);
hold on
a = xlabel('squared distance');
set(a, 'fontname', fontName);
set(a, 'fontsize', 25);
x = linspace(0, 6, 100);
ha = plot(x, gammaPdf(x, size(Y, 2)/2, size(Y, 2)/4), 'k-');
set(ha, 'linewidth', 3);
set(gca, 'xlim', [0, 6]);
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
print -depsc ../tex/diagrams/spellmanDistances_book.eps

figure
Y = lvmLoadData('stick');

% normalise data to be variance 1 for each dimension.
varY = var(Y);
stdY = sqrt(varY);
Y = Y./repmat(stdY, size(Y, 1), 1);

d = triu(dist2(Y, Y));
v = d(find(d>eps));

% Normalise distances to be 1.
v = 2*v/mean(v);
stickVarV = var(v);


[vals, x] = hist(v, 50);
vals = vals/(sum(vals)*mean(x(2:end) - x(1:end-1) ));

bar(x, vals);
hold on
a = xlabel('squared distance');
set(a, 'fontname', fontName);
set(a, 'fontsize', 25);
x = linspace(0, 6, 100);
ha = plot(x, gammaPdf(x, size(Y, 2)/2, size(Y, 2)/4), 'k-');
set(ha, 'linewidth', 3);
set(gca, 'xlim', [0, 6]);
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
print -depsc ../tex/diagrams/stickDistances_book.eps

figure
Y = lvmLoadData('oil');

% normalise data to be variance 1 for each dimension.
varY = var(Y);
stdY = sqrt(varY);
Y = Y./repmat(stdY, size(Y, 1), 1);

d = triu(dist2(Y, Y));
v = d(find(d>eps));

% Normalise distances to be 1.
v = 2*v/mean(v);
oilVarV = var(v);

[vals, x] = hist(v, 50);
vals = vals/(sum(vals)*mean(x(2:end) - x(1:end-1) ));

bar(x, vals);
hold on
a = xlabel('squared distance');
set(a, 'fontname', fontName);
set(a, 'fontsize', 25);
x = linspace(0, 6, 100);
ha = plot(x, gammaPdf(x, size(Y, 2)/2, size(Y, 2)/4), '-');
set(ha, 'linewidth', 2);
set(gca, 'xlim', [0, 6]);
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
print -depsc ../tex/diagrams/oilDistances_book.eps

figure
Y = lvmLoadData('grid_vowels');
% normalise data to be variance 1 for each dimension.
varY = var(Y);
stdY = sqrt(varY);
Y = Y./repmat(stdY, size(Y, 1), 1);

d = triu(dist2(Y, Y));
v = d(find(d>eps));

% Normalise distances to be 1.
v = 2*v/mean(v);
gridVowlesVarV = var(v);


[vals, x] = hist(v, 50);
vals = vals/(sum(vals)*mean(x(2:end) - x(1:end-1) ));

bar(x, vals*20);
hold on
a = xlabel('squared distance');
set(a, 'fontname', fontName);
set(a, 'fontsize', 25);
x = linspace(0, 6, 100);
ha = plot(x, gammaPdf(x, size(Y, 2)/2, size(Y, 2)/4), 'k-');
set(ha, 'linewidth', 3);
set(gca, 'xlim', [0, 6]);
pos = get(gcf, 'paperposition');
origpos = pos;
pos(4) = pos(4)/2;
set(gcf, 'paperposition', pos);
set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
print -depsc ../tex/diagrams/grid_vowelsDistances_book.eps


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
print -depsc ../tex/diagrams/gaussianPosteriors1sd_book.eps

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
print -depsc ../tex/diagrams/gaussianPosteriors2sd_book.eps

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
print -depsc ../tex/diagrams/gaussianPosteriors6sd_book.eps

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
print -depsc ../tex/diagrams/gaussianPosteriors8sd_book.eps
