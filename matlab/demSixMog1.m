% DEMSIXMOG1 Demonstrate mixture of Gaussians sixes.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'stick';
experimentNo = 1;

% load data
options.noiseAmplitude = 0;
options.subtractMean = false;

Y = generateManifoldData('six', options);

% Set up model
options = mogOptions(4);

latentDim = 1;
d = size(Y, 2);
% Optimise the model.
iters = 1000;
display = 3;

model = mogCreate(latentDim, d, Y, options);
model = mogOptimise(model, display, iters);
ll = mogLogLikelihood(model);

mogTwoDPlot(model, 'connect');
