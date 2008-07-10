% DEMSTICKNLFA1 Model the stick man using an NLFA of Honkela et al.

% ICML

% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'stick';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);
data = Y';

% Parameters for iteration
hidneurons = 50;            % The number of hidden neurons to use
searchsources = 2;          % The number of sources to look for
iters = 1000;               % The number of iterations

% Do initialization and iterate
% (This may take some time...)
[res, x] = nlfa(data, 'searchsources', searchsources, ...
		'hidneurons', hidneurons, 'iters', iters);

% The results are returned in structures res.
% The reconstructions of the data are in probdist-matrix x.
% The reconstructions can then be plotted to the same picture
% hold on;
% plot3(x.e(1,:), x.e(2,:), x.e(3,:), 'r.')



% options = fgplvmOptions('ftc');
% latentDim = 2;

% d = size(Y, 2);
% model = fgplvmCreate(latentDim, d, Y, options);

% % Optimise the model.
% iters = 1000;
% display = 1;

% model = fgplvmOptimise(model, display, iters);

% Save the results.
capName = dataSetName;
capName(1) = upper(capName(1));
save(['dem' capName 'Nlfa' num2str(experimentNo) '.mat'], 'model');

% if exist('printDiagram') & printDiagram
%   fgplvmPrintPlot(model, lbls, capName, experimentNo);
% end

% % load connectivity matrix
% [void, connect] = mocapLoadTextData('run1');
% % Load the results and display dynamically.
% fgplvmResultsDynamic(dataSetName, experimentNo, 'stick', connect)

