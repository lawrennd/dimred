function demStickManifold(pcs);

% DEMSTICKMANIFOLD Project the stick man linearly.
% FORMAT
% DESC plots the principal components of the artificially rotated digit
% data set and then shows each data point next to its projected position
% in turn to give a small movie.
% ARG pcs : the principal components to display as a vector (defaults to
% [2 3]).
%
% COPYRIGHT : Neil D. Lawrence, 2008
%
% SEEALSO : demDigitsManifold

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'stick';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% load connectivity matrix
[void, connect] = mocapLoadTextData([datasetsDirectory 'run1']);

[u, v] = eig(cov(Y'));
v = diag(v);

[void, order] = sort(v);
order = order(end:-1:1);
v = v(order);
u = u(:, order);
X = u*diag(sqrt(v));

X = X(:, pcs);

axesWidth = 0.2;
clf

indices = 1:size(X, 1);
plt = plot(X(indices, 1), X(indices, 2), '.-');
set(plt, 'markersize', 20)
set(gca, 'fontname', 'helvetica')
set(gca, 'fontsize', 20)
xlabel(['PC no ' num2str(pcs(1))]);
ylabel(['PC no ' num2str(pcs(2))]);
plotAxes = gca;
xPrime = normalisedPoint(X(indices(1), :), plotAxes);
stickAxes = axes;
pl = stickVisualise(Y(indices(1), :), connect);
set(stickAxes, 'position', [xPrime(1)-axesWidth/2 xPrime(2) axesWidth 2*axesWidth]);
camPos = get(stickAxes, 'CameraPosition');
camPos = (rotationMatrix(0, pi/4, 3*pi/2, 'xyz')*camPos')';
set(stickAxes, 'CameraPosition', camPos);

set(pl, 'markersize', 10);
set(pl, 'color', [1 0 0]);
axis off
colormap gray
for i = indices
  x = X(i, :);
  xPrime = normalisedPoint(x, plotAxes);
  set(stickAxes, 'position', [xPrime(1)-axesWidth/2 xPrime(2) axesWidth axesWidth])
  stickModify(pl, Y(i, :), connect);
  pause(0.2) 
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
