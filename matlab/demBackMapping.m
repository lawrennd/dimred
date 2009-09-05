% DEMBACKMAPPING Show difference in latent variable models that use a forward and reverse mapping.
%
% COPYRIGHT : Neil D. Lawrence, 2006, 2009

% DIMRED

lineWidth = 4;
fontSizeLabel = 24;
fontSizeText = 24;
ind = [13 84];
colordef white
x = linspace(-1.5, 1.5, 100);
y{1} = x.*x-0.5;
y{2} = -x.*x+0.5;
counter = 0;
for j = 1:length(y)
  figure(j)
  h = plot(x, y{j});
  %zeroAxes(gca)
  set(h, 'linewidth', lineWidth)
  set(gca, 'fontname', 'times')
  set(gca, 'fontsize', fontSizeLabel)
  set(gca, 'xtick', [-1 0 1]);
  grid on
  handle = xlabel('$$x$$');
  handle = [handle, ylabel(['$$y_' num2str(j) '$$'])];
  set(handle, 'Interpreter', 'latex', 'fontsize', fontSizeText);
  counter = counter + 1;
  print('-depsc', ['../tex/diagrams/demBackMapping' num2str(counter) ...
                   '.eps'])
  
  xlim = get(gca, 'xlim');
  ylim = get(gca, 'ylim');
  for i = 1:length(ind)
    h = [h line([x(ind(i)) x(ind(i))], [ylim(1) y{j}(ind(i))], 'color', ...
                [1 0 0])];
  end
  set(h, 'linewidth', lineWidth)
  counter = counter + 1;
  print('-depsc', ['../tex/diagrams/demBackMapping' num2str(counter) ...
                   '.eps'])
  
  for i = 1:length(ind)
    h = [h line([xlim(1) x(ind(i))], [y{j}(ind(i)) y{j}(ind(i))], 'color', ...
                [1 0 0])];
  end
  set(h, 'linewidth', lineWidth)
  counter = counter + 1;
  print('-depsc', ['../tex/diagrams/demBackMapping' num2str(counter) ...
                   '.eps'])
end


y{1} = linspace(-0.5, 2, 100);
y{2} = linspace(-2, 0.5, 100);
x = 0.5*y{1}.*y{1}+0.5*y{2}.*y{2}-0.5;
for j = 1:length(y)
  figure(j)
  h = plot(x, y{j});
  %zeroAxes(gca)
  set(h, 'linewidth', lineWidth)
  set(gca, 'fontname', 'times')
  set(gca, 'fontsize', fontSizeLabel)
  grid on
  handle = xlabel('$$x$$');
  handle = [handle, ylabel(['$$y_' num2str(j) '$$'])];
  set(handle, 'Interpreter', 'latex', 'fontsize', fontSizeText);
  counter = counter + 1;
  print('-depsc', ['../tex/diagrams/demBackMapping' num2str(counter) ...
                   '.eps'])
  
  xlim = get(gca, 'xlim');
  ylim = get(gca, 'ylim');
  for i = 1:length(ind)
    h = [h line([xlim(1) x(ind(i))], [y{j}(ind(i)) y{j}(ind(i))], 'color', ...
                [1 0 0])];
  end
  set(h, 'linewidth', lineWidth)
  counter = counter + 1;
  print('-depsc', ['../tex/diagrams/demBackMapping' num2str(counter) ...
                   '.eps'])
  for i = 1:length(ind)
    h = [h line([x(ind(i)) x(ind(i))], [ylim(1) y{j}(ind(i))], 'color', ...
                [1 0 0])];
  end
  set(h, 'linewidth', lineWidth)
  counter = counter + 1;
  print('-depsc', ['../tex/diagrams/demBackMapping' num2str(counter) ...
                   '.eps'])
  
end
