dataSetName = 'stick';
experimentNo = 1;

% load data
[Y, lbls] = lvmLoadData(dataSetName);
Y = randn(2000, 2000);
d = triu(dist2(Y, Y));
d = d/size(Y, 2);
v = d(find(d>0));
hist(v, 100)

% figure
% %Y = rand(size(Y))/sqrt(1/12);
% Y = randn(size(Y));
% Y = Y.*repmat(sqrt(var(Y)), size(Y, 1), 1);
% d = triu(dist2(Y, Y));
% d = d/size(Y, 2);
% hist(d(find(d>0)), 100)
% xlim = get(gca, 'xlim')
% xlim(1) = 0;
% set(gca, 'xlim', xlim)
