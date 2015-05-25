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
