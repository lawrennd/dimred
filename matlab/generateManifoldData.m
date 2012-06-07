function [Y, colourmap] = generateManifoldData(dataType, options)

% GENERATEMANIFOLDDATA Generates simple toy data sets for analyzing.
% FORMAT
% DESC generates simple data sets for exploring dimensional reduction
% algorithms.
% ARG dataType : the data set to generate. Can be one of 'six',
% 'sixnine', 'swissroll',
% 'swissroll_small', 'trefoil', 'plane'
% RETURN y : the generated data set.
% RETURN colourmap : colormap values for assisting in visualisation.
%
% DESC generates simple data sets for exploring dimensional reduction
% algorithms.
% ARG dataType : the data set to generate. Can be one of 'six',
% 'sixnine', 'swissroll',
% 'swissroll_small', 'trefoil', 'plane'
% ARG option : additional option structure with fields 'noiseType',
% 'noiseAmplitude', 'display'.
% RETURN y : the generated data set.
% RETURN colourmap : colormap values for assisting in visualisation.
%
% COPYRIGHT : Carl Henrik Ek, 2007
%
% COPYRIGHT : Neil D. Lawrence, 2008

% DIMRED

fullSpec = which('generateManifoldData');
ind = max(find(fullSpec == filesep));
baseDir = fullSpec(1:ind);

if nargin < 2
  options.display = false;
  options.noiseAmplitude = 0.4;
  options.numData = 1600;
  options.seed = 1e6;
  options.subtractMean = true;
end
if ~isfield(options, 'display') || isempty(options.display)
  options.display = false;
end
if ~isfield(options, 'subtractMean') || isempty(options.display)
  options.subtractMean = true;
end
if ~isfield(options, 'noiseAmplitude') || isempty(options.noiseAmplitude)
  options.noiseAmplitude = 0.4;
end
if ~isfield(options, 'numData') || isempty(options.numData)
  options.numData = 1600;
end
if ~isfield(options, 'seed') || isempty(options.seed)
  options.seed = 1e6;
end

% Make data generation repeatable.
randn('seed', options.seed);
rand('seed', options.seed);

switch dataType
 case 'swissroll'
  t = 3*(pi/2)*(1+2*rand(1,options.numData));
  Y(:,1) = t.*cos(t);
  Y(:,2) = 3*7*rand(1,options.numData);
  Y(:,3) = t.*sin(t);
  colourmap = t;
 case 'swissroll_small'
  t = 3*(pi/4)*(1+2*rand(1,options.numData));
  Y(:,1) = t.*cos(t);
  Y(:,2) = 3*7*rand(1,options.numData);
  Y(:,3) = t.*sin(t);
  colourmap = t;
 case 'trefoil'
  t = 0:2*pi/options.numData:2*pi-2*pi/options.numData;
  Y(:,1) = -10*cos(t)-2*cos(5.*t)+15*sin(2.*t);
  Y(:,2) = -15*cos(2*t)+10*sin(t)-2*sin(5*t);
  Y(:,3) = 10*cos(3*t);
  Y = Y/1.5;
  colourmap = t;
 case 'plane'
  [x y] = meshgrid(linspace(-5,5,ceil(sqrt(options.numData))),linspace(-5,5,ceil(sqrt(options.numData))));
  z = 1/2.*(x+y);
  Y(:,1) = x(:);
  Y(:,2) = y(:);
  Y(:,3) = z(:);
  colourmap = Y(:,3);
  
 case 'six'
  try 
    load([baseDir 'rotatedSixData.mat']);
  catch
    [void, errid] = lasterr;
    if isoctave || strcmp(errid, 'MATLAB:load:couldNotReadFile');
      sixImage = dimredLoadSix;
      rows = size(sixImage, 1);
      sixImage = uint8(-sixImage+255);
      sixImage = [zeros(rows, 3) sixImage zeros(rows, 4)];
      dimOne = size(sixImage);
      
      angles = 0:1:359;
      i = 0;
      Y = zeros(length(angles), prod(dimOne));
      for i = 1:length(angles);
        angle = angles(i);
        [rotImage, void] = rotate_image(angle, double(sixImage), ones(4, 2));
        dimTwo = size(rotImage);
        start = round((dimTwo - dimOne)/2);
        cropImage = rotImage(start(1)+[1:dimOne(1)], start(2)+[1:dimOne(2)]);
        Y(i, :) = cropImage(:)';
      end 
      save([baseDir 'rotatedSixData.mat'], 'Y');
    else
      error(lasterr);
    end
  end

 case 'sixnine'
  try 
    load([baseDir 'rotatedSixNineData.mat']);
  catch
    [void, errid] = lasterr;
    if isoctave || strcmp(errid, 'MATLAB:load:couldNotReadFile');
      sixAngles = [260:359 0:35];
      nineAngles = 85:215; 
      sixImage = dimredLoadSix;
      rows = size(sixImage, 1);
      sixImage = uint8(-sixImage+255);
      sixImage = [zeros(rows, 3) sixImage zeros(rows, 4)];
      dimOne = size(sixImage);
  
      angles = sort([sixAngles nineAngles]);
      i = 0;
      Y = zeros(length(angles), prod(dimOne));
      for i = 1:length(angles);
        angle = angles(i);
        [rotImage, void] = rotate_image(angle, double(sixImage), ones(4, 2));
        dimTwo = size(rotImage);
        start = round((dimTwo - dimOne)/2);
        cropImage = rotImage(start(1)+[1:dimOne(1)], start(2)+[1:dimOne(2)]);
        Y(i, :) = cropImage(:)';
      end
      save([baseDir 'rotatedSixNineData.mat'], 'Y');
    else
      error(lasterr);
    end
  end

  
 otherwise
  error('Unknown Type');
end

Y = Y + options.noiseAmplitude.*randn(size(Y));
    
% remove mean
if options.subtractMean
  Y = Y - repmat(mean(Y),size(Y,1),1);
end

if(options.display)
  colormap jet;
  handle = scatter3(Y(:,1),Y(:,2),Y(:,3),50,colourmap,'filled');
  set(handle,'MarkerEdgeColor',[0.5,0.5,0.5]);
  dimredPrepPlot(gca, [dataType 'Data']);
end
