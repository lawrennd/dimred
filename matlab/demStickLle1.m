% DEMSTICKLLE1 Model the stick man with LLE using 7 neighbors.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'stick';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
latentDim = 2;
options = lleOptions;

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


