classdef WKJcomputeAverageIEDHFO_miceLevelLesionvsOut <  WKJiterateSubjectLabelChanelDetectionObj %timhle explicitne rikam ze chci mi objekt umoznujici iterovani pres labelz a detekce...
properties
    % my new properties except those inherited
    Nperframe;
    MaxSamples;
%     Nmid
%     XLim;
%     title;
    
    buffer;
    lf;
    groupName;

    % structs
    st;
    

    
    
    
 
end

methods %(Static)
       function   o = WKJcomputeAverageIEDHFO_miceLevelLesionvsOut(arg)
                o@WKJiterateSubjectLabelChanelDetectionObj(arg);
                %process arguments for this particular object
                
                o.st = load(arg.st_fpath); 
                o.st.fpath=arg.st_fpath;  % this is crucial, to call it AFTER the loading!!!!
                
%                 o.subjNamesCell{1} = o.st.subjNames;
                
                
                 o.detNames = {'fr'};   
                 o.detFolder = 'IED_HFOnew';
                       
                %o.st.averageIEDs=cell(numel(o.st.subjNames),5);
                 
                
                o.MaxSamples=4000;
                o.Nperframe=2200;
                
                % which group Im
                if contains(o.st.fpath,'GFP')
                    o.groupName = 'GFP';
                else
                    o.groupName = 'TREAT'; 
                end
                
                
                o.iterateSubj();

                % compute means on the mice level
                o.st.averageIED.(o.groupName).lesion.dataMean = mean(o.st.averageIED.(o.groupName).lesion.data);
                o.st.averageIED.(o.groupName).outer.dataMean = mean(o.st.averageIED.(o.groupName).outer.data);
                
  
                
                % save
                st=o.st;
                %save(o.st.fpath,'-struct','st');

       end
end
%% OVERRIDING INHERITED
methods
    
    
%% OVERRIDING INHERITED 

    function onSubjNext(o)  
        
        o.iterateWKJLabel(); % nacti data ze vsech labelu
        % kdyz je spocitano jedno zvire  
        
        if strcmp(o.subjName,'Naty600ExtractedJoined')
            chNames_lesion = {'L','PL'};
            chNames_outer = {'FL','FR'};
        else
             lesionnonlesion = logical(o.st.lesionnonlesion(o.ks,2:end));
             chNames_lesion = o.chNames(lesionnonlesion);
             chNames_outer = o.chNames(~lesionnonlesion);
        end

        [ o.st.averageIED.(o.groupName).lesion.data(o.ks,:) , o.st.averageIED.(o.groupName).lesion.N(o.ks) ] = getAvgSig(o.buffer,chNames_lesion);
        [ o.st.averageIED.(o.groupName).outer.data(o.ks,:) , o.st.averageIED.(o.groupName).outer.N(o.ks) ] = getAvgSig(o.buffer,chNames_outer);
        
        disp('spocitano');
        %o.iterateChStats(); % iteruj znovu skrz detLabel a kanaly a plotuj
        
        function [y,Ndata] = getAvgSig(buffer,chNames)
            Nel=numel(chNames);
            IEDs = [];
            for i = 1:Nel
                chName = chNames{i};
                NpointsInEl = buffer.(chName).ptr-1;
                IEDs = [IEDs; buffer.(chName).data(1:NpointsInEl,:)];
            end
            Ndata = size(IEDs,1);
            y = nanmean(IEDs);
        end
        
        disp('One mouse completed')

    end
    
    
    function onChStatsNextChannel(o)
         
            y = nanmean(o.chStats.bufferX); % mean response    
            lineColor = nanmean(o.chStats.bufferRms); % mean obalka
            
            p=95;
            CIFcn = @(x,p)prctile(x,abs([0,100]-(100-p)/2));        
            CIx=NaN(o.Nperframe,2);
            for i=1:o.Nperframe

                CIx(i,:)=CIFcn(o.chStats.bufferX(:,i),p);
            end
     
            subplot(2,3,o.kch);
                                   
            x = [1:length(y)];
            z = zeros(size(x));
             
            % Plot the line with width 8 so we can see the colors well         
            surface([x;x], [y;y], [z;z], [lineColor;lineColor],...
                'FaceColor', 'no',...
                'EdgeColor', 'interp',...
                'LineWidth',6,...
                'cdatamapping','scaled');
        
            err = CIx'; 
             hold on
             alpha =0.15;
            patch([x, fliplr(x)], [err(1,:), fliplr(err(2,:))], 'k', 'FaceAlpha',alpha,'EdgeAlpha',alpha)   % Shaded Confidence Intervals
            
            
         
            
            %hold off   
            set(gca,'YLim',[-1 0.5]);
            set(gca,'XLim',o.XLim);
            set(gca,'Xticklabels',[]);
            ylabel('volatage, mV')
            
            set(gcf,'renderer','painters');
            title({['Channel  - ' o.chName],[' Averaged from ' num2str(o.chStats.ptr2Sample) ' responses.']});  
            
            
    end
    

   function onChStatsFinishedDetName(o)
       
       sgtitle(o.title) 
       o.chStatsSaveFigure('AverageIEDvsHFOPower');
  
   end
   
 
   function onLabelInitChannel(o)
       
       o.buffer.(o.chName).data=NaN(o.MaxSamples,o.Nperframe);
       o.buffer.(o.chName).ptr = 1;  
       
   end

    
    function onLabelNextChannel(o)

