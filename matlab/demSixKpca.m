function demSixKpca(q)

% DEMSIXKPCA Plot Kernel PCA associated with the rotated six data.
% FORMAT
% DESC provides a color image of the distance matrix associated with the
% rotated six data. The file prepDemManifold must be fun first to
% generate the data set.
%
% DESC provides color images of the distance matrix associated with the
% rotated six data when selecting dimensions to retain through their
% variance.
% ARG q : dimension of latent space to use (i.e. number of retained
% directions).
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

kern = kernCreate(Y, 'rbf');
kern.inverseWidth=5e-7;
K = kernCompute(kern, Y);


[U, Lambda] = eig(K);
[lambda, order] = sort(diag(Lambda), 'descend');
U = U(:, order);
X = U*diag(sqrt(lambda));

distMat = sqrt(dist2(X(:, 1:q), X(:, 1:q)));
imagesc(distMat)
axis equal
set(gca, 'xlim', [0 360]);
set(gca, 'ylim', [0 360]);
set(gca, 'xtick', [0 90 180 270 360])
set(gca, 'ytick', [0 90 180 270 360])
set(gca, 'Xaxislocation', 'top')
fname = dimredPrepPlot(gca, ['demSixKpca' num2str(q)]);
colorbar
%/~
print('-depsc', fname);
%~/

figure
imagesc(K)
axis equal
set(gca, 'xlim', [0 360]);
set(gca, 'ylim', [0 360]);
set(gca, 'xtick', [0 90 180 270 360])
set(gca, 'ytick', [0 90 180 270 360])
set(gca, 'Xaxislocation', 'top')
fname = dimredPrepPlot(gca, ['demSixKpcaCovariance']);
colorbar
%/~
print('-depsc', fname);
%~/

if q>7
  figure
  h = plot3(X(:, 5), X(:, 6), X(:, 7), 'b.')
  origPos = get(gca, 'CameraPosition');
  set(h, 'markersize', 15)
  axis equal
  grid on
  set(gca, 'xlim', [-0.2 0.2])
  set(gca, 'ylim', [-0.2 0.2])
  set(gca, 'zlim', [-0.2 0.2])
  dimredPrepPlot(gca, 'demSixKpca567-0');
  pos = origPos
  for i = 1:5
    pos = pos + randn(1, 3)*0.4;
    set(gca, 'CameraPosition', pos);
    pause(0.2)
    dimredPrepPlot(gca, ['demSixKpca567-' num2str(i)]);
  end
    
end

