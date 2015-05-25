function sixImage = dimredLoadSix

% DIMREDLOADSIX Loads in the six image for the DIMRED demos.
% FORMAT
% DESC Loads in a handwritten six for use in the DIMRED
% demonstrations.
% RETURN sixImage : matrix containing the pixel values for the six.
%
% COPYRIGHT : Carl Henrik Ek, 2007
%
% COPYRIGHT : Neil D. Lawrence, 2008

% DIMRED

fullSpec = which('dimredLoadSix');
ind = max(find(fullSpec == filesep));
baseDir = fullSpec(1:ind);
sixImage = double(imread([baseDir 'br1561_6.3.pgm']));
if isoctave
  sixImage = sixImage*255;
end
