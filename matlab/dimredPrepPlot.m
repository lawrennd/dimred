function [epsFileName, pngFileName] = dimredPrepPlot(ax, name)
  
% DIMREDPREPPLOT Dimensional reduction plot preparation.
% FORMAT
% DESC prepares a dimensional reduction toolbox plot by formating axes
% etc. 
% ARG ax : the axes to format.
% ARG name : a string to be used.
%
% COPYRIGHT : Neil D. Lawrence, 2008
%
% SEEALSO : generateManifoldData
  
% DIMRED

set(ax, 'fontName', 'helvetica');
set(ax, 'fontsize', 18);

epsFileName = ['../tex/diagrams/' name '.eps'];
pngFileName = ['../html/' name '.png'];
%/~
print('-depsc', epsFileName)
par = get(ax, 'parent');
origPaperPos = get(par, 'paperPosition');
paperPos = origPaperPos;
%paperPos(3:4) = paperPos(3:4)/2;
set(par, 'paperPosition', paperPos);
print('-dpng', pngFileName);
set(par, 'paperPosition', origPaperPos);
%~/
