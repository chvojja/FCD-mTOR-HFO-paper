
% Tsubset = outerjoin(Tsubset,c.VKJeeg,'LeftKeys',{'VKJeeg_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'Tdat_ID','FileName','FilePath'});
% Tsubset = outerjoin(Tsubset,c.Tdat,'LeftKeys',{'Tdat_ID'},'RightKeys',{'ID'},'Type','Left','RightVariables', {'RootDir','Folder'})
Fp = 20;
Fst = 60;
Ap = 1;
Ast = 30;

dbutter = designfilt('lowpassiir','PassbandFrequency',Fp,...
  'StopbandFrequency',Fst,'PassbandRipple',Ap,...
  'StopbandAttenuation',Ast,'SampleRate',fs,'DesignMethod','butter');
% Load what we have so far
Nsignal = 5000;

[rows,c] = size(Tied);
for ir = 1:rows

     
     s = subtractmed( Tiedd.Signal{ir}  );

     s = filtfilt(ones(1,10)/10,1,s);

     % For measuring IED width:
      sf = downify(s);
      sf = downify(sf);

      %sf = filtfilt(dbutter,sf);

     %[sfc,Nsignal] = cropfillmean("Signal",sf,"CropPercent",50);
     wb = blackman(Nsignal)';
     sfc = sf.*wb;

     [pks,locs,w,p] = findpeaks(-sfc,'SortStr','descend');
     IEDwidth_sec = w(1)/fs;

     % For IED amplitude just window it
     sc = s.*wb;
     [pks,locs,w,p] = findpeaks(-sc,'SortStr','descend');  
     
     IEDampl = abs(  pks(1) );

     % skew
     IEDskew = skewness(sc);
     % h = histogram(sc,'Normalization','probability');

     Tied.IEDampl_mV(ir)= IEDampl;
     Tied.IEDwidth_sec(ir)= IEDwidth_sec;
     Tied.IEDskew(ir) = IEDskew;

    % plot(s); hold on; plot(sc); hold off;   
%      subplot(2,1,1)
%      plot(sf)
%     subplot(2,1,2)
%     plot(s)

%findpeaks(-sfc)
     %pause


     %Tied = tableAppend(Source = TiedOneFile, Target = Tied);
   
     a.verboser.sprintf2('ProgressPerc',round(100*ir/rows));
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

% 
% TieddSubset = Tiedd;
% save7fp = 'D:\temp_FCD_analyza_1\TiedSubset.mat'; save7

