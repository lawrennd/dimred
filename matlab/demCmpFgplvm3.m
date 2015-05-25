% DEMCMPFGPLVM3 Grid data MFCCs using FGPLVM.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'cmp';
experimentNo = 3;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
options = fgplvmOptions('ftc');
options.computeS = true;
options.optimiser = 'scg';
options.scaleVal = sqrt(mean(var(Y)));
options.kern ={'lin', 'rbf', 'bias', 'white'};
latentDim = 3;
d = size(Y, 2);

model = fgplvmCreate(latentDim, d, Y, options);
% Linear component uses first dimension.
model.kern.comp{1}.index = [1];
% RBF Components use next two dimensions.
model.kern.comp{2}.index = [2 3];


% Optimise the model.
iters = 3000;
display = 1;

model = fgplvmOptimise(model, display, iters);
% Save the results.
modelWriteResult(model, dataSetName, experimentNo);

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, dataSetName, experimentNo);
end


% Load the results and display dynamically.
lvmResultsClick(model.type, dataSetName, experimentNo, 'synth', 'cmp')

% compute the nearest neighbours errors in latent space.
errors = lvmNearestNeighbour(model, lbls{1});
