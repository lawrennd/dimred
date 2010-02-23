% DEMCMDSROADDATA This script uses classical MDS to visualise some road distance data.

% DIMRED

% Plot axes.
minLong = -15;
maxLong = 50;
minLat = 30;
maxLat = 65;

% Load in data.
[data, names] = xlsLoadData('europeDistance.xls', 'europeDistance');
data = tril(data);
data = data + data';
[i, j] = find(isnan(data));
toRemove = [];
for k = i';
  if any(k==j)
    toRemove = [toRemove k];
  end
end
data(toRemove, :) = [];
data(:, toRemove) = [];
names(toRemove, :) = [];


[longLat, namesLong] = xlsLoadData('europeDistance.xls', 'europeLongLat');
longLat(toRemove, :) = [];
namesLong(toRemove, :) = [];

longitude = longLat(:, 2);
latitude = longLat(:, 1);

index = find (longitude >= minLong & longitude <= maxLong ...
              & latitude >= minLat & latitude <= maxLat);
longitude = longitude(index);
latitude = latitude(index);
data = data(index, index);



names = names(index, :);

% Draw map using m_map toolbox.
m_proj('mercator', 'lon', [minLong maxLong], 'lat', [minLat maxLat]);
m_coast;
m_grid;
hold on
[xProj, yProj] = m_ll2xy(longitude, latitude);

proj = [xProj yProj];

% Do scaling.
numData = size(data, 1);

% Get negative half squared distances.
A = -.5*data.*data;
rowMean = mean(A);
fullMean = mean(rowMean);

% Convert to 'similarities'
B = A - repmat(rowMean, numData, 1) - repmat(rowMean', 1, numData) + fullMean;

% Eigenvalue problem on similarities.
[U, V] = eig(B);
[void, order] = sort(diag(V));
U = U(:, order);
V = V(order, order);

v = diag(V);
N = length(v);
% Retain the largest two eigenvectors.
[void, order] = sort(v, 'descend');
retained = order(1:2);


X = U(:, retained)*diag(sqrt(v(retained)));
meanProj = mean(proj);

for i = 1:2
  proj(:, i) = proj(:, i) - meanProj(i);
  X(:, i) = X(:, i) - mean(X(:, i));
end
X = X/sqrt(var(X(:)))*sqrt(var(proj(:)));

% Do Procrustes rotation to match to ground truth
Z = proj'*X;
[U, D, V] = svd(Z);
proc = U*V';
RX = X*proc';
factor = sqrt(var(RX(:)));
RX = RX/factor;
factor = sqrt(var(proj(:)));
RX = RX*factor;

for i = 1:2
  RX(:, i) = RX(:, i) + meanProj(i);
  proj(:, i) = proj(:, i) + meanProj(i);
end

% Draw the map to display results.
figure(1)
clf
m_proj('mercator', 'lon', [minLong maxLong], 'lat', [minLat maxLat]);
m_coast;
m_grid;
hold on
RXlongLat = zeros(size(RX));
[RXlongLat(:, 1) RXlongLat(:, 2)] = m_xy2ll(RX(:, 1), RX(:, 2));
m_plot(RXlongLat(:, 1), RXlongLat(:, 2), 'rx')
hold on;
m_plot(longitude, latitude, 'ro')
citiesToDisplay = [1 3 5 6 7 8 10 11 12 13 15 16 20 21 23 24 27 ...
                   28 29 30 31 34 35 38 39 41 42 43 45 46];
for i = citiesToDisplay
  m_text(longitude(i)+0.5, latitude(i), names(i, 1), 'fontsize', 10, ...
         'fontname', 'helvetica', 'fontweight', 'bold')
end
for i = 1:N
  a = m_line([RXlongLat(i, 1) longitude(i)], [RXlongLat(i, 2) ...
                      latitude(i)]);
  set(a, 'color', [1 0 0]);
end
colormap gray
printPlot('demCmdsRoadData1', '../tex/diagrams/', '../html/')


figure(2)
clf
bar(v(order));
printPlot('demCmdsRoadData2', '../tex/diagrams/', '../html/')

figure(3)
clf
imagesc(data)
axis equal
set(gca, 'xlim', [0 48]);
set(gca, 'ylim', [0 48]);
set(gca, 'xtick', [0 12 24 36 48])
set(gca, 'ytick', [0 12 24 36 48])
set(gca, 'Xaxislocation', 'top')
colorbar
printPlot('demCmdsRoadData3', '../tex/diagrams/', '../html/')

figure(4)
clf
distReconstruct = sqrt(dist2(X, X));
imagesc(distReconstruct)
axis equal
set(gca, 'xlim', [0 48]);
set(gca, 'ylim', [0 48]);
set(gca, 'xtick', [0 12 24 36 48])
set(gca, 'ytick', [0 12 24 36 48])
set(gca, 'Xaxislocation', 'top')
colorbar
printPlot('demCmdsRoadData4', '../tex/diagrams/', '../html/')

figure(5)
clf
imagesc(B)
axis equal
set(gca, 'xlim', [0 48]);
set(gca, 'ylim', [0 48]);
set(gca, 'xtick', [0 12 24 36 48])
set(gca, 'ytick', [0 12 24 36 48])
set(gca, 'Xaxislocation', 'top')
colorbar
printPlot('demCmdsRoadData5', '../tex/diagrams/', '../html/')
