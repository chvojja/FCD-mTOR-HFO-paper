% 

%% Save IED signal
% Out = folder Tiedf/Signal with .dat files
signalEnlargeEachSide_sec = 0.5;
cacher = fileCacher( FilePaths = VKJeeg.FilePath, Fun = @VKJ_eegFileLoader );


[r,c] = size(Tiedf);
for i = 1:r
   
     rangeDn = [Tiedf.StartDn(i)-sec2dn(signalEnlargeEachSide_sec)          Tiedf.StartDn(i)+sec2dn(signalEnlargeEachSide_sec)   ];
     [s,ChanNames,fs,fileInfo] = cacher.get(  Tiedf.EEGFilePath(i)   );
     N = size(s,1);
     iv = sedn2ivf(rangeDn(1),rangeDn(2),fileInfo.fileStartDn,fileInfo.N,fs); % ořez v rámci fajlu
     chanSelectL = Tiedf.ChName(i)== ChanNames;
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
   %  signal_fp = [a.pwd('Tiedf/Signal') filesep  num2str(Tiedf.ID(i)) '.dat'];
     
     % Save the signal and save function handle by which to load it again
%     Tiedf.Signal{i} = signal_fp;
     %savebin( signal_fp , sPartFinal );

     
     % correct StartDn and EndDn in the table so that it matches the centering:
     add2StartEndToCenterDn=-sec2dn(offsetI/fs);
     Tiedf.StartDn(i)=Tiedf.StartDn(i)+add2StartEndToCenterDn;
     Tiedf.EndDn(i)=Tiedf.EndDn(i)+add2StartEndToCenterDn;


     a.verboser.sprintf2('ProgressPerc',round(100*i/r), 'extracting, aligning and saving IED signal');
end
% Tiedf = categorify(Tiedf);
