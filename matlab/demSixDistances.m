function e = demSixDistances(q, rotate)

% DEMSIXDISTANCES Plot distance matrix associated with the rotated six data.
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
% DESC provides color images of the distance matrix associated with the
% rotated six data when selecting dimensions to retain through their
% variance.
% ARG q : dimension of latent space to use (i.e. number of retained
% directions).
% ARG rotate : whether to rotate the data before feature selection.
% RETURN e : the residual (unaccounted for) variance in the data to give
% the classical MDS error.
% 
% COPYRIGHT : Neil D. Lawrence, 2008
% 
% SEEALSO : prepDemManifold

% DIMRED
if nargin<2
  rotate = false;
end
options.noiseAmplitude = 0;
options.subtractMean = false;
Y = generateManifoldData('six', options);

if rotate
  [U, Lambda] = eig(cov(Y'));
  Y = U*diag(sqrt(diag(Lambda)));
end
if nargin < 1
  q = size(Y, 2);
end

varY = var(Y);
[varY, order] = sort(varY, 2, 'descend');
order = order(1:q);
distMat = sqrt(dist2(Y(:, order), Y(:, order)));
e = 2*size(Y, 1)*size(Y, 1)*sum(varY(q+1:end));
imagesc(distMat)
axis equal
set(gca, 'xlim', [0 360]);
set(gca, 'ylim', [0 360]);
set(gca, 'xtick', [0 90 180 270 360])
set(gca, 'ytick', [0 90 180 270 360])
set(gca, 'Xaxislocation', 'top')
if rotate
  fname = dimredPrepPlot(gca, ['demSixDistancesRotate' num2str(q)]);
else
  fname = dimredPrepPlot(gca, ['demSixDistances' num2str(q)]);
end
colorbar
%/~
print('-depsc', fname);
%~/
