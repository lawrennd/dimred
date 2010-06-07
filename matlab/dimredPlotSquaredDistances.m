function [v, tv, handle] = dimredPlotSquaredDistances(Y, plotName, ax, plotWidth)

% DIMREDPLOTSQUAREDDISTANCES Helper function for plotting interpoint distances.
% FORMAT
% DESC is a helper function for plotting inter-point distances as a
% histogram alongside the theoretical curves. 
% ARG plotName : the name of the plot file.
% ARG Y : the data to plot.
% ARG plotName : the plot name.
% ARG ax : the axes to place the plot on.
% ARG plotWidth : the plot width.
% RETURN d2 : the squared distances vector.
% RETURN tv : the theoretical interpoint distances variance (if data is independent).
% RETURN handle : handle to the axes used.
%
% COPYRIGHT : Neil D. Lawrence, 2009, 2010
%
 
% DIMRED
  
  if nargin < 3
    ax = [];
    if nargin < 2
      plotName = 'none';
    end
  end

  if isempty(ax)
    ax = gca;
  end
  % normalise data to be variance 1 for each dimension.
  varY = var(Y);
  stdY = sqrt(varY);
  Y = Y./repmat(stdY, size(Y, 1), 1);

  % Computed squared distances.
  d = triu(dist2(Y, Y));
  mask = triu(ones(size(Y, 1)));
  mask(1:size(Y, 1)+1:end) = 0;

  % Extract distances from matrix
  v = d(find(mask));

  % Scale distance by dimension.
  v = v/size(Y, 2);
  tv = (size(Y, 2)/2)/(size(Y, 2)^2/16); % theoretical variance (if independent)
  
  fprintf([plotName ' empirical variance %2.4f\n'], var(v));
  fprintf([plotName ' theoretical variance %2.4e\n'], tv);

  % Work out values of bar plot.
  [vals, x] = hist(v, 20);
  vals = vals/(sum(vals)*mean(x(2:end) - x(1:end-1) ));
  if isoctave
    axes(ax);
    bar(x, vals);
  else
    bar(ax, x, vals);
  end
  hold on
  if isoctave
    a = xlabel('squared distance');
  else
    a = xlabel(ax, 'squared distance');
  end
  %  set(a, 'fontname', fontName);
  set(a, 'fontsize', 25);
  x = linspace(0, 6, 100);
  if isoctave
    ha = plot(x, gammaPdf(x, size(Y, 2)/2, size(Y, 2)/4), 'k-');
  else
    ha = plot(ax, x, gammaPdf(x, size(Y, 2)/2, size(Y, 2)/4), 'k-');
  end
  set(ha, 'linewidth', 3);
  set(ax, 'xlim', [0, 6]);

  printLatexPlot(plotName, '../../../dimred/tex/diagrams/', plotWidth);
  printLatexText(['\global\long\def\captionInfo{$\dataDim=' ...
                  num2str(size(Y, 2)) '$ (variance of ' ...
                  'squared distances is $' num2str(var(v), 3) '$ ' ...
                  'vs predicted $' num2str(tv, 3) '$)}'], [plotName ...
                  'Caption.tex'], '../../../dimred/tex/diagrams/');
  
  handle = gcf;
  
end
