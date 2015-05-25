% DEMSIENATALK Show demos for Siena talk in order.

% DIMRED


colordef white

disp('Ready ... rotation of digit.')
disp('demManifold')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   demManifold
 otherwise
end

demStickResults
disp('Now change directory to ''../../multigp/matlab'' and run demAistats')
