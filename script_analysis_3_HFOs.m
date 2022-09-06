% 
% 
% 
% % 
% % bpFilt = designfilt('bandpassiir','FilterOrder',4, ...
% %          'HalfPowerFrequency1',100,'HalfPowerFrequency2',1000, ...
% %          'SampleRate',fs);
% % 
% % 
% % 



% for testing
% Tied = TiedSubset;
% Tiedd = TieddSubset;


[rows,c] = size(Tied);
for ir = 1:rows
     
     s = subtractmed( Tiedd.Signal{ir}  );
     %[b,~] = filtersfavourite('BPripples',fs);
     %sf = filtfilt(b,1,s);

     Nsignal = length(s);
     Nfade = round(Nsignal/5);
     wb = fadeinoutwin(Nsignal,Nfade,@blackman);

     sw = s.*wb;

     % detect HFOs
     % Ripples
        rmsLen=5;
        join_gap=20;
        minAcceptLen=22;  %6
        n_std_rms=2.7; 
        b_disp=0; % detector settings
        widen=1;   
        minPeaks = 11;
        [b,~] = favouritefilters('bpripples',fs);
        fmax = 200;
        ds = RMSDetectorChvojkaEdit_proIED_2(s,[],fs,b,fmax,rmsLen,join_gap,minAcceptLen,n_std_rms,widen,minPeaks,b_disp);

       if ~isempty(ds.OOI)
           %imagesc(ds.figdata)
           % selct the longest detection
           lens = abs(diff(ds.OOI'));
           [~,lensI] = sort(lens,'descend');

           Tied.HasR(ir) = true;
           Tied.RpeaksInd{ir} = ds.peaksInd(lensI(1),:);
           Tied.Rfreq(ir) = ds.hfo_freqs(lensI(1));
       else
           Tied.HasR(ir) = false;
       end


     % FastRipples
        rmsLen=3;
        join_gap=4; %2
        minAcceptLen=9;  %ms %4.5
        n_std_rms=3;  %2.8
        b_disp=0; % detector settings
        widen=1;
        minPeaks = 9;
        [b,~] = favouritefilters('bpfastripples',fs);
        fmax = 900;
        ds = RMSDetectorChvojkaEdit_proIED_2(s,[],fs,b,fmax,rmsLen,join_gap,minAcceptLen,n_std_rms,widen,minPeaks,b_disp);

       if ~isempty(ds.OOI)
           %imagesc(ds.figdata)

           % selct the longest detection
           lens = abs(diff(ds.OOI'));
           [~,lensI] = sort(lens,'descend');

           Tied.HasFR(ir) = true;
           Tied.FRpeaksInd{ir} = ds.peaksInd(lensI(1),:);
           Tied.FRfreq(ir) = ds.hfo_freqs(lensI(1));

       else
           Tied.HasFR(ir) = false;
       end



%    

     %plot(s); hold on; plot(sw); hold off;   

%    subplot(2,1,1)
%    plot(sf)
%    subplot(2,1,2)
%    plot(s)

     %pause

     %Tied = tableAppend(Source = TiedOneFile, Target = Tied);
   
     a.verboser.sprintf2('ProgressPerc',round(100*ir/rows),'HFO detection');
end


save7fp = a.pwd('Tied.mat'); save7