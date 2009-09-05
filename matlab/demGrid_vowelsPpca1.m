% DEMGRID_VOWELSPPCA1 Model the grid vowels man using Probabilistic PCA

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'grid_vowels';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
options = ppcaOptions;
latentDim = 2;

d = size(Y, 2);
model = ppcaCreate(latentDim, d, Y, options);

% % Optimise the model.
% iters = 1000;
% display = 3;

% model = ppcaOptimise(model, display, iters);

% Save the results.
capName = dataSetName;;
capName(1) = upper(capName(1));
save(['dem' capName 'Ppca' num2str(experimentNo) '.mat'], 'model');

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, capName, experimentNo);
end

% Load the results and display dynamically.
lvmResultsDynamic('ppca', dataSetName, experimentNo, 'vector')

