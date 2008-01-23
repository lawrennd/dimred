% DEMROTATIONDIST Small movie of rotation required to improve variance retention.

% COPYRIGHT : Neil D. Lawrence, 2008

% DIMRED

randn('seed', 1e6);
rand('seed', 1e6);

numData = 100;

covMat = [4.1 2; 2 1.1];


Y = gsamp(zeros(1, 2), covMat, numData);

% Feature selection.
h = plot(Y(:, 1), Y(:, 2), 'b.');
set(h, 'markersize', 20)
axis equal
set(gca, 'xlim', [-8 8]);
set(gca, 'ylim', [-4 4]);
set(gca, 'xtick', [-8 -4 0 4 8]);
set(gca, 'ytick', [-4 0 4]);
zeroaxes(gca, 0.02, 18, 'helvetica')
dimredPrepPlot(gca, 'demRotationDist1')  
pause

projLines = [];
for i = 1:numData
  projLines = [projLines line([Y(i, 1) Y(i, 1)], [0 Y(i, 2)])];
end
set(projLines, 'color', [1 0 0]);
set(projLines, 'visible', 'off');
set(projLines, 'visible', 'on')
dimredPrepPlot(gca, 'demRotationDist2')  
pause

delete(projLines)
set(h, 'ydata', zeros(numData, 1));
dimredPrepPlot(gca, 'demRotationDist3')  


% Rotation then Selection
[R, Lambda] = eig(cov(Y));

[void, vecInd] = max(diag(Lambda));
if R(1, vecInd)<0
  R(:, vecInd) = -R(:, vecInd);
end
maxTheta = acos(R(1, vecInd));
counter = 0;
for theta = linspace(0, maxTheta, 5)
  counter = counter + 1;
  R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
  Yrot = Y*R;
  clf
  h = plot(Yrot(:, 1), Yrot(:, 2), 'b.');


  set(h, 'markersize', 20)
  axis equal
  set(gca, 'xlim', [-8 8]);
  set(gca, 'ylim', [-4 4]);
  set(gca, 'xtick', [-8 -4 0 4 8]);
  set(gca, 'ytick', [-4 0 4]);
  zeroaxes(gca, 0.02, 18, 'helvetica')
  dimredPrepPlot(gca, ['demRotationDist4_' num2str(counter)])  
  pause
end

projLines = [];
for i = 1:numData
  projLines = [projLines line([Yrot(i, 1) Yrot(i, 1)], [0 Yrot(i, 2)])];
end
set(projLines, 'color', [1 0 0]);
set(projLines, 'visible', 'off');
set(projLines, 'visible', 'on')
dimredPrepPlot(gca, 'demRotationDist5')  
pause

delete(projLines)
set(h, 'ydata', zeros(size(Yrot, 1), 1));
dimredPrepPlot(gca, 'demRotationDist6')  

