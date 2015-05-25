function model = dimredPlotMog(numComponents, numPoints)

% DIMREDPLOTMOG Plot a mixture of Gaussians plus data.
% FORMAT 
% DESC plots a mixture of Gaussians plus data sampled from it.
% ARG numComponents: number of components in the mixture.
% ARG numData : the number of data to sample.
% RETURN model : the model that was created.
%
% COPYRIGHT : Neil D. Lawrence, 2008
%
% SEEALSO : icmlFigures
  
% DIMRED
  
% Sample some data from a mixture of Gaussians.

options = mogOptions(numComponents);
model = mogCreate(1, 2, randn(numComponents*3, 2), options);

for i = 1:model.m
  model.W{i} = randn(size(model.W{i}))*0.1;
  model.sigma2(i) = rand(1)*0.01;
  model.U{i} = sqrt(model.sigma2(i))*eye(model.d);
  for j = 1:model.q
    model.U{i} = cholupdate(model.U{i}, model.W{i}(:, j));
  end
end

model.Y = mogSample(model, numPoints);
mogTwoDPlot(model);