%        % init - prepare where to save data when analysing one subject
%         if ~isfieldnested(o.buffer,o.chName,'ptr') %% if Im using this for the first time
%         %if isfield(o.st.(o.subjName).(o.detName),o.chName)
%             %isfieldnested(o.st,o.subjName,o.detName,o.chName)
%              % init - prepare where to save data when analysing one subject
%              % one det one channel
%             o.st.(o.subjName).(o.detName).(o.chName).ptr2Sample=0;
%             o.st.(o.subjName).(o.detName).(o.chName).bufferX=NaN(o.MaxSamples,o.Nperframe);
%             o.st.(o.subjName).(o.detName).(o.chName).bufferRms=NaN(o.MaxSamples,o.Nperframe);
%             o.st.(o.subjName).(o.detName).(o.chName).bufferFD=NaN(o.MaxSamples,o.Nperframe);
%         end
        
    end
    
    
%     function onLabelNextFile(o)
%         o.lf=load([o.subjPath '\' WKJfs2foldername(o.fs) '\' o.lblFileContent.label.jancaSpike23.srcSigFile]);
% 
% 
%     end

    
    function onLabelNextDetection(o)
                      
        
%                  % najit IEDecko v EEG filu
%                 dataStartDn=o.lf.dateN;
%                 N = size(o.lf.s,2);
%                 offset = (100*1/1000)/(24*3600);
%                 iv = sedn2ivf(o.detStartDn-offset,o.detEndDn+offset,dataStartDn,N,o.fs); % oøez v rámci fajlu
%                 x= o.lf.s(o.kch,iv);
%                 
%                 plot(x)
%                 pause;
                
                 x = o.chStruct.x{o.detIDx};  
        
                Nx=numel(x);
                if Nx>2*o.Nperframe
                    disp('potencialni problem')
                end
                 x_fd=filtfilt(ones(1,10),1,x); %  filtered IED
                 
                 [pks,locs,w,p] = findpeaks(x_fd);  % find IED using peak prominance
                 [~,locs_sorted]=sort2(p,locs);
                 
%                 [mn,mnIDx]=min(x_fd);
                mnIDx = locs_sorted(end);
                sI=length(x)-mnIDx;
                eI=sI+length(x)-1;
                
                xInFrame=NaN(1,o.Nperframe,1);
    
                xInFrame(sI:eI)=x;    
                o.buffer.(o.chName).data(o.buffer.(o.chName).ptr,:) = xInFrame;
                o.buffer.(o.chName).ptr = o.buffer.(o.chName).ptr+1;
                
               
        end

    end

%% OWN    
    methods
     
    end
     
  
end
