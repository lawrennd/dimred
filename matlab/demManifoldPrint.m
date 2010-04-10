function demManifoldPrint(pcs, digits);

% DEMMANIFOLDPRINT Print the principal components of the artificial digits data set.
% FORMAT
% DESC plots the principal components of the artificially rotated digit
% data set along with uniformly selected images from the data.
% ARG pcs : the principal components to display as a vector (defaults to
% [1 2]).
% ARG digits : a string specifying whether to plot all the data or just
% the portions that could be a six or a nine. For all the data specify
% 'all' for just the six and nine specify 'sixnine';
%
% COPYRIGHT : Neil D. Lawrence, 2006
%
% SEEALSO : prepDemManifold
  
% DIMRED

if nargin < 2
  digits = 'all'
  if nargin < 1
    pcs = [1 2];
  end
end
if ~isoctave
  colordef white
end

options.noiseAmplitude = 0;
options.subtractMean = true;
Y = generateManifoldData('six', options);

[u, v] = eig(cov(Y'));
v = diag(v);

[void, order] = sort(v);
order = order(end:-1:1);
v = v(order);
u = u(:, order);
X = u;
%X = u*diag(sqrt(v));

X = X(:, pcs);

Y = uint8(-(double(Y-255)));

axesWidth = 0.05;
clf

switch digits
 case 'all'
  indices = 1:20:size(X, 1); 
  indRed = 1:size(X, 1);
  indBlue = [];
 case 'sixnine'
  indices = [260:20:360 20];
  indices = [indices 80:20:200];
  indRed = [1:20 260:360];
  indBlue = [80:200];
end
  
  

a = plot(X(indRed, 1), X(indRed, 2), 'rx');
hold on
a= [a; plot(X(indBlue, 1), X(indBlue, 2), 'bx')];
set(gca, 'xlim', [-.1 .1]);
set(gca, 'ylim', [-.1 .1]);
set(gca, 'xtick', [-.1 -.05  0 .05 .1])
set(gca, 'ytick', [-.1 -.05  0 .05 .1])
axis equal
drawnow
set(a, 'markersize', 12);
set(a, 'linewidth', 2);
if ~isoctave
  set(gca, 'fontname', 'helvetica')
end
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
  imageAxes = axes('position', [xPrime axesWidth axesWidth]);
    
  imagesc(reshape(Y(i, :), [64 64]));
  axis off 
  axis image
  %pause(0.1) 
end

paperPos = get(gcf, 'paperPosition');
%paperPos(3) = paperPos(3)*2;
%paperPos(4) = paperPos(4)*2;
set(gcf, 'paperPosition', paperPos);
printPlot(['demManifoldPrint_', digits, '_' num2str(pcs(1)) '_' num2str(pcs(2))], '../tex/diagrams/', '../html/')

function y = normalisedPoint(x, plotAxes);

% NORMALISEDPOINT Helper function for getting the normalised point.

pos = get(plotAxes, 'position');
xLim = get(plotAxes, 'xlim');
yLim = get(plotAxes, 'ylim');
scaleX = pos(3)/(xLim(2) - xLim(1));
scaleY = pos(4)/(yLim(2) - yLim(1));
y(1) = (x(1)-xLim(1))*scaleX + pos(1);
y(2) = (x(2)-yLim(1))*scaleY + pos(2);
