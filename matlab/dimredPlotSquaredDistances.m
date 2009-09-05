function [v, handle] = dimredPlotSquaredDistances(Y, fontName, plotName, printDiagram, ax)

% DIMREDPLOTSQUAREDDISTANCES Helper function for plotting interpoint distances.
% FORMAT
% DESC is a helper function for plotting inter-point distances as a
% histogram alongside the theoretical curves. 
% ARG plotName : the name of the plot file.
% ARG Y : the data to plot.
% ARG printDiagram : whether to plot the diagram.
% ARG ax : the axes to place the plot on.
% RETURN d2 : the squared distances vector.
% RETURN handle : handle to the axes used.
%
% COPYRIGHT : Neil D. Lawrence, 2009
%
 
% DIMRED
  
  if nargin < 5 
    ax = gca;
    if nargin < 4
      printDiagram = false;
      if nargin < 3        
        plotName = 'none';
        if nargin < 2
          fontName = 'times';
        end
      end
    end
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

  fprintf([plotName ' empirical variance %2.4f\n'], var(v));
  fprintf([plotName ' theoretical variance %2.4e\n'], (size(Y, 2)/2)/(size(Y, 2)^2/16));

  % Work out values of bar plot.
  [vals, x] = hist(v, 20);
  vals = vals/(sum(vals)*mean(x(2:end) - x(1:end-1) ));

  bar(ax, x, vals);
  hold on
  a = xlabel(ax, 'squared distance');
  set(a, 'fontname', fontName);
  set(a, 'fontsize', 25);
  x = linspace(0, 6, 100);
  ha = plot(ax, x, gammaPdf(x, size(Y, 2)/2, size(Y, 2)/4), 'k-');
  set(ha, 'linewidth', 3);
  set(ax, 'xlim', [0, 6]);
  set(ax, 'fontname', fontName)
  set(ax, 'fontsize', 20)

  if printDiagram
    printPlot(plotName, '../tex/diagrams/', '../html/')
    pos = get(gcf, 'paperposition');
    origpos = pos;
    pos(4) = pos(4)/2;
    set(gcf, 'paperposition', pos);
    print -depsc ../tex/diagrams/gaussianDistances1000_book.eps
    pos(4) = pos(4)*2;
    set(gcf, 'paperposition', pos);
  end

  handle = gcf;
  
end