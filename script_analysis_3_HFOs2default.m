

Tiedhfo = Tied(:,'ID');

[r,~] = size(Tiedhfo);
for ir = 1:r
     
     %s = subtractmed(  readvar( Files = Tied.Signal( ir ) , ReadFun = @(x)loadbin(x, [1,5000] , 'double' ), CatDim = 1 )   );
     s =  loadfun(plt.loadSignalIED, Tied.Signal( ir )  );
     %[b,~] = filtersfavourite('BPripples',fs);
     %sf = filtfilt(b,1,s);

     Nsignal = length(s);
     Nfade = round(Nsignal/5);
     wb = fadeinoutwin(Nsignal,Nfade,@blackman);

     sw = s.*wb;
%%


     % detect HFOs
     % Ripples
        rmsLen=5;
        join_gap=5; %15
        minAcceptLen=25;  %6 %22
        n_std_rms=2.9; %2.7; 
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
           Tiedhfo.Rlength_ms(ir) = 1000*( ds.OOI(2)-ds.OOI(1) )/fs;
       else
           Tiedhfo.HasR(ir) = false;
       end

%%
% 
     % FastRipples
        rmsLen=3;
        join_gap=0.5; %2
        minAcceptLen=6;  %ms %4.5
        n_std_rms=4.5;  %2.8
        b_disp=0; % detector settings
        widen=1.15;
        minPeaks = 13;
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
           Tiedhfo.FRlength_ms(ir) = 1000*( ds.OOI(2)-ds.OOI(1) )/fs;
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
   
     a.verboser.sprintf2('ProgressPerc',round(100*ir/r),'HFO detection1');
end

%            Tiedhfo.FRfreq(ir) = ds.hfo_freqs(lensI(1));
%            Tiedhfo.FRpwr(ir) = mean( ds.rms_fd( ds.OOI(1) : ds.OOI(2) ) );
%            Tiedhfo.FRlength_ms(ir) =

colsToStandardize = {'FRfreq','FRpwr','FRlength_ms','Rfreq','Rpwr','Rlength_ms'};
Tiedhfo(:,colsToStandardize ) = standardizeMissing(  Tiedhfo(:,colsToStandardize ) , 0) ;

Tiedhfo_default=Tiedhfo;
save7fp = a.pwd('Tiedhfo_default.mat'); save7