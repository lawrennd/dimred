function demDigitsManifold(pcs, digits);

% DEMDIGITSMANIFOLD Project and rotate an artificial data set of handwritten digits. 
% FORMAT
% DESC plots the principal components of the artificially rotated digit
% data set and then shows each data point next to its projected position
% in turn to give a small movie.
% ARG pcs : the principal components to display as a vector.
% ARG digits : a string specifying whether to plot all the data or just
% the portions that could be a six or a nine. For all the data specify
% 'all' for just the six and nine specify 'sixnine';
%
% COPYRIGHT : Neil D. Lawrence, 2006
%
% SEEALSO : prepDemManifold

% DIMRED

options.noiseAmplitude = 0;
options.subtractMean = false;

Y = generateManifoldData('six', options);
Y = centeringMatrix(size(Y, 1))*Y;
[u, v] = eig(1/size(Y, 1)*Y*Y');
v = diag(v);

[void, order] = sort(v);
order = order(end:-1:1);
v = v(order);
u = u(:, order);
X = u*diag(sqrt(v));

X = X(:, pcs);
Y = uint8(-(double(Y-255)));

axesWidth = 0.05;
clf
switch digits
 case 'all'
  indices = 1:size(X, 1);
 case 'sixnine'
  indices = [260:360 1:20];
  indices = [indices 80:200];
end
  
  

plot(X(indices, 1), X(indices, 2), 'rx');
set(gca, 'fontname', 'helvetica')
set(gca, 'fontsize', 20)
xlabel(['PC no ' num2str(pcs(1))]);
ylabel(['PC no ' num2str(pcs(2))]);
plotAxes = gca;
xPrime = normalisedPoint(X(indices(1), :), plotAxes);
imageAxes = axes('position', [xPrime axesWidth axesWidth]);
im = imagesc(reshape(Y(indices(1), :), [64 64]));
axis off
axis image
colormap gray
for i = indices
  x = X(i, :);
  xPrime = normalisedPoint(x, plotAxes);
  set(imageAxes, 'position', [xPrime axesWidth axesWidth])
  set(im, 'cdata', reshape(Y(i, :), [64 64]));
  pause(0.1) 
end

function y = normalisedPoint(x, plotAxes);

% NORMALISEPOINT Helper function to normalise a point.

pos = get(plotAxes, 'position');
xLim = get(plotAxes, 'xlim');
yLim = get(plotAxes, 'ylim');
scaleX = pos(3)/(xLim(2) - xLim(1));
scaleY = pos(4)/(yLim(2) - yLim(1));
y(1) = (x(1)-xLim(1))*scaleX + pos(1);
y(2) = (x(2)-yLim(1))*scaleY + pos(2);
