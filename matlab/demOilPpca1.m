% DEMOILPPCA1 Oil data using PPCA.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'oil';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
options = ppcaOptions;
options.optimiser = 'scg';
latentDim = 2;
d = size(Y, 2);

model = ppcaCreate(latentDim, d, Y, options);


% Save the results.
modelWriteResult(model, dataSetName, experimentNo);

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, dataSetName, experimentNo);
end


% Load the results and display dynamically.
lvmResultsDynamic(model.type, dataSetName, experimentNo, 'vector')

% compute the nearest neighbours errors in latent space.
errors = lvmNearestNeighbour(model, lbls);

