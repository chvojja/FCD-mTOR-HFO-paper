
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

     % correct StartDn and EndDn in the table so that it matches the centering:
     add2StartEndToCenterDn=-sec2dn(offsetI/fs);
     Tied.StartDn(i)=Tied.StartDn(i)+add2StartEndToCenterDn;
     Tied.EndDn(i)=Tied.EndDn(i)+add2StartEndToCenterDn;
     
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

