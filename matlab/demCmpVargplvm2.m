% DEMCMPVARGPLVM1 Grid data MFCCs using VARGPLVM.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'cmp';
experimentNo = 2;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
options = vargplvmOptions('dtcvar');
options.kern = {'rbfard2', 'linard2', 'bias', 'white'};
options.numActive = 34; 
options.optimiser = 'scg';
%options.scaleVal = sqrt(mean(var(Y)));
latentDim = 21;
d = size(Y, 2);

model = vargplvmCreate(latentDim, d, Y, options);

% Optimise the model.
iters = 3000;
display = 1;

model = vargplvmOptimise(model, display, iters);
% Save the results.
modelWriteResult(model, dataSetName, experimentNo);

if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, dataSetName, experimentNo);
end


% Load the results and display dynamically.
lvmResultsClick(model.type, dataSetName, experimentNo, 'synth', 'cmp')

% compute the nearest neighbours errors in latent space.
errors = lvmNearestNeighbour(model, lbls{1});
