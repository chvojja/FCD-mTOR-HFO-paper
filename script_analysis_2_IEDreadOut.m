
% Tsubset = outerjoin(Tsubset,c.VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'Tdat_ID','FileName','FilePath'});
% Tsubset = outerjoin(Tsubset,c.Tdat,'LeftKeys',{'Tdat_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'RootDir','Folder'})

% load(a.pwd('c.mat'));
% % unpack_var = 'c'; unpack; clear c
% 
% %load(a.pwd('old\Tied.mat'));
% fs = 5000;
% Nsignal = 5000;
% 
% 
% 
% %% Load IED detections and extract IEDs, FR, and R 
% 
% %                    'VKJeeg_ID','double',... % link to signal file 
% % Tied = tableNewEmpty('ID','uint32',...
% %                    'Subject','cat',...
% %                    'VKJlbl_ID','double',... % link to label file 
% %                    'LabelName','cat',... % IEDstrict, IEDeasy FR, R....
% %                    'Instant','double',... 
% %                    'StartDn','double',...
% %                    'ChName','cat',...
% %                    'PositionLesion','cat',... % inside outside lesion
% %                    'Signal','cell',... % raw signal predefined duration, centered
% %                    'Fs','double',...
% %                    'IEDampl','double',...
% %                    'IEDwidth','double',...
% %                    'IEDskew','double',...
% %                    'hasFR','double',... % has or has not
% %                    'hasR','double',...
% %                    'indsR','double',...
% %                    'indsFR','double',...
% %                    'freqR','double',...
% %                    'freqFR','double',...
% %                    'powerR','double',...
% %                    'powerFR','double',Nrows = 1); 
% %                    'SignalR','cell',... % raw signal predefined duration, centered
% %                    'SignalFR','cell',... % raw signal predefined duration, centered
% %                  'SignalHP','cell',... %  filtered signal predefined duration, centered
% 
% 
% %TlblFiles = leftjoinsorted(VKJlbl,VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'});
% 
% %rowfunt(Table=TlblFiles, Fun = @computeFeatures_row);
% 
% %Table = TlblFiles;
% 
% Tied = [];
% % Go through lbl files
% [r,c] = size(VKJlbl);
% for i =1:r
%      [TiedOneFile, fileInfo] = VKJ_lblFile2table(  FilePath = char(VKJlbl.FilePath(i) )     );  %, e
%      % add VKJlbl ID - keep track of source label files
%      TiedOneFile.VKJlbl_ID(:) = VKJlbl.ID(i);
% 
%      %Tied = tableAppend(Source = TiedOneFile, Target = Tied);
%      Tied = [Tied; TiedOneFile];
% 
%      % Add fileInfo information
% 
%      a.verboser.sprintf2('ProgressPerc',round(100*i/r),'constructing table of IEDs');
% end
% % add main ID
% Tied.ID(:) = [1:size(Tied,1)]';
% 
% % Polish the table
% Tied = leftjoinsorted(Tied,VKJlbl,'LeftKeys',{'VKJlbl_ID'},'RightKeys',{'ID'},'RightVariables',{'VKJeeg_ID','SubFold1'});
% Tied = renamevars(Tied,{'SubFold1'},{'LabelFolder'});
% %Tied = removevars(Tied,{'FileName','FilePath'});
% Tied = leftjoinsorted(Tied,VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'},'RightVariables',{'FilePath','Fs'});
% Tied = renamevars(Tied,{'FilePath'},{'EEGFilePath'});

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
     sPart= s(iv,chanSelectL)';

%      sPartF = filtfilt(ones(1,10),1,sPart);
% 
%      sPartDetect = -sPart;
%      meanSPD = mean(sPartDetect);
%      offsetDet = 0.25*Nsignal/2;
%      logiL =[1:Nsignal <offsetDet |  1:Nsignal > Nsignal-offsetDet ]' ;
% 
%      sPartDetect(logiL)=meanSPD;

     Nsignal = length(sPart);
     Nfade = round(Nsignal/5);
     wb = fadeinoutwin(Nsignal,Nfade,@blackman);
     sPartDetect = -sPart.*wb;

     [pks,locs,w,p] = findpeaks(sPartDetect,'SortStr','descend','MaxPeakWidth',300);

     offsetI = Nsignal/2-locs(1);
     sPartFinal= s(iv-offsetI,chanSelectL)';

     
%      subplot(2,1,1)
%      plot(sPart)
%     subplot(2,1,2)
%       plot(sPart2)
%      pause

      Tiedd.Signal{i}=sPartFinal;
     %Tied = tableAppend(Source = TiedOneFile, Target = Tied);
   
     a.verboser.sprintf2('ProgressPerc',round(100*i/r_ied), 'extracting and aligning IED signal');
end


%%

save7fp = a.pwd('Tied.mat'); save7
%save7fp = a.pwd('Tiedd.mat'); save7
%save7fp = 'D:\temp_FCD_analyza_1\Tiedd.mat'; save7
save('D:\temp_FCD_analyza_1\Tiedd.mat','Tiedd','-nocompression');


% TlblFiles = leftjoinsorted(VKJied,VKJlbl,'LeftKeys',{'VKJlbl_ID'},'RightKeys',{'ID'},'RightVariables',{'VKJeeg_ID'});

%  o.VKJeeg = tableAppend(Source = TfilesOneSub(oneSub_eegL, :), Target = o.VKJeeg);
