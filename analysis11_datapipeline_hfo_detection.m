load(a.pwd('c.mat'));
unpack_var = 'c'; unpack; clear c FileFilter N_Trows verboser_messages

load(a.pwd('VKJeeg.mat')); 
load(a.pwd('Tied.mat'));% end;
%%
 analysis_HFOsDetection;

% save7fp = a.pwd('VKJeeg.mat'); save7
% save7fp = a.pwd('VKJ.mat'); save7

%a.error


%% Set desired analysis labels

% % if ~exist('Tied'), 
% %     
load(a.pwd('c.mat'));
unpack_var = 'c'; unpack; clear c FileFilter N_Trows verboser_messages

load(a.pwd('VKJeeg.mat')); 
load(a.pwd('Tied.mat'));% end;

%load(a.pwd('Tiedhfo_strict.mat'));% end;
%load(a.pwd('Tiedhfo_default.mat'));% end;

% Filter by IED type and HFO type
%IEDlabelName = 'dontmiss5000Hz' ; 
%IEDlabelName = 'default' ;
%hfoDetectionName = 'Tiedhfo_default';

%IEDlabelName = 'strict5000Hz' ; 
%hfoDetectionName = 'Tiedhfo_strict';


%hfoDetectionName = 'TiedhfoDefaultFreqsByStockwell';
%recomputeFreq_Tiedhfo(Tied, Tiedhfo, hfoDetectionName );  
%%
% Create Tiedf from Tied and Tiedhfo

if exist('Tiedf') % clear old
    clear Tiedf;
end
Tiedhfo = load2(a.pwd(['Tiedhfo_' plt.hfodetector_param '.mat'])); 
Tiedf = Tied;
Tiedf = Tiedf( Tiedf.LabelName == a.IEDlabelName , : ); % get rid of different type of label
%picIdentifier = ['IED_' IEDlabelName  '_HFO_' 'Tiedhfo_default' '_'];

Tiedf = leftjoinsorted(Tiedf,Tiedhfo,'LeftKeys',{'ID'},'RightKeys',{'ID'}); % 'RightVariables',{'HasR','HasFR'})
Tiedf = renamevars(Tiedf,'ID_left','ID'); Tiedf = removevars(Tiedf,"ID_right");

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
save7fp = a.pwd('Tiedf'); save7;

% Here we have Tiedf with one particular IED and HFO detection
%%

analysis7_compute_res;

%%
load(a.pwd('Tiedf.mat')); 

load(a.pwd('TsubRes.mat'));
load(a.pwd('TsubRes_inout.mat'));

load(a.pwd('Tplt_CtrlVsTreat.mat'));
load(a.pwd('Tplt_OutVsIn.mat')); 
load(a.pwd('stats.mat')); 

%%

% psdDB_L = thresholdbyslopestd(pxxwelch,50,8,1.8);
% pxxwelch(psdDB_L) = NaN;
% 
% pxxwelch(1:6) = pxxwelch(7);
% pxxwelch = fillgapsbylpc(pxxwelch,5);

%%
%
%analysis9_plots;
plot_all_figures

%%