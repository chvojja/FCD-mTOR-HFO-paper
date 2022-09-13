
%load(a.pwd('VKJeeg.mat')); % this is needed, otherwise you load fress VKJeeg from cohort object

%%

Tied = [];
% Go through lbl files
[r,c] = size(VKJlbl);
for i =1:r
     [TiedOneFile, fileInfo] = VKJ_lblFile2table(  FilePath = char(VKJlbl.FilePath(i) )     );  %, e
     % add VKJlbl ID - keep track of source label files
     TiedOneFile.VKJlbl_ID(:) = VKJlbl.ID(i);

     %Tied = tableAppend(Source = TiedOneFile, Target = Tied);
     Tied = [Tied; TiedOneFile];

     % Add fileInfo information

     a.verboser.sprintf2('ProgressPerc',round(100*i/r),'constructing table of IEDs');
end
% add main ID
Tied.ID(:) = [1:size(Tied,1)]';

% Polish the table
Tied = leftjoinsorted(Tied,VKJlbl,'LeftKeys',{'VKJlbl_ID'},'RightKeys',{'ID'},'RightVariables',{'VKJeeg_ID','SubFold1'});
Tied = renamevars(Tied,{'SubFold1'},{'LabelFolder'});
VKJeeg = renamevars(VKJeeg,{'SubFold1'},{'Fs'});
%Tied = removevars(Tied,{'FileName','FilePath'});
Tied = leftjoinsorted(Tied,VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'},'RightVariables',{'FilePath','Fs'});
Tied = renamevars(Tied,{'FilePath'},{'EEGFilePath'});



%%
signalEnlargeEachSide_sec = 0.5;
Tiedd =Tied(:,'ID');
%Nsignal = 2*signalEnlargeEachSide_sec*fs;
%Tiedd.Signal(:) = {double(zeros(  1, Nsignal  ))};

%oneSubjectSignalProvider = signalProvider( FileTable = VKJeeg( VKJeeg.Subject == Tied.Subject(i) ,:),  Fs = 5000, LoadFun = @VKJ_eegFileLoader );
cacher = fileCacher( FilePaths = VKJeeg.FilePath, Fun = @VKJ_eegFileLoader );

[r_ied,c] = size(Tied);
for i = 1:r_ied

     %rangeDn = [Tied.StartDn(i) Tied.EndDn(i)];
     rangeDn = [Tied.StartDn(i)-sec2dn(signalEnlargeEachSide_sec)          Tied.StartDn(i)+sec2dn(signalEnlargeEachSide_sec)   ];
     %s = signalProvider.getByFsDatenum(Fs = Tied.Fs(i), RangeDn = range  ); % ChanName = );
     [s,ChanNames,fs,fileInfo] = cacher.get(  Tied.EEGFilePath(i)   );

     N = size(s,1);
     iv = sedn2ivf(rangeDn(1),rangeDn(2),fileInfo.fileStartDn,fileInfo.N,fs); % ořez v rámci fajlu

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
save(a.pwd('Tiedd.mat'),'Tiedd','-nocompression');


% TlblFiles = leftjoinsorted(VKJied,VKJlbl,'LeftKeys',{'VKJlbl_ID'},'RightKeys',{'ID'},'RightVariables',{'VKJeeg_ID'});

%  o.VKJeeg = tableAppend(Source = TfilesOneSub(oneSub_eegL, :), Target = o.VKJeeg);
