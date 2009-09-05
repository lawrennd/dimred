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
capName = dataSetName;;
capName(1) = upper(capName(1));
modelType = model.type;
modelType(1) = upper(modelType(1));
save(['dem' capName modelType num2str(experimentNo) '.mat'], 'model');

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, capName, experimentNo);
else
  clf;
  lvmScatterPlot(model, lbls);
end


