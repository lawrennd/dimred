% DEMSTICKMOG1 Demonstrate mixture of Gaussians on stick man.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'stick';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
options = mogOptions(20);

latentDim = 1;
d = size(Y, 2);
% Optimise the model.
iters = 1000;
display = 3;

for i = 1:20
  model{i} = mogCreate(latentDim, d, Y, options);
  model{i} = mogOptimise(model{i}, display, iters);
  ll(i) = mogLogLikelihood(model{i});
end

[void, ind] = max(ll);

modelFinal = model{ind};

mogTwoDPlot(modelFinal, 'connect');
