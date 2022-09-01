

% Tsubset = outerjoin(Tsubset,c.VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'Tdat_ID','FileName','FilePath'});
% Tsubset = outerjoin(Tsubset,c.Tdat,'LeftKeys',{'Tdat_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'RootDir','Folder'})


unpack_var = 'c'; unpack; clear c

%% Load IED detections and extract IEDs, FR, and R 

%                    'VKJeeg_ID','double',... % link to signal file 
Tied = tableNewEmpty('ID','uint32',...
                   'Subject','cat',...
                   'VKJlbl_ID','double',... % link to label file 
                   'LabelName','cat',... % IEDstrict, IEDeasy FR, R....
                   'Instant','double',... 
                   'StartDn','double',...
                   'ChName','cat',...
                   'PositionLesion','cat',... % inside outside lesion
                   'Signal','cell',... % raw signal predefined duration, centered
                   'Fs','double',...
                   'IEDampl','double',...
                   'IEDwidth','double',...
                   'IEDskew','double',...
                   'hasFR','double',... % has or has not
                   'hasR','double',...
                   'indsR','double',...
                   'indsFR','double',...
                   'freqR','double',...
                   'freqFR','double',...
                   'powerR','double',...
                   'powerFR','double',Nrows = 1); 
%                    'SignalR','cell',... % raw signal predefined duration, centered
%                    'SignalFR','cell',... % raw signal predefined duration, centered
%                  'SignalHP','cell',... %  filtered signal predefined duration, centered


%TlblFiles = leftjoinsorted(VKJlbl,VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'});

%rowfunt(Table=TlblFiles, Fun = @computeFeatures_row);

%Table = TlblFiles;

Tied = [];
% Go through lbl files
[r,c] = size(VKJlbl);
for i =1:r
     [TiedOneFile, fileInfo] = VKJ_lblFile2table(  FilePath = char(VKJlbl.FilePath(i) )     );  %, e
     % add VKJlbl ID - keep track of source label files
     TiedOneFile.VKJlbl_ID(:) = VKJlbl.ID(i);

     %Tied = tableAppend(Source = TiedOneFile, Target = Tied);
     Tied = [Tied; TiedOneFile];
     a.verboser.sprintf2('ProgressPerc',round(100*i/r));
end
% add main ID
Tied.ID(:) = [1:size(Tied,1)]';

% Polish the table
Tied = leftjoinsorted(Tied,VKJlbl,'LeftKeys',{'VKJlbl_ID'},'RightKeys',{'ID'},'RightVariables',{'VKJeeg_ID','SubFold1'});
Tied = renamevars(Tied,{'SubFold1'},{'LabelFolder'});
Tied = removevars(Tied,{'FileName','FilePath'});
Tied = leftjoinsorted(Tied,VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'},'RightVariables',{'FilePath','SubFold1'});
Tied = renamevars(Tied,{'SubFold1','FilePath'},{'Fs','EEGFilePath'});


%% Add fucking EEG segments 
% Go through IEDs and grab eeg signal



TiedDetails = rowfun(@getIEDdetails_rowfun_SubjectGroup,Tied,'GroupingVariable','Subject','InputVariables',{'ID','StartDn','EEGFilePath'},'OutputVariableNames',{'ID','Signal'});

disp('s')

%%
signalEnlargeEachSide_sec = 0.5;
Nsignal = 2*signalEnlargeEachSide_sec*fs;
Tiedd =Tied(:,'ID');

Tiedd.Signal(:) = {single(zeros(  1, Nsignal  ))};

%oneSubjectSignalProvider = signalProvider( FileTable = VKJeeg( VKJeeg.Subject == Tied.Subject(i) ,:),  Fs = 5000, LoadFun = @VKJ_eegFileLoader );
cacher = fileCacher( FilePaths = VKJeeg.FilePath, Fun = @VKJ_eegFileLoader );

[r_ied,c] = size(Tied);
for i = 1:r_ied
    
     %rangeDn = [Tied.StartDn(i) Tied.EndDn(i)];
     rangeDn = [Tied.StartDn(i)-sec2dn(signalEnlargeEachSide_sec)          Tied.StartDn(i)+sec2dn(signalEnlargeEachSide_sec)   ];
     %s = signalProvider.getByFsDatenum(Fs = Tied.Fs(i), RangeDn = range  ); % ChanName = );
     [s,ChanNames,fs,fileStartDn] = cacher.get(  Tied.EEGFilePath(i)   );

     N = size(s,1);
     iv = sedn2ivf(rangeDn(1),rangeDn(2),fileStartDn,N,fs); % ořez v rámci fajlu

     chanSelectL = Tied.ChName(i)== ChanNames;
     sPart= s(iv,chanSelectL);

     sPartF = filtfilt(ones(1,10),1,sPart);

     sPartDetect = -sPart;
     meanSPD = mean(sPartDetect);
     offsetDet = 0.25*Nsignal/2;
     logiL =[1:Nsignal <offsetDet |  1:Nsignal > Nsignal-offsetDet ]' ;

     sPartDetect(logiL)=meanSPD;
     [pks,locs,w,p] = findpeaks(sPartDetect,'SortStr','descend','MaxPeakWidth',300);

     offsetI = Nsignal/2-locs(1);
     sPartFinal= s(iv-offsetI,chanSelectL);

     
%      subplot(2,1,1)
%      plot(sPart)
%     subplot(2,1,2)
%       plot(sPart2)
%      pause

      Tiedd.Signal{i}=single(sPartFinal)';
     %Tied = tableAppend(Source = TiedOneFile, Target = Tied);
   
     a.verboser.sprintf2('ProgressPerc',round(100*i/r_ied));
end



% 
% 
%      %sPart2
%      subplot(2,1,1)
%      plot(sPart-medfilt1(sPart,200))
%     subplot(2,1,2)
%       plot(sPart)
%    
%        sf=filtfilt(ones(1,10),1,sPart);
% 
%        sPartF = filtfilt(ones(1,10),1,sPart);
%      pause

%%

%save7fp = 'D:\temp_FCD_analyza_1\Tied.mat'; save7


% TlblFiles = leftjoinsorted(VKJied,VKJlbl,'LeftKeys',{'VKJlbl_ID'},'RightKeys',{'ID'},'RightVariables',{'VKJeeg_ID'});

%  o.VKJeeg = tableAppend(Source = TfilesOneSub(oneSub_eegL, :), Target = o.VKJeeg);



% detectorSettings =  a.jancaSpikeSettings.IED_strict5000Hz;
% rowfun(@(x1,x2,x3,x4,y1,y2) computeFeatures_row(x1,x2,x3,x4,a.labelFolder,detectorSettings) ,Tsubset,'InputVariables',{'ID','VKJeeg_ID','FilePath','RootDir'},'NumOutputs', 0);
% 




% %% Functions
function [y1,y2] = getIEDdetails_rowfun_SubjectGroup(ID,StartDn,EEGFilePath) 
         
         
         oneSubjectSignalProvider = signalProvider( FileTable = table(StartDn,EEGFilePath,'VariableNames',{'StartDn','FilePath'}) ,  Fs = 5000, LoadFun = @VKJ_eegFileLoader );
         

         y1 = 1;
         y2 = 2;
         %signalProvider.getByFsDatenum(Fs = 5000, RangeDn = [] ) % ChanName = );

end
% function computeFeatures_row(ID_lbl,FilePath,RootDir,labelFolder,detectorSettings) 
% 
%     label = VKJ_jancaSpikeDetector_eegFile2lblStruct(FilePath = FilePath, Name = detectorSettings.VKJlabelsName , Color =detectorSettings.VKJlabelsColor, Settings = detectorSettings.settingsStr);
%     % Save a label file
%     %filePathForLabelFile = [char(RootDir) filesep char(Folder) filesep labelFolder filesep VKJ_eegFileName2lblFileName(  filePath2fileName(  char(FilePath)   )     ) ];
%     filePathForLabelFile = fullfile ( a.pwd('lbl2')  ,   VKJ_eegFileName2lblFileName(  filePath2fileName(  char(FilePath)   )     )       );
%     VKJ_updateLabelFile(FilePath = filePathForLabelFile, LabelStruct = label);
% 
%     % Put a copy of eeg to temp for examination
%     %copyfile(char(FilePath),   changePath(Old=FilePath, New =a.pwd('eeg1'))    );
%     %copyfile(char(pathForLabelFile),changePath(Old=pathForLabelFile, New =pwd2));
%    
% end
% 
% 
% function y  = subsetOfFiles_rowGroup(IDs)
% 
% Nids = numel(IDs);
% percHowMuch = 2;
% NhowMuch = ceil(Nids*percHowMuch/100);
% NhowMuch = 2;
% 
% selIdx = randperm(Nids,NhowMuch);
% npercentIDs = IDs(selIdx);
% 
% y = npercentIDs;
% 
% end