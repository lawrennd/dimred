function demStickManifoldPrint(pcs, indices);

% DEMSTICKMANIFOLDPRINT Print the principal components of stick data set.
% FORMAT
% DESC plots the principal components of the stick data along with uniformly poses from the data.
% ARG pcs : the principal components to display as a vector (defaults to
% [1 2]).
% ARG indices : the indices from the motion capture data to print (defaults to
% [13:55]).
%
% COPYRIGHT : Neil D. Lawrence, 2008
%
% SEEALSO : demManifoldPrint
  
% DIMRED

  %/~
  printDiagram = 1;
  %~/
  if nargin < 2
    indices = 13:55;
    if nargin < 1
      pcs = [1 2];
    end
  end
  colordef white

  
  
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
  
  axesWidth = 0.04;
  clf
  
  
  
  
  plt = plot(X(indices, 1), X(indices, 2), 'r.-');
  hold on
  set(plt, 'markersize', 1);
  set(plt, 'linewidth', 1);
  set(gca, 'fontname', 'helvetica')
  set(gca, 'fontsize', 20)
  xlim = get(gca, 'xlim');
  ylim = get(gca, 'ylim');
  xspan = xlim(2)-xlim(1);
  yspan = ylim(2)-ylim(1);
  set(gca, 'xlim', [-xspan xspan]*.1 + xlim);
  set(gca, 'ylim', [-yspan yspan]*.1 + ylim);
  xlabel(['PC no ' num2str(pcs(1))]);
  ylabel(['PC no ' num2str(pcs(2))]);
  plotAxes = gca;
  xPrime = normalisedPoint(X(indices(1), :), plotAxes);
  
  stickAxes = axes;
  pl = stickVisualise(Y(indices(1), :), connect);
  set(stickAxes, 'position', [xPrime(1)-axesWidth/2 xPrime(2)-axesWidth axesWidth 2*axesWidth]);
  camPos = get(stickAxes, 'CameraPosition');
  camPos = (rotationMatrix(0, pi/4, 3*pi/2, 'xyz')*camPos')';
  set(stickAxes, 'CameraPosition', camPos);
  
  set(pl, 'markersize', 2);
  set(pl, 'color', [1 0 0]);
  axis off
  for i = indices
    x = X(i, :);
    xPrime = normalisedPoint(x, plotAxes);
    stickAxes = axes;
    pl = stickVisualise(Y(i, :), connect);
    set(stickAxes, 'position', [xPrime(1)-axesWidth/2 xPrime(2)-axesWidth axesWidth 2*axesWidth]);
    camPos = get(stickAxes, 'CameraPosition');
    camPos = (rotationMatrix(0, pi/4, 3*pi/2, 'xyz')*camPos')';
    set(stickAxes, 'CameraPosition', camPos);
    
    set(pl, 'markersize', 2);
    set(pl, 'color', [1 0 0]);
    axis off
    pause(0.1) 
  end
  capName = dataSetName;
  capName(1) = upper(capName(1));
  %/~
  if exist('printDiagram') && printDiagram
    fileName = ['dem' capName 'Pcs' num2str(pcs(1)) '_' num2str(pcs(2))];
    printPlot(fileName, '../tex/diagrams', '../html');
  end
  %~/
end

function y = normalisedPoint(x, plotAxes);
  
% NORMALISEDPOINT Helper function for getting the normalised point.
  
  pos = get(plotAxes, 'position');
  xLim = get(plotAxes, 'xlim');
  yLim = get(plotAxes, 'ylim');
  scaleX = pos(3)/(xLim(2) - xLim(1));
  scaleY = pos(4)/(yLim(2) - yLim(1));
  y(1) = (x(1)-xLim(1))*scaleX + pos(1);
  y(2) = (x(2)-yLim(1))*scaleY + pos(2);
end