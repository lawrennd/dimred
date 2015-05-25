% DEMSTICKVARGPLVM2 Run variational GPLVM with linear covariance on stick man data.

% VARGPLVM

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'stick';

experimentNo = 2;

% load data
[Y, lbls] = lvmLoadData(dataSetName);

% Set up model
options = vargplvmOptions('dtcvar');
options.kern = {'linard2', 'bias', 'white'};
options.numActive = 55;

options.optimiser = 'scg';
d = size(Y, 2);
latentDim = 10;
model = vargplvmCreate(latentDim, d, Y, options);
model = vargplvmParamInit(model, model.m, model.X);
model.vardist.covars = 0.5*ones(size(model.vardist.covars)) + 0.001*randn(size(model.vardist.covars));
model.beta=1/(0.01*var(model.m(:)));
    
% Optimise the model.
iters = 1000;
display = 1;

model = vargplvmOptimise(model, display, iters);
    
if exist('printDiagram') & printDiagram
  lvmPrintPlot(model, lbls, dataSetName, experimentNo);
end

% Save the results.
modelWriteResult(model, dataSetName, experimentNo);

% load connectivity matrix
[void, connect] = mocapLoadTextData('run1');
% Load the results and display dynamically.
lvmResultsDynamic(model.type, dataSetName, experimentNo, 'stick', connect)


