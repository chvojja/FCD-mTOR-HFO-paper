classdef WKJdetectHFO_R <  WKJiterateSubjectLabelChanelDetectionObj %timhle explicitne rikam ze chci mi objekt umoznujici iterovani pres labelz a detekce...
properties
    % my new properties except those inherited
 
  
end

methods 
    function o = WKJdetectHFO_R(arg)
        %o@WKJiterateSubjectObj(arg);
        o@WKJiterateSubjectLabelChanelDetectionObj(arg);
        

    end
end


methods (Static)
       function o = run() % for running standalone
                o = WKJdetectHFO_R([]);
                % for subject:
                % tohle jsou cesty k myšim. Složka RootWKJ má vždycky stejnou danou strukturu.
                o.subjRootPathsCell{1} = 'D:\tempPremek'; % cesta
                o.subjNamesCell{1} = {'PremekMysExtractedJoinedChanCorrect'}; % nazev myši
                %o.subjNamesCell{1} = {'TryskoMysExtractedJoined'}; % nazev myši 
                
                %o.subjNamesCell{1} = {'PremekMysExtractedJoinedChanCorrect', 'TryskoMysExtractedJoined'}; % nazev myši 
                
                o.fs = 5000;
                o.detNames = {'jancaSpike23'};   
                o.detFolder = 'IED_HFOnew';
                o.kchs=[1 2 3 4 5];
                %o.kchs=[1];
                o.verboseOn=false;
                % run
                o.iterateSubj();
       end
end
%% OVERRIDING INHERITED
methods
    
    
%% OVERRIDING INHERITED   
    function onSubjNext(o)  
        o.iterateWKJLabel();
    end
    
%     function onLabelNextChannel(o)
%             for i = 1:numel(o.chStruct.posN)  
%         Ntimes=15;
%         o.labelStartDn = o.chStruct.posN(i)-Ntimes*o.chStruct.durN(i);
%         o.labelEndDn = o.chStruct.posN(i) + o.chStruct.durN(i) + Ntimes*o.chStruct.durN(i) ; % widen label
%         %disp(['mnauky  ' num2str(i) '    ' num2str(o.kchs) '_' o.subjName]);
%         %if o.kch==3 %&& i==13
%             %onLabelNextDetection(o);
%         %end
%             end
%     end
    
   
    
    
    function onLabelFinishedFile(o)
        % on new label file finished
     
         % save
         pathForLabelFiles = [o.subjPath '\' o.detFolder ];
         mkdir(pathForLabelFiles);
         %newLabelFileName = [ o.eegFileName(1:end-4) '-lbl.mat'];
         fpLabel = [pathForLabelFiles '\' o.lblFileName];
         label=o.lblFileContent.label;
         save(fpLabel, 'label');
         %disp('');
        
    end

    function onLabelNextDetection(o)
        
        detEnlargeForDetectorSec = 0.25;
        detEnlargeForSavingSec = 0.5;
        dSec = (detEnlargeForSavingSec-detEnlargeForDetectorSec);
        sIeIpercent = [dSec   2*detEnlargeForSavingSec-dSec]/(2*detEnlargeForSavingSec); % percentage start end
        
        detEnlargeForSavingDn = sec2dn(detEnlargeForSavingSec);
        detEnlargeForDetectorDn = sec2dn(detEnlargeForDetectorSec);
        
        detEnlargeForDetectorStartDn = o.detStartDn-detEnlargeForDetectorDn;
        detEnlargeForDetectorDurDn = 2*detEnlargeForDetectorDn;
        
        backupkchs=o.kchs;
        o.kchs=[o.kch] ; 
        sigS = WKJgetEEGInRangeDn(o,o.detStartDn-detEnlargeForSavingDn,o.detStartDn+detEnlargeForSavingDn);
        o.kchs=backupkchs;
                
        xFull=sigS.data; Nsave = numel(xFull); % signal for saving
        sIeI=ceil(sIeIpercent*Nsave);
        xdtc=xFull(sIeI(1):sIeI(2)); % signal to feed to detector
        Ndtc = numel(xdtc);
         

        
        
        % nastaveni na ripple
        rmsLen=3;
        join_gap=20;
        minAcceptLen=17;  %6
        n_std_rms=2.5; 
        b_disp=1; % detector settings
        widen=1;
        minPeaks = 7;
        fstops=[60 80 200 250];
        det_struct = RMSDetectorChvojkaEdit_proIED(xdtc,xFull,o.fs,fstops,rmsLen,join_gap,minAcceptLen,n_std_rms,widen,minPeaks,b_disp);
        
        if ~isempty(det_struct) 
        if ~isempty(det_struct.OOI) %%&& false
            % edit R HFO label
            %disp('mam hfo')
%             Ndtc = length(sigS.time);
%             Noffset = round(0*Ndtc);
%             sI=Noffset+1; eI=Ndtc-Noffset;
            for kd=1:size(det_struct.OOI,1) % muzu mit vice detekci HFO kolem IED s ruznymi frekvencemi
                i=1+length(o.lblFileContent.label.fr.(num2kch(o.kch)).posN);
                % signal used for detection
                o.lblFileContent.label.r.(num2kch(o.kch)).posN(i)=detEnlargeForDetectorStartDn + (det_struct.OOI(kd,1)/Ndtc)*detEnlargeForDetectorDurDn;
                o.lblFileContent.label.r.(num2kch(o.kch)).durN(i)=((det_struct.OOI(kd,2)-det_struct.OOI(kd,1))/Ndtc)*detEnlargeForDetectorDurDn;
                o.lblFileContent.label.r.(num2kch(o.kch)).value(i)=8;
                o.lblFileContent.label.r.(num2kch(o.kch)).freq(i)=det_struct.hfo_freqs(kd);
                o.lblFileContent.label.r.(num2kch(o.kch)).rms_fd{i}=det_struct.rms_fd; % jsou orizle jen trochu, sirsi nez detekce
                o.lblFileContent.label.r.(num2kch(o.kch)).fd{i}=det_struct.fd;
                o.lblFileContent.label.r.(num2kch(o.kch)).x{i}=xdtc;  
                o.lblFileContent.label.r.(num2kch(o.kch)).posIinX(i)=det_struct.OOI(kd,1);
                                
                % full signal saving
                o.lblFileContent.label.r.(num2kch(o.kch)).xFull{i}=xFull;  
                o.lblFileContent.label.r.(num2kch(o.kch)).xposIinXfull(i)=sIeI(1);  
                o.lblFileContent.label.r.(num2kch(o.kch)).rms_fdFull{i}=det_struct.rms_fdFull;
                o.lblFileContent.label.r.(num2kch(o.kch)).fdFull{i}=det_struct.fdFull;
                
            end          
            % edit IED label
            o.lblFileContent.label.jancaSpike23.(num2kch(o.kch)).hasHFO(o.detIDx)=true;
            o.lblFileContent.label.jancaSpike23.(num2kch(o.kch)).hasR(o.detIDx)=true;  
            
            
           % save image
            if b_disp && ~isempty(det_struct.figdata)
            path_images=[o.rootWKJ, '\' o.subjName '\' 'Rimages' ];
            mkdir(path_images);
            imageName = ['ch ' num2str(o.kch) '  ' datestr(o.detStartDn,'yy_mm_dd-HH_MM_SS')  '   frequency  ' num2str(det_struct.hfo_freqs)];
            imwrite(det_struct.figdata,[ path_images '\' imageName '.jpg'],'JPEG');
            end
        end
        end
                
            
 
       

    end
end

   
     
  
end
