% DEMOILDNET5 Oil data using DNET with 400 points.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'oil';
experimentNo = 5;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
options = dnetOptions('mlp', 400);
options.basisStored = false;
options.optimiser = 'scg';
latentDim = 2;
d = size(Y, 2);

model = dnetCreate(latentDim, d, Y, options);

% Optimise the model.
iters = 2000;
display = 1;

model = dnetOptimise(model, display, iters);

% Save the results.
modelWriteResult(model, dataSetName, experimentNo);

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, dataSetName, experimentNo);
end


% Load the results and display dynamically.
lvmResultsDynamic(model.type, dataSetName, experimentNo, 'vector')

% compute the nearest neighbours errors in latent space.
errors = lvmNearestNeighbour(model, lbls);
