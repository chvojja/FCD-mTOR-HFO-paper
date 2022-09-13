
%%%%%%%%%%%%%%%%%%%%%%%

clear all


fs = 5000;



% %% Full
% 
% script_analysis_0_cohortFull;
% % in order to not fetch for subjects again and again
% load(a.pwd('c.mat'));
% unpack_var = 'c'; unpack; clear c FileFilter N_Trows verboser_messages
% 
% script_analysis_1_IEDdetectionAndCheck2;
% 
% % rescan for IED label files
% script_analysis_0_cohortFull;
% 
% load(a.pwd('c.mat'));
% unpack_var = 'c'; unpack; clear FileFilter N_Trows verboser_messages
% %load(a.pwd('VKJeeg.mat'));
% 
% %script_analysis_ApplySubset;  % Uncomment if subset not necessary
% 
% script_analysis_2_IEDreadOut2;




%% Create cohort and gather info about subjects

%addpath('testing');
%addpath('full');
%%
script_analysis_0_cohort;
% in order to not fetch for subjects again and again
load(a.pwd('c.mat'));
unpack_var = 'c'; unpack; clear c FileFilter N_Trows verboser_messages

script_analysis_1_IEDdetectionAndCheck2;

% rescan for IED label files
script_analysis_0_cohort; 

load(a.pwd('c.mat'));
unpack_var = 'c'; unpack; clear FileFilter N_Trows verboser_messages
%load(a.pwd('VKJeeg.mat'));

%script_analysis_ApplySubset;  % Uncomment if subset not necessary

script_analysis_2_IEDreadOut2;

script_analysis_2b_TiedFeatures;


%% By this, we have at least one type of IED detections in Tied and Tiedd in a folder according to a.m object
script_analysis_3_HFOs2strict;
script_analysis_3_HFOs2default;


%% Post Process

if exist('Tiedf')
    clear Tiedf;
end

% if ~exist('Tied'), 
%     
load(a.pwd('c.mat'));
unpack_var = 'c'; unpack; clear c FileFilter N_Trows verboser_messages

load(a.pwd('Tied.mat'));% end;
load(a.pwd('Tiedd.mat'));% end;
load(a.pwd('Tiedhfo_strict.mat'));% end;
load(a.pwd('Tiedhfo_default.mat'));% end;


% Filter by IED type and HFO type
IEDlabelName = 'dontmiss5000Hz' ; 
IEDlabelName = 'IED_dontmiss5000Hz' ; 
IEDlabelName = 'default' ; 
%IEDlabelName = 'strict5000Hz' ; 
%Tiedhfo = load(a.pwd('Tiedhfo_strict.mat')); 
Tiedhfo = Tiedhfo_strict;
%Tiedhfo = Tiedhfo_default;

picIdentifier = ['IED_' IEDlabelName  '_HFO_' 'Tiedhfo_default' '_']

%% set 
% 
% if exist('Tiedf')
%     clear Tiedf;
% end
% load(a.pwd('Tiedd'));

Tiedf = Tied( Tied.LabelName == IEDlabelName , : ); % get rid of different type of label

Tiedf = leftjoinsorted(Tiedf,Tiedhfo,'LeftKeys',{'ID'},'RightKeys',{'ID'}); % 'RightVariables',{'HasR','HasFR'})
Tiedf = renamevars(Tiedf,'ID_left','ID'); Tiedf = removevars(Tiedf,"ID_right");

Tiedf = leftjoinsorted(Tiedf,Tiedd,'LeftKeys',{'ID'},'RightKeys',{'ID'},'RightVariables',{'Signal'});
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

Tsublesions = categorify( leftjoinsorted(Tsublesions,Tsub,'LeftKeys',{'Number'},'RightKeys',{'Number'},'RightVariables',{'Subject'})  );
%save7fp = a.pwd('Tsublesions'); save7;

Tiedf = leftjoinsorted(Tiedf,Tsublesions,'LeftKeys',{'Subject','ChName'},'RightKeys',{'Subject','ChName'},'RightVariables',{'InLesion'});


%%
 % here we have Tiedf with one particular IED and HFO detection
script_analysis_4_ComputeResults;
script_analysis_5_NewPlots;

save(a.pwd([ picIdentifier 'Tsub.mat']),'Tsub');


%%
% save(a.pwd('cohort.mat'),'c')


% %% Load parts of analysis
% c = load2(pwd2('cohort.mat'));
% 
% B = rowfun(@testrow,c.Tsub);
% 
% function testRow(varargin)
% disp('sdsd')
% 
% 
% end

%%
% eeg_subset_5perc_L = o.VKJeeg.

%%


% clear o
% o.subjRootPathsCell{1} = 'D:\tempPremek';
% % bez bilateralu
% o.subjNamesCell{1} = {'PremekMysExtractedJoinedChanCorrect';'Naty419ExtractedJoined';'TykravoMysExtractedJoined';'Naty413ExtractedJoined';'Naty341ExtractedJoined';'Naty388ExtractedJoined'};
% o.subjNamesCell{1} = {'PremekMysExtractedJoinedChanCorrect'};
%     % which channels to use
% o.kchs=[1 2 3 4 5];
% o.verboseOn=false;
% o.fs = 5000;
% 
% % struct for saving data
% st_fpath = [o.subjRootPathsCell{1} '\st20220113.mat']; % where is the stats file loca
% o.st_fpath=st_fpath; % pass the path
% 
% % o = WKJcomputeAverageIED_miceLevelLesionvsOut(o);
% % averages.IED.TREAT = o.st.averageIED.TREAT;
% % o = WKJcomputeAverageIEDHFO_miceLevelLesionvsOut(o);
% % averages.IEDHFO.TREAT = o.st.averageIED.TREAT;
% o = WKJselectExampleHFOs(o);
% picks.IEDHFO.TREAT = o.st.averages;
% % plot
% % xlabel('Time, ms');
% % ylabel('Amplitude, mV');

 