% DEMCMPFGPLVM1 Grid data MFCCs using FGPLVM.

% DIMRED

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'cmpdur';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);
Y1 = lvmLoadData('cmp');
Y2 = lvmLoadData('dur');

% Set up model
options = fgplvmOptions('ftc');
options.computeS = true;
options.optimiser = 'scg';
options.scaleVal = sqrt(mean(var(Y)));
options.kern ={'lin', 'rbf', 'rbf', 'bias', 'white'};
latentDim = 4;
d = size(Y, 2);

model = fgplvmCreate(latentDim, d, Y, options);
model.X(:, [1 3:4]) = ppcaEmbed(Y1, 3);
model.X(:, 2) = ppcaEmbed(Y2, 1);
% Linear component uses first dimension.
model.kern.comp{1}.index = [1 2];
% RBF Components use next two dimensions.
model.kern.comp{2}.index = [3 4];
model.kern.comp{3}.index = [3 4];
model.kern.comp{3}.inverseWidth = 100;


% Optimise the model.
iters = 1000;
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

