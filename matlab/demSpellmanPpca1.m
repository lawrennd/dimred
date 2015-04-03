% DEMSPELLMANPPCA1 Model the Spellman data using Probabilistic PCA

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'spellman';
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
modelWriteResult(model, dataSetName, experimentNo);

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, dataSetName, experimentNo);
end

% Load the results and display dynamically.
%lvmResultsDynamic('ppca', dataSetName, experimentNo, 'vector')

