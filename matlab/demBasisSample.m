% DEMBASISSAMPLE Do a simple demo of a basis function.


lengthScale = 1;
locationParams = [2 4 6];
numPoints = 100;
numFuncs = 3;


fontName = 'times';
randn('seed', 1e6)
rand('seed', 1e6)

minLim = min(locationParams)-2*lengthScale;
maxLim = max(locationParams)+2*lengthScale;

colors = {'r', 'g', 'b'}

figure
hold on
basisFunctions = zeros(numPoints, length(locationParams));
t = linspace(minLim, maxLim, numPoints)';
for i = 1:length(locationParams)
  tcentred = t - locationParams(i);
  basisFunctions(:, i) = exp(-tcentred.*tcentred/(2*(lengthScale^2)));
  a = plot(t, basisFunctions(:, i), colors{i});
  set(a, 'linewidth', 2);  
end
pos = get(gca, 'position');
origpos = pos;
%pos(3) = pos(3)/2;
pos(4) = pos(4)/2;
set(gca, 'position', pos);
set(gca, 'fontname', fontName);
set(gca, 'fontsize', 20);
printPlot(['demBasisSample', num2str(0)], '../tex/diagrams/', '../html/')

for i=1:numFuncs
  figure
  w = randn(length(locationParams), 1);
  f = basisFunctions*w;
  a = plot(t, f, 'k');
  pos = get(gca, 'position');
  origpos = pos;
  pos(4) = pos(4)/2;
  set(gca, 'position', pos);
  disp(w)
  set(a, 'linewidth', 2);
  set(gca, 'fontname', fontName);
  set(gca, 'fontsize', 20);
  printPlot(['demBasisSample', num2str(i)], '../tex/diagrams/', '../html/')
end

