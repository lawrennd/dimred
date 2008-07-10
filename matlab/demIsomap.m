% DEMISOMAP Try isomap on the toy data sets.

% COPYRIGHT : Neil D. Lawrence, 2008

% DIMRED

options.numData = 1000;
options.display = 1;

for dataType = {'plane', 'swissroll', 'trefoil'}
  [Y, colourmap] = generateManifoldData(dataType{1}, options);
  X = isomapEmbed(Y, 2); 
  figure, 
  scatter(X(:, 1), X(:, 2), 50, colourmap, 'filled') 
  capData = dataType{1};
  capData(1) = upper(capData(1));
  dimredPrepPlot(gca, ['demIsomap' capData]);
end
