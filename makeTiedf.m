function Tiedf = makeTiedf(Tied, Tiedfo, Tiedd)
%MAKETIEDF Summary of this function goes here
%   Detailed explanation goes here

% Filter by IED type 
IEDlabelName = 'dontmiss5000Hz' ; 
IEDlabelName = 'strict5000Hz' ; 
Tiedf = Tiedf( Tiedf.LabelName == IEDlabelName , : ); % get rid of different type of label


%Tiedhfo = load(a.pwd('Tiedhfo_strict.mat')); 
Tiedhfo = Tiedhfo_strict;

Tiedhfo = leftjoinsorted(Tied,Tiedhfo,'LeftKeys',{'ID'},'RightKeys',{'ID'});
Tiedf = leftjoinsorted(Tiedhfo,Tiedd,'LeftKeys',{'ID'},'RightKeys',{'ID'},'RightVariables',{'Signal'});
clear Tiedd;
Tiedf = leftjoinsorted(Tiedf,Tsub,'LeftKeys',{'Subject'},'RightKeys',{'Subject'},'RightVariables',{'Role'});


% Add lesion sizes
ImportOptions_ = detectImportOptions('lesions.xlsx'); % , 'NumHeaderLines', 1
Tlesions = readtable('lesions.xlsx',ImportOptions_);

Tstacked = rows2vars(Tlesions(:,[4:8]));

Tsublesions = [];
for i = 1: size(Tlesions,1)
    TnewSubj = [ repmat( Tlesions(i,'Number'), size(Tstacked,1),1  )  ,   Tstacked(:,[1 i+1]) ];
    TnewSubj = renamevars(TnewSubj,"OriginalVariableNames",'ChName');
    TnewSubj.Properties.VariableNames{3} = 'InLesion';
    Tsublesions = [Tsublesions; TnewSubj];
end

save7fp = a.pwd('Tsublesions'); save7;



end

