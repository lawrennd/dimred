% DEMCMPPPCA1 Grid data MFCCs using PPCA.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'cmp';
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
capName = dataSetName;;
capName(1) = upper(capName(1));
modelType = model.type;
modelType(1) = upper(modelType(1));
save(['dem' capName modelType num2str(experimentNo) '.mat'], 'model');

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, capName, experimentNo);
end


% Load the results and display dynamically.
lvmResultsClick(model.type, dataSetName, experimentNo, 'synth', 'cmp')

% compute the nearest neighbours errors in latent space.
errors = lvmNearestNeighbour(model, lbls{1});

