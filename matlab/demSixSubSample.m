function demSixSubSample

% DEMSIXSUBSAMPLE Shows an image of a subsampled six.
% FORMAT
% DESC subsamples the six image and displays the result.
% 
% COPYRIGHT : Neil D. Lawrence, 2012
% 
% SEEALSO : prepDemManifold

% DIMRED
  fullSpec = which('generateManifoldData');
  ind = max(find(fullSpec == filesep));
  baseDir = fullSpec(1:ind);

  sixImage = double(imread([baseDir 'br1561_6.3.pgm']));
  if isoctave
    sixImage = sixImage*255;
  end
  rows = size(sixImage, 1);
  sixImage = uint8(sixImage);
  sixImage = [zeros(rows, 3) sixImage zeros(rows, 4)];
  dimOne = size(sixImage);
  sixImage = sixImage(1:4:end, 1:4:end);
  imagesc(sixImage);
  prepPlot(gca);
end


function prepPlot(handle)

% PREPPLOT Prepare the plot for printing.

axis image
xlim = get(handle, 'xlim');
ylim = get(handle, 'ylim');

set(handle, 'xtick', xlim(1):2:xlim(2))
set(handle, 'ytick', ylim(1):2:ylim(2))
set(handle, 'xticklabel', [])
set(handle, 'yticklabel', [])
grid on
colormap gray
