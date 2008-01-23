function e = demCmdsSixes(q)

% DEMCMDSSIXES Do classical scaling on the six data.
% FORMAT
% DESC provides a color image of the distance matrix associated with the
% rotated six data. 
%
% DESC provides color images of the distance matrix associated with the
% rotated six data when selecting dimensions to retain through their
% variance.
% ARG q : dimension of latent space to use (i.e. number of retained
% directions).
% RETURN e : the residual (unaccounted for) variance in the data to give
% the classical MDS error.
% 
% COPYRIGHT : Neil D. Lawrence, 2008
% 

% DIMRED
  
options.noiseAmplitude = 0;
options.subtractMean = false;
Y = generateManifoldData('six', options);

if nargin < 1
  q = size(Y, 2);
end

varY = var(Y);
[varY, order] = sort(varY, 2, 'descend');
order = order(1:q);
distMat = sqrt(dist2(Y(:, order), Y(:, order)));
e = 2*size(Y, 1)*sum(varY(q+1:end));
imagesc(distMat)
axis equal
set(gca, 'xlim', [0 360]);
set(gca, 'ylim', [0 360]);
set(gca, 'xtick', [0 90 180 270 360])
set(gca, 'ytick', [0 90 180 270 360])
set(gca, 'Xaxislocation', 'top')
fname = dimredPrepPlot(gca, ['demSixDistances' num2str(q)]);
colorbar
%/~
print('-depsc', fname);
%~/

