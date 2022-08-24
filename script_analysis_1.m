%% Load parts of analysis
%c = load2(flp('cohort.mat'));
b=1;
B = rowfun(@(x)testRow(x,b),c.Tsub(:,{'Subject','Number'}), 'OutputVariableNames',{'simulatedMean' 'trueMean' 'simulatedStd' });

function varargout = testRow(varargin)
disp('sdsd')
varargout{1} = 1;
varargout{2} = 'sddsd';
varargout{3} = [1 2 3 4 5 6 7 8 9 ];

disp('sdsd')

end