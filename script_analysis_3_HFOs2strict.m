

Tiedhfo = Tied(:,'ID');

[rows,~] = size(Tiedhfo);
for ir =  1:rows
     
     s = subtractmed( Tiedd.Signal{ir}  );
     %[b,~] = filtersfavourite('BPripples',fs);
     %sf = filtfilt(b,1,s);

     Nsignal = length(s);
     Nfade = round(Nsignal/5);
     wb = fadeinoutwin(Nsignal,Nfade,@blackman);

     sw = s.*wb;
%%
% 
% 
%      % detect HFOs
%      % Ripples
        rmsLen=5;
        join_gap=5; %15
        minAcceptLen=25;  %6 %22
        n_std_rms=4; %2.7; 
        b_disp=0; % detector settings
        widen=1;   
        minPeaks = 9; %13
        %[b,~] = favouritefilters('bpripples',fs);
        fmax = 200;
        filteringfun = @(x,x1,x2) filtergauss(X = x, BandPass = [80 200]); 
        ds = RMSDetectorChvojkaEdit_proIED_2(s,[],fs,filteringfun,fmax,rmsLen,join_gap,minAcceptLen,n_std_rms,widen,minPeaks,b_disp);

       if ~isempty(ds.OOI)
           %imagesc(ds.figdata)
           % selct the longest detection
           lens = abs(diff(ds.OOI'));
           [~,lensI] = sort(lens,'descend');

           Tiedhfo.HasR(ir) = true;
           Tiedhfo.RpeaksInd{ir} = ds.peaksInd(lensI(1),:);
           Tiedhfo.Rfreq(ir) = ds.hfo_freqs(lensI(1));
           Tiedhfo.Rpwr(ir) = mean( ds.rms_fd( ds.OOI(1) : ds.OOI(2) ) );
       else
           Tiedhfo.HasR(ir) = false;
       end

%%
% % 
     % FastRipples
        rmsLen=3;
        join_gap=0.5; %2
        minAcceptLen=6;  %ms %4.5
        n_std_rms=6.2;  %2.8
        b_disp=0; % detector settings
        widen=1.15;
        minPeaks = 15;
        [b,~] = favouritefilters('bpfastripples',fs);
        fmax = 800;
        %filteringfun = @(x,x1,x2) filtergauss(X = x, BandPass = [300 800]); 
        filteringfun = @(x,x1,x2)filtfilt(b,1,x);
        ds = RMSDetectorChvojkaEdit_proIED_2(s,[],fs,filteringfun,fmax,rmsLen,join_gap,minAcceptLen,n_std_rms,widen,minPeaks,b_disp);

       if ~isempty(ds.OOI)
           %imagesc(ds.figdata)

           % selct the longest detection
           lens = abs(diff(ds.OOI'));
           [~,lensI] = sort(lens,'descend');

           Tiedhfo.HasFR(ir) = true;
           Tiedhfo.FRpeaksInd{ir} = ds.peaksInd(lensI(1),:);
           Tiedhfo.FRfreq(ir) = ds.hfo_freqs(lensI(1));
           Tiedhfo.FRpwr(ir) = mean( ds.rms_fd( ds.OOI(1) : ds.OOI(2) ) );

       else
           Tiedhfo.HasFR(ir) = false;
       end

%

%    

     %plot(s); hold on; plot(sw); hold off;   

%    subplot(2,1,1)
%    plot(sf)
%    subplot(2,1,2)
%    plot(s)

     %pause

     %Tiedhfo = tableAppend(Source = TiedOneFile, Target = Tiedhfo);
   
     a.verboser.sprintf2('ProgressPerc',round(100*ir/rows),'HFO detection2');
end

Tiedhfo_strict=Tiedhfo;
save7fp = a.pwd('Tiedhfo_strict.mat'); save7