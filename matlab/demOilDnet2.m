% DEMOILDNET2 Oil data using GTM with 20x20 grid.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'oil';
experimentNo = 2;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
options = dnetOptions('rbf', [20 20]);
options.optimiser = 'scg';
latentDim = 2;
d = size(Y, 2);

model = dnetCreate(latentDim, d, Y, options);

% Optimise the model.
iters = 1000;
display = 1;

model = dnetOptimise(model, display, iters);

% Save the results.
capName = dataSetName;;
capName(1) = upper(capName(1));
modelType = model.type;
modelType(1) = upper(modelType(1));
save(['dem' capName modelType num2str(experimentNo) '.mat'], 'model');

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, capName, experimentNo);
end


% Load the results and display dynamically.
lvmResultsDynamic(model.type, dataSetName, experimentNo, 'vector')

% compute the nearest neighbours errors in latent space.
errors = lvmNearestNeighbour(model, lbls);
