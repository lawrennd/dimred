% DEMOILLLE1 Model the oil data using LLE with 7 neighbors.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'oil';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);
Y = Y./repmat(sqrt(var(Y)), size(Y, 1), 1);
% Set up model
latentDim = 2;
options = lleOptions(45);
options.isWnormalised = false;

d = size(Y, 2);
model = lleCreate(latentDim, d, Y, options);

% Optimise the model.
iters = 1000;
display = 3;

model = lleOptimise(model, display, iters);

% Save the results.
modelWriteResult(model, dataSetName, experimentNo);

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, dataSetName, experimentNo);
else
  clf;
  lvmScatterPlot(model, lbls);
end

% compute the nearest neighbours errors in latent space.
errors = lvmNearestNeighbour(model, lbls);
