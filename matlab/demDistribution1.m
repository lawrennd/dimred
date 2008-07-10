% DEMDISTRIBUTION1 Demonstrate a Gaussian propagated through a non linear function.

randn('seed', 2e6);
rand('seed', 2e6);

numData = 5000;

% Create 10 hidden node MLP.
modelType = 'mlp';

options = modelOptions(modelType, 10);
model1 = modelCreate(modelType, 1, 1, options);
params = modelExtractParam(model1);
params = randn(size(params)); 
model1 = modelExpandParam(model1, params);


model2 = modelCreate(modelType, 1, 2, options);
params = modelExtractParam(model2)*0.5;
params = randn(size(params)); 
model2 = modelExpandParam(model2, params);


sigma = 0.05;



x = randn(numData, 1);
y = modelOut(model1, x);

span = max(y) - min(y);

yPlot = linspace(min(y)-0.05*span, max(y)+0.05*span, 200)';
py = sum(1/numData*1/sqrt(2*pi*sigma*sigma)*exp(-dist2(y, yPlot)/(2*sigma^2)), 1);

plot(yPlot, py)



y = modelOut(model2, x);
span = max(y) - min(y);

numGrid = 80;
yPlot1 = linspace(min(y(:, 1))-0.05*span(1), max(y(:, 1))+0.05*span(1), numGrid)';
yPlot2 = linspace(min(y(:, 2))-0.05*span(1), max(y(:, 2))+0.05*span(2), numGrid)';
[YPLOT1, YPLOT2] = meshgrid(yPlot1, yPlot2);
yPlot = [YPLOT1(:) YPLOT2(:)];

py = sum(1/numData*1/sqrt(2*pi*sigma*sigma)*exp(-dist2(y, yPlot)/(2*sigma^2)), 1);
figure
contourf(reshape(YPLOT1, numGrid, numGrid), ...
         reshape(YPLOT2, numGrid, numGrid), ...
         reshape(py, numGrid, numGrid));