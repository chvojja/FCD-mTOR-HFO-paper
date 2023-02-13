

Tiedhfo = Tied(:,'ID');

hfodetector_param = plt.hfodetector_param;



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
                % Ripples - default        
                n_std_rms=2.6;  %2.8
                freq_bounds = [50 200];
                rmsLen_ms=6;
                join_gap_ms=15; %2
                minAcceptLen_ms=20;  %ms %4.5
                minPeaks = 9;
                peakPromRatio = 0.25;    

            case 'default_new_moreDetections'
%                 % Ripples - default        
%                 n_std_rms=2.5;  %2.8
%                 freq_bounds = [50 250];
%                 rmsLen_ms=5;
%                 join_gap_ms=12; %2
%                 minAcceptLen_ms=20;  %ms %4.5
%                 minPeaks = 9;
%                 peakPromRatio = 0.25;    
                % Ripples - default    

%                 n_std_rms=2.4;  %2.8  % ABC
%                 freq_bounds = [40 250];
%                 rmsLen_ms=6; %5
%                 join_gap_ms=15; %2 %15
%                 minAcceptLen_ms=18;  %ms %4.5
%                 minPeaks = 9;
%                 peakPromRatio = 0.25;   

 
                n_std_rms=2.2;  %2.8 %D
                freq_bounds = [40 250];
                rmsLen_ms=5; %5
                join_gap_ms=15; %2 %15
                minAcceptLen_ms=18;  %ms %4.5
                minPeaks = 9;
                peakPromRatio = 0.25;          
       end

       %ds = RMSDetectorChvojkaEdit_proIED_2(s,[],fs,filteringfun,fmax,rmsLen,join_gap,minAcceptLen,n_std_rms,widen,minPeaks,b_disp);
       Nover = 20;
       b_disp = false;
       %b_disp = true;
       ds = RMSdetector_staba_chvojka_simplified_v1(s,fs,plt.filteringfun_R, n_std_rms, freq_bounds , rmsLen_ms, join_gap_ms, minAcceptLen_ms, minPeaks, peakPromRatio, Nover, b_disp);


       % vicinity filter
       intersectingIEDbyammount_Inds = any( [abs(ds.onset_offsets-2500)<1000]' ); % also require the  HFO to intersect IED by 200ms 
       %ds.onset_offsets(~intersectingIEDbyammount_Inds,:) = [];

       if ~isempty(ds.onset_offsets) 
           %imagesc(ds.figdata)
           % selct the longest detection
           [lens_sorted,lensInds_sorted] = sort( ds.detections_len ,'descend');
           widest_ind =[];
           for i = 1:numel(lensInds_sorted)
               if intersectingIEDbyammount_Inds( lensInds_sorted(i) )
                  widest_ind = lensInds_sorted(i);
                  continue;
               end
           end
           if ~isempty(widest_ind)

               startInd = ds.onset_offsets(widest_ind,1);
               endInd = ds.onset_offsets(widest_ind,2);
    
               Tiedhfo.HasR(ir) = true;
    
               peaksIndsInFrame = ds.peaksIndsC{widest_ind};
               peaksInd = zeros(size(s));
               peaksInd(peaksIndsInFrame) = true;
    
               Tiedhfo.RpeaksInd{ir} = peaksInd;
               Tiedhfo.Rfreq(ir) = ds.hfo_freqs(widest_ind);
               Tiedhfo.Rpwr(ir) = mean( ds.rms_fd( startInd : endInd ) );  % longest detection mean power
               Tiedhfo.Rlength_ms(ir) = 1000*( ds.detections_len(widest_ind) )/fs; % longest detection in ms
           else
               Tiedhfo.HasR(ir) = false;
           end
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

%             case 'default_new_moreDetections' %A B C
%                 n_std_rms=4;  %2.8  53.8
%                 freq_bounds = [250 900];
%                 rmsLen_ms=3;
%                 join_gap_ms=2; %2 5 2.2
%                 minAcceptLen_ms=4.5;  %ms %4.5
%                 minPeaks = 13;
%                 peakPromRatio = 0.25;
%             case 'default_new_moreDetections' % D
%                 n_std_rms=3.5;  %2.8  53.8
%                 freq_bounds = [250 900];
%                 rmsLen_ms=3;
%                 join_gap_ms=3; %2 5 2.2
%                 minAcceptLen_ms=4.5;  %ms %4.5
%                 minPeaks = 13;
%                 peakPromRatio = 0.25;
%             case 'default_new_moreDetections' % E
%                 n_std_rms=3.9;  %2.8  53.8
%                 freq_bounds = [250 900];
%                 rmsLen_ms=3;
%                 join_gap_ms=2.5; %2 5 2.2
%                 minAcceptLen_ms=4.5;  %ms %4.5
%                 minPeaks = 13;
%                 peakPromRatio = 0.25;

            case 'default_new_moreDetections' % F
                n_std_rms=3;  %2.8  53.8
                freq_bounds = [250 900];
                rmsLen_ms=3;
                join_gap_ms=3; %2 5 2.2
                minAcceptLen_ms=4;  %ms %4.5
                minPeaks = 13;
                peakPromRatio = 0.25;

       end

        %ds = RMSDetectorChvojkaEdit_proIED_2(s,[],fs,filteringfun,fmax,rmsLen,join_gap,minAcceptLen,n_std_rms,widen,minPeaks,b_disp);
       Nover = 20;
       b_disp = false;
       %b_disp = true;
      
       ds = RMSdetector_staba_chvojka_simplified_v1(s,fs,plt.filteringfun_FR, n_std_rms, freq_bounds , rmsLen_ms, join_gap_ms, minAcceptLen_ms, minPeaks, peakPromRatio, Nover, b_disp);

       % vicinity filter
       intersectingIEDbyammount_Inds = any( [abs(ds.onset_offsets-2500)<1000]' ); % also require the  HFO to intersect IED by 200ms 
       %ds.onset_offsets(~intersectingIEDbyammount_Inds,:) = [];

       if ~isempty(ds.onset_offsets) 
           %imagesc(ds.figdata)
           % selct the longest detection
           [lens_sorted,lensInds_sorted] = sort( ds.detections_len ,'descend');
           widest_ind =[];
           for i = 1:numel(lensInds_sorted)
               if intersectingIEDbyammount_Inds( lensInds_sorted(i) )
                  widest_ind = lensInds_sorted(i);
                  continue;
               end
           end
           if ~isempty(widest_ind)

               startInd = ds.onset_offsets(widest_ind,1);
               endInd = ds.onset_offsets(widest_ind,2);
    
               Tiedhfo.HasFR(ir) = true;
    
               peaksIndsInFrame = ds.peaksIndsC{widest_ind};
               peaksInd = zeros(size(s));
               peaksInd(peaksIndsInFrame) = true;
    
               Tiedhfo.FRpeaksInd{ir} = peaksInd;
               Tiedhfo.FRfreq(ir) = ds.hfo_freqs(widest_ind);
               Tiedhfo.FRpwr(ir) = mean( ds.rms_fd( startInd : endInd ) );  % longest detection mean power
               Tiedhfo.FRlength_ms(ir) = 1000*( ds.detections_len(widest_ind) )/fs; % longest detection in ms
           else
               Tiedhfo.HasFR(ir) = false;
           end
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

%Tiedhfo_default=Tiedhfo;
Tiedhfo_default_new_moreDetections = Tiedhfo;
save7fp = a.pwd(['Tiedhfo_' hfodetector_param '.mat']); save7