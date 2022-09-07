%% Prepare the final table by which we select a dataset


% inputs
% Tied, Tiedd, Tsub

% outputs
% Tiedf - filtered by labelName


Tiedf = leftjoinsorted(Tied,Tiedd,'LeftKeys',{'ID'},'RightKeys',{'ID'},'RightVariables',{'Signal'});
clear Tiedd;
Tiedf = leftjoinsorted(Tiedf,Tsub,'LeftKeys',{'Subject'},'RightKeys',{'Subject'},'RightVariables',{'Role'});


% Filter by labelname
labelname = 'IED_dontmiss5000Hz' ; 
labelname = 'IED_strict5000Hz' ; 
Tiedf = Tiedf( Tiedf.LabelName == labelname , : ); % get rid of different type of label
