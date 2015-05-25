function ax = dimredDimensionMass(plotName, fontName)

% DIMREDDIMENSIONMASS Plot changing proportions associated with the dimensions.
% FORMAT
% DESC plots the propotion of the density at given distances from the
% mean for an increasing number of dimensions. 
% ARG plotName : the file name for saving the plot.
% ARG fontName : the font to use for axes.
% RETURN ax : the axes handle where the plot was placed.
%
% COPYRIGHT : Neil D. Lawrence, 2008, 2009
%
% SEEALSO : printPlot
  
% DIMRED

  
x = 0:1:10;
D = 2.^x;
lim1 = .95;
lim2 = 1.05;
lim3 = 100;
%lim4 = 3;

y = cumGamma(lim1*lim1, D/2, D/2);
y2 = cumGamma(lim2*lim2, D/2, D/2);
y3 = cumGamma(lim3*lim3, D/2, D/2);
%y4 = cumGamma(lim4*lim4, D/2, D/2);

xp1 = [x(1) x x(end) x(1)];
p1 = [0 y 0 0];
xp2 = [x(1) x x(end:-1:1)];
p2 = [y(1) y2 y(end:-1:1)];
xp3 = [x(1) x x(end:-1:1)];
p3 = [y2(1) y3 y2(end:-1:1)];
%xp4 = [x(1) x x(end:-1:1)];
%p4 = [y3(1) y4 y3(end:-1:1)];
patch(xp1, p1, [1 1 0]);
patch(xp2, p2, [0 0.7 .5]);
patch(xp3, p3, [1 1 1]);
%patch(xp4, p4, [230 150 20]/255);
xtick = get(gca, 'xtick');
for i = 1:length(xtick)
  xtickLabel{i} =  num2str(2^xtick(i));
end
set(gca, 'xticklabel', xtickLabel);

set(gca, 'ytick', [0 0.25 0.5 0.75 1]);
a = xlabel('dimension');
%set(a, 'fontname', fontName);
set(a, 'fontsize', 25);
%set(gca, 'fontname', fontName)
set(gca, 'fontsize', 20)
printPlot(plotName, '../tex/diagrams/', '../html/')

ax = gca;
