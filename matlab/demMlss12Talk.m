% DEMINTERSPEECHTALK Show demos for Interspeech talk in order.

% DIMRED


colordef white


disp('Ready ... play stick man data.')
disp('[Y, connect] = mocapLoadTextData(''run1'');')
disp('handle = stickVisualise(Y(1, :), connect);')
disp('for j = 1:3')
disp('  for i = 2:size(Y, 1)')
disp('    stickModify(handle, Y(i, :), connect);')
disp('    drawnow')
disp('  end')
disp('end')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   rep = 1;
   [Y, connect] = mocapLoadTextData('run1');
%   Y = Y(1:4:end, :);
   handle = stickVisualise(Y(1, :), connect);
   while(rep)
     for j = 1:3
       for i = 2:size(Y, 1)
         stickModify(handle, Y(i, :), connect);
         pause(0.01)
       end
     end
     r2 = input('Type ''R'' to repeat or ''C'' to continue: ', 's');
     switch r2
      case {'r', 'R'}
       rep = 1;
      otherwise
       rep = 0;
     end
   end
 otherwise
end

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

disp('Ready ... Density Network on Oil.')
disp('[void, connect] = mocapLoadTextData(''run1'');')
disp('lvmResultsDynamic(''dnet'', ''oil'', 4, ''vector'')')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   % Load the results and display dynamically.
   lvmResultsDynamic('dnet', 'oil', 4, 'vector')
 otherwise
end

disp('lvmResultsDynamic(''dnet'', ''oil'', 5, ''vector'')')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   % Load the results and display dynamically.
   lvmResultsDynamic('dnet', 'oil', 5, 'vector')
 otherwise
end

disp('Ready ... GTM on stick man.')
disp('[void, connect] = mocapLoadTextData(''run1'');')
disp('lvmResultsDynamic(''dnet'', ''stick'', 3, ''stick'', connect)')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   % load connectivity matrix
   [void, connect] = mocapLoadTextData('run1');
   % Load the results and display dynamically.
   lvmResultsDynamic('dnet', 'stick', 3, 'stick', connect)
 otherwise
end


disp('Ready ... pure GP-LVM on stick man.')
disp('[void, connect] = mocapLoadTextData(''run1'');')
disp('lvmResultsDynamic(''fgplvm'', ''stick'', 1, ''stick'', connect)')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   % load connectivity matrix
   [void, connect] = mocapLoadTextData('run1');
   % Load the results and display dynamically.
   lvmResultsDynamic('fgplvm', 'stick', 1, 'stick', connect)
 otherwise
end

disp('Ready ... Autoregressive Dynamics GP-LVM on stick man.')
disp('[void, connect] = mocapLoadTextData(''run1'');')
disp('lvmResultsDynamic(''fgplvm'', ''stick'', 2, ''stick'', connect)')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   % load connectivity matrix
   [void, connect] = mocapLoadTextData('run1');
   % Load the results and display dynamically.
   lvmResultsDynamic('fgplvm', 'stick', 2, 'stick', connect)
 otherwise
end

disp('Ready ... XX GP-LVM on stick man.')
disp('[void, connect] = mocapLoadTextData(''run1'');')
disp('lvmResultsDynamic(''fgplvm'', ''stick'', 3, ''stick'', connect)')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   % load connectivity matrix
   [void, connect] = mocapLoadTextData('run1');
   % Load the results and display dynamically.
   lvmResultsDynamic('fgplvm', 'stick', 3, 'stick', connect)
 otherwise
end

disp('Ready ... XX GP-LVM on stick man.')
disp('[void, connect] = mocapLoadTextData(''run1'');')
disp('lvmResultsDynamic(''fgplvm'', ''stick'', 4, ''stick'', connect)')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   % load connectivity matrix
   [void, connect] = mocapLoadTextData('run1');
   % Load the results and display dynamically.
   lvmResultsDynamic('fgplvm', 'stick', 4, 'stick', connect)
 otherwise
end
disp('Ready ... Bayesian GP-LVM on stick man.')
disp('[void, connect] = mocapLoadTextData(''run1'');')
disp('lvmResultsDynamic(''vargplvm'', ''stick'', 1, ''stick'', connect)')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   % load connectivity matrix
   [void, connect] = mocapLoadTextData('run1');
   % Load the results and display dynamically.
   lvmResultsDynamic('vargplvm', 'stick', 1, 'stick', connect)
 otherwise
end

disp('Ready ... Projection of Grid onto eigenvectors.')
disp('demProjectVoices;')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   % Load the results and display dynamically.
   demProjectVoices
 otherwise
end


disp('Ready ... GPLVM on Grid Data.')
disp('lvmResultsClick(''fgplvm'', ''cmp'', 1, ''synth'', ''cmp'')')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   lvmResultsClick('fgplvm', 'cmp', 1, 'synth', 'cmp')
 otherwise
end
colordef black
disp('Ready ... GPLVM two length scales on Grid Data.')
disp('lvmResultsClick(''fgplvm'', ''cmp'', 2, ''synth'', ''cmp'')')
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   lvmResultsClick('fgplvm', 'cmp', 2, 'synth', 'cmp')
 otherwise
end
colordef white
disp('press any key to tidy up.')
pause
clear all
close all

return
% Load the results and display dynamically.
disp('Ready ... Bayesian GPLVM on Brendan.')
disp('[void, connect] = mocapLoadTextData(''run1'');')
disp(['lvmResultsDynamic(''vargplvm'', ''brendan'', 1, ''image'', ' ...
      '''[20 28]'', 1, 0, 1)'])
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
  case {'r', 'R'}
   close all
   clear all
   lvmResultsDynamic('vargplvm', 'brendan', 1, 'image', [20 28], 1, ...
                     0, 1)
  otherwise
end
