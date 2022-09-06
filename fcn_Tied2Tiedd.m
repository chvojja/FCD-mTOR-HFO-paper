function Tiedd = fcn_Tied2Tiedd(Tied,VKJeeg)
%FCN_TIED2TIEDD Summary of this function goes here

fs = 5000;
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




end

