% DEMSTICKISOMAP1 Model the stick man with isomap using 7 neighbors.

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
options = isomapOptions(7);

d = size(Y, 2);
model = isomapCreate(latentDim, d, Y, options);

% Optimise the model.
iters = 1000;
display = 3;

model = isomapOptimise(model, display, iters);

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


