% DEMSPELLMANLE1 Model the Spellman data with LE using 7 neighbors.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'spellman';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
latentDim = 2;
options = leOptions;
d = size(Y, 2);
options.weightType = 'constant';

model = leCreate(latentDim, d, Y, options);

% Optimise the model.
iters = 1000;
display = 3;

model = leOptimise(model, display, iters);

% Save the results.
modelWriteResult(model, dataSetName, experimentNo);

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, dataSetName, experimentNo);
else
  clf;
  lvmScatterPlot(model, lbls);
end


