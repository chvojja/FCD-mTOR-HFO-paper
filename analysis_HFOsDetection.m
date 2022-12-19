

Tiedhfo = Tied(:,'ID');

hfodetector_param = plt.hfodetector_param;

magnitude = gaussmagbp([40 50 200 250],5000);
filteringfun_R = @(x,x1)filterfft2(x,magnitude);

magnitude = gaussmagbp([250 300 800 900],5000);
filteringfun_FR = @(x,x1)filterfft2(x,magnitude);

%%

[r,~] = size(Tiedhfo); 
for ir = 1:r
%for ir = 183173:r
    % ir = 115  % 115
     %ir = 19;
     %ir = 100;
     %ir = 183173;

     %s = subtractmed(  readvar( Files = Tied.Signal( ir ) , ReadFun = @(x)loadbin(x, [1,5000] , 'double' ), CatDim = 1 )   );
     s =  loadfun(plt.loadSignalIED, Tied.Signal( ir )  );
     %[b,~] = filtersfavourite('BPripples',fs);
     %sf = filtfilt(b,1,s);

     Nsignal = length(s);
     Nfade = round(Nsignal/5);
     wb = fadeinoutwin(Nsignal,Nfade,@blackman);

     sw = s.*wb;
% Ripples

       switch hfodetector_param
            
            case 'default'  
                % FastRipples - default        
                n_std_rms=2.6;  %2.8
                freq_bounds = [50 200];
                rmsLen_ms=6;
                join_gap_ms=15; %2
                minAcceptLen_ms=20;  %ms %4.5
                minPeaks = 9;
                peakPromRatio = 0.25;    

            case 'strict'
        
       end

       %ds = RMSDetectorChvojkaEdit_proIED_2(s,[],fs,filteringfun,fmax,rmsLen,join_gap,minAcceptLen,n_std_rms,widen,minPeaks,b_disp);
       Nover = 20;
       b_disp = false;
       b_disp = true;
       ds = RMSdetector_staba_chvojka_simplified_v1(s,fs,filteringfun_R, n_std_rms, freq_bounds , rmsLen_ms, join_gap_ms, minAcceptLen_ms, minPeaks, peakPromRatio, Nover, b_disp);

       % vicinity filter
       intersectingIEDbyammount_Inds = any( [abs(ds.onset_offsets-2500)<500]' ); % also require the  HFO to intersect IED by 100ms 
       ds.onset_offsets(~intersectingIEDbyammount_Inds,:) = [];

       if ~isempty(ds.onset_offsets) 
           %imagesc(ds.figdata)
           % selct the longest detection
           [lens_sorted,lensInds_sorted] = sort( ds.detections_len ,'descend');
           startInd = ds.onset_offsets(lensInds_sorted(1),1);
           endInd = ds.onset_offsets(lensInds_sorted(1),2);

           Tiedhfo.HasR(ir) = true;

           peaksIndsInFrame = ds.peaksIndsC{lensInds_sorted(1)};
           peaksInd = zeros(size(s));
           peaksInd(peaksIndsInFrame) = true;

           Tiedhfo.RpeaksInd{ir} = peaksInd;
           Tiedhfo.Rfreq(ir) = ds.hfo_freqs(lensInds_sorted(1));
           Tiedhfo.Rpwr(ir) = mean( ds.rms_fd( startInd : endInd ) );  % longest detection mean power
           Tiedhfo.Rlength_ms(ir) = 1000*( lens_sorted(1) )/fs; % longest detection in ms
       else
           Tiedhfo.HasR(ir) = false;
       end



% FastRipples 
       switch hfodetector_param
            
            case 'default'  
                % FastRipples - default        
                n_std_rms=4.4;  %2.8
                freq_bounds = [250 900];
                rmsLen_ms=3;
                join_gap_ms=1.5; %2
                minAcceptLen_ms=5;  %ms %4.5
                minPeaks = 13;
                peakPromRatio = 0.25;

            case 'strict'
        
       end

        %ds = RMSDetectorChvojkaEdit_proIED_2(s,[],fs,filteringfun,fmax,rmsLen,join_gap,minAcceptLen,n_std_rms,widen,minPeaks,b_disp);
       Nover = 20;
       b_disp = false;
       b_disp = true;
       ds = RMSdetector_staba_chvojka_simplified_v1(s,fs,filteringfun_FR, n_std_rms, freq_bounds , rmsLen_ms, join_gap_ms, minAcceptLen_ms, minPeaks, peakPromRatio, Nover, b_disp);

       % vicinity filter
       intersectingIEDbyammount_Inds = any( [abs(ds.onset_offsets-2500)<500]' ); % also require the  HFO to intersect IED by 100ms 
       ds.onset_offsets(~intersectingIEDbyammount_Inds,:) = [];

       if ~isempty(ds.onset_offsets)
           %imagesc(ds.figdata)
           % selct the longest detection
           [lens_sorted,lensInds_sorted] = sort( ds.detections_len ,'descend');
           startInd = ds.onset_offsets(lensInds_sorted(1),1);
           endInd = ds.onset_offsets(lensInds_sorted(1),2);

           Tiedhfo.HasFR(ir) = true;

           peaksIndsInFrame = ds.peaksIndsC{lensInds_sorted(1)};
           peaksInd = zeros(size(s));
           peaksInd(peaksIndsInFrame) = true;

           Tiedhfo.FRpeaksInd{ir} = peaksInd;
           Tiedhfo.FRfreq(ir) = ds.hfo_freqs(lensInds_sorted(1));
           Tiedhfo.FRpwr(ir) = mean( ds.rms_fd( startInd : endInd ) );  % longest detection mean power
           Tiedhfo.FRlength_ms(ir) = 1000*( lens_sorted(1) )/fs; % longest detection in ms
       else
           Tiedhfo.HasFR(ir) = false;
       end

       
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
save7fp = a.pwd(['Tiedhfo_' hfodetector_param '.mat']); save7