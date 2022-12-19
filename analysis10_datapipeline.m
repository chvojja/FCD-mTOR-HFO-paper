%%%%%%%%%%%%%%%%%%%%%%%
clear all
fs = 5000;

%% Create cohort and gather info about subjects
% full
%rmpath('testing'); addpath('full');
% testing
%rmpath('full'); addpath('testing');

rmpath('testing','full','full_strict');
%addpath('full_strict');
addpath('full');

%%
script_analysis_0_cohort;
% in order to not fetch for subjects again and again
load(a.pwd('c.mat')); unpack_var = 'c'; unpack; clear c FileFilter N_Trows verboser_messages;


% %% Clear all previous data and labels
 % rmdir( a.pwd('Tied/Signal')  ,'s'); % delete previous content of Signal
% r = size(Tdat,1);
% for i = 1:r
%     RootDir = Tdat.RootDir(i);
%     Folder = Tdat.Folder(i);
% 
%     folder_labelFiles = [char(RootDir) filesep char(Folder) filesep a.labelFolder   ];
%     if isfolder(folder_labelFiles)
%        rmdir( folder_labelFiles   ,'s');
%     end
% 
%     a.verboser.sprintf2('ProgressPerc',round(100*i/r),'clearing');
% end


%% IED detection
% OUT = VKJ lbl files
VKJeeg = outerjoin(VKJeeg,Tdat,'LeftKeys',{'Tdat_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'RootDir','Folder'});

r = size(VKJeeg,1);
for i = 1:r
    FilePath = VKJeeg.FilePath(i);
    RootDir = VKJeeg.RootDir(i);
    Folder = VKJeeg.Folder(i);

    [label,fileInfo] = VKJ_jancaSpikeDetector_eegFile2lblStruct(FilePath = FilePath, Name = a.names, Color = a.colors, Settings = a.jancaStrings );
    % Save a label file
    filePathForLabelFile = [char(RootDir) filesep char(Folder) filesep a.labelFolder filesep VKJ_eegFileName2lblFileName(  filePath2fileName(  char(FilePath)   )     ) ];
    VKJ_updateLabelFile(FilePath = filePathForLabelFile, LabelStruct = label);

    % Put a copy of eeg to temp for examination
    %copyfile(char(FilePath),   changePath(Old=FilePath, New =a.pwd('eeg1'))    );
    %copyfile(char(pathForLabelFile),changePath(Old=pathForLabelFile, New =pwd2));

    VKJeeg.End{i} = fileInfo.fileEnd;
    VKJeeg.DurationMin(i) = dn2sec(fileInfo.fileDurDn)/60;
    a.verboser.sprintf2('ProgressPerc',round(100*i/r),'IED detection');
end
VKJeeg = renamevars(VKJeeg,{'SubFold1'},{'Fs'});
VKJeeg = categorify(VKJeeg);
save7fp = a.pwd('VKJeeg.mat'); save7

%% Rescan for IED label files
script_analysis_0_cohort; 
load(a.pwd('c.mat'));
VKJlbl = c.VKJlbl;
VKJlbl = renamevars(VKJlbl,{'SubFold1'},{'LabelFolder'});
VKJeeg = load2(a.pwd('VKJeeg.mat'));
% unpack_var = 'c'; unpack; clear FileFilter N_Trows verboser_messages
% load(a.pwd('VKJeeg.mat')); % overwirtie it with previous
% OUT = VKJlbl
%% EEG extraction and Tied table
% OUT = Tied
Tied = [];
% Go through lbl files

[r,c] = size(VKJlbl);
for i =1:r
     [TiedOneFile, fileInfo] = VKJ_lblFile2table(  FilePath = char(VKJlbl.FilePath(i) )     );  %, 
     TiedOneFile = a.applyfun(What = 'labelfilter', On = TiedOneFile );

     % add VKJlbl ID - keep track of source label files
     TiedOneFile.VKJlbl_ID(:) = VKJlbl.ID(i);
     Tied = [Tied; TiedOneFile];

     a.verboser.sprintf2('ProgressPerc',round(100*i/r),'Constructing table of IEDs Tied');
end
% add main ID
Tied.ID(:) = [1:size(Tied,1)]';

% Polish the table
Tied = leftjoinsorted(Tied,VKJlbl,'LeftKeys',{'VKJlbl_ID'},'RightKeys',{'ID'},'RightVariables',{'VKJeeg_ID','LabelFolder'});
%Tied = removevars(Tied,{'FileName','FilePath'});
Tied = leftjoinsorted(Tied,VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'},'RightVariables',{'FilePath','Fs'});
Tied = renamevars(Tied,{'FilePath'},{'EEGFilePath'});

%% Save IED signal
% Out = folder Tied/Signal with .dat files
signalEnlargeEachSide_sec = 0.5;
cacher = fileCacher( FilePaths = VKJeeg.FilePath, Fun = @VKJ_eegFileLoader );


[r,c] = size(Tied);
for i = 1:r
   
     rangeDn = [Tied.StartDn(i)-sec2dn(signalEnlargeEachSide_sec)          Tied.StartDn(i)+sec2dn(signalEnlargeEachSide_sec)   ];
     [s,ChanNames,fs,fileInfo] = cacher.get(  Tied.EEGFilePath(i)   );
     N = size(s,1);
     iv = sedn2ivf(rangeDn(1),rangeDn(2),fileInfo.fileStartDn,fileInfo.N,fs); % ořez v rámci fajlu
     chanSelectL = Tied.ChName(i)== ChanNames;
     sPart= s(iv,chanSelectL)';

     Nsignal = length(sPart);
     Nfade = round(Nsignal/5);
     wb = fadeinoutwin(Nsignal,Nfade,@blackman);
     sPartDetect = -sPart.*wb;

     [pks,locs,w,p] = findpeaks(sPartDetect,'SortStr','descend','MaxPeakWidth',300);

     offsetI = Nsignal/2-locs(1);
     sPartFinal= s(iv-offsetI,chanSelectL)';
%    subplot(2,1,1)
%    plot(sPart)
%    subplot(2,1,2)
%    plot(sPart2)
%    pause
     signal_fp = [a.pwd('Tied/Signal') filesep  num2str(Tied.ID(i)) '.dat'];
     
     % Save the signal and save function handle by which to load it again
     Tied.Signal{i} = signal_fp;
     savebin( signal_fp , sPartFinal );
     
     a.verboser.sprintf2('ProgressPerc',round(100*i/r), 'extracting, aligning and saving IED signal');
end
Tied = categorify(Tied);



%% Compute Tied features
% OUT = update Tied

% Tsubset = outerjoin(Tsubset,c.VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'Tdat_ID','FileName','FilePath'});
% Tsubset = outerjoin(Tsubset,c.Tdat,'LeftKeys',{'Tdat_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'RootDir','Folder'})
% Fp = 20;
% Fst = 60;
% Ap = 1;
% Ast = 30;
% 
% dbutter = designfilt('lowpassiir','PassbandFrequency',Fp,...
%   'StopbandFrequency',Fst,'PassbandRipple',Ap,...
%   'StopbandAttenuation',Ast,'SampleRate',fs,'DesignMethod','butter');
% Load what we have so far
Nsignal = round(fs*2*signalEnlargeEachSide_sec);

[r,c] = size(Tied);
for ir = 1:r

     s =  loadfun(plt.loadSignalIED, Tied.Signal( ir )  );
     s = subtractmed( s  );

     s = filtfilt(ones(1,10)/10,1,s);

     % For measuring IED width:
      sf = downify(s);
      sf = downify(sf);

      %sf = filtfilt(dbutter,sf);

     %[sfc,Nsignal] = cropfillmean("Signal",sf,"CropPercent",50);
     wb = blackman(Nsignal)';
     sfc = sf.*wb;

     [pks,locs,w,p] = findpeaks(-sfc,'SortStr','descend');
     IEDwidth_msec = 1000*w(1)/fs;

     % For IED amplitude just window it
     sc = s.*wb;
     [pks,locs,w,p] = findpeaks(-sc,'SortStr','descend');  
     
     IEDampl = abs(  pks(1) );

     % skew
     IEDskew = skewness(sc);
     % h = histogram(sc,'Normalization','probability');

     Tied.IEDampl_mV(ir)= IEDampl;
     Tied.IEDwidth_msec(ir)= IEDwidth_msec;
     Tied.IEDskew(ir) = IEDskew;

%    plot(s); hold on; plot(sc); hold off;   
%    subplot(2,1,1)
%    plot(sf)
%    subplot(2,1,2)
%    plot(s)

%findpeaks(-sfc)
     %pause
     a.verboser.sprintf2('ProgressPerc',round(100*ir/r));
end

save7fp = a.pwd('Tied.mat'); save7

%% By this, we have at least one type of IED detections in Tied and Tiedd in a folder according to a.m object
% OUT = hfo tables
%script_analysis_3_HFOs2strict;
%script_analysis_3_HFOs2default;
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
IEDlabelName = 'dontmiss5000Hz' ; 
IEDlabelName = 'default' ;
hfoDetectionName = 'Tiedhfo_default';

%IEDlabelName = 'strict5000Hz' ; 
%hfoDetectionName = 'Tiedhfo_strict';


%hfoDetectionName = 'TiedhfoDefaultFreqsByStockwell';
%recomputeFreq_Tiedhfo(Tied, Tiedhfo, hfoDetectionName );  
%%
% Create Tiedf from Tied and Tiedhfo

if exist('Tiedf') % clear old
    clear Tiedf;
end
Tiedhfo = load2(a.pwd([hfoDetectionName '.mat'])); 
Tiedf = Tied;
Tiedf = Tiedf( Tiedf.LabelName == IEDlabelName , : ); % get rid of different type of label
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
analysis9_plots;


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

 