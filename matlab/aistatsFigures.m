
fontsize = 16;
colordef white
figure
gridsize = 10;
randn('seed', 1e7)
rand('seed', 1e7)
x = linspace(-.5, .5, gridsize);
y = linspace(-.5, .5, gridsize);
[xMat, yMat] = meshgrid(x, y);
X = [xMat(:), yMat(:)];
kern = kernCreate(X, 'rbf');
%kern.variance = 16;
%kern.decay = 0.0001;
K = kernCompute(kern, X);
z = gsamp(zeros(size(K, 1), 1), K, 3)';
%z = z + randn(size(z))*0.01;
ind = findNeighbours(X, 4);
hold on
for i = 1:gridsize*gridsize
  nn = 4;
  if i<gridsize+1
    nn = nn-1;
  end
  if i>gridsize*(gridsize-1)
    nn = nn-1;
  end
  if ~rem(i-1, gridsize)
    nn = nn-1; 
  end
  if ~rem(i, gridsize)
    nn = nn-1;
  end
  for j = 1:nn
    h = line([z(i, 1) z(ind(i, j), 1)], ...
         [z(i, 2) z(ind(i, j), 2)], ...
         [z(i, 3) z(ind(i, j), 3)]);
    set(h, 'linewidth', 2, 'color', [0 0 0]);
  end
end
axis off

set(gca, ...
    'CameraPosition', [7.48674 -0.230665 1.60925], ...
    'CameraPositionMode', 'manual', ...
    'CameraTarget', [0 0.5 0.6], ...
    'CameraTargetMode', 'auto', ...
    'CameraUpVector', [0.77909 -0.100531 -0.948464], ...
    'CameraUpVectorMode', 'manual', ...
    'CameraViewAngle', [18.7757], ...
    'CameraViewAngleMode', 'auto')
a = plot3(z(:, 1), z(:, 2), z(:, 3), 'b.');
set(a, 'markersize', 30)
	
printPlot('gridLatentNonlinear', '../tex/diagrams', '../html')


gridsize = 6;
x = linspace(-.5, .5, gridsize);
y = linspace(-.5, .5, gridsize);
[xMat, yMat] = meshgrid(x, y);
X = [xMat(:), yMat(:)];

model.N = gridsize*gridsize;
model.k = 4;
model.isNormalised = false;%true;
[model.indices, model.D2] = findNeighbours(X, model.k);
model.kappa = ones(model.N, model.k);
for i = 1:model.N
  model.kappa(i, find(model.D2(i, :)>(1.5*model.D2(i, 1)))) = 0.0;
end
model = spectralUpdateLaplacian(model);
Kinv = model.L + 1000*ones(model.N);
[model.K, U] = pdinv(full(Kinv));
model.logDetK = - logdet(Kinv, U);

D2 = diag(model.K) *ones(1, model.N) - 2*model.K + ones(model.N, 1)*diag(model.K)';
[U, V] = eigs(model.L+eye(model.N)*1e-6, 3, 'sm')
X = U(:, 1:2);
figure, imagesc(model.L), colorbar
set(gca, 'fontsize', fontsize)
printPlot('Limage', '../tex/diagrams/', '../html/'); 
figure, imagesc(model.K), colorbar
set(gca, 'fontsize', fontsize)
printPlot('Kimage', '../tex/diagrams/', '../html/'); 
figure, imagesc(D2), colorbar
set(gca, 'fontsize', fontsize)
printPlot('D2image', '../tex/diagrams/', '../html/'); 
figure
ind = model.indices;
hold on
for i = 1:gridsize*gridsize
  nn = 4;
  if i<gridsize+1
    nn = nn-1;
  end
  if i>gridsize*(gridsize-1)
    nn = nn-1;
  end
  if ~rem(i-1, gridsize)
    nn = nn-1; 
  end
  if ~rem(i, gridsize)
    nn = nn-1;
  end
  for j = 1:nn
    h = line([X(i, 1) X(ind(i, j), 1)], ...
             [X(i, 2) X(ind(i, j), 2)]);
    set(h, 'linewidth', 2, 'color', [0 0 0]);
  end
end
plot(X(:, 1),X(:, 2), 'b.', 'markersize', 30); axis equal
set(gca, 'fontsize', fontsize)
printPlot('latentPoints', '../tex/diagrams/', '../html/'); 
