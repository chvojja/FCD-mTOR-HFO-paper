% Jan Chvojka Edited
function det_struct=RMSDetectorChvojkaEdit_proIED_2(s,sW,fs,filteringfun,fmax,rmsLen,join_gap,minAcceptLen,n_std_rms,widen,minPeaks,b_disp)
% s ... input signal
% fs ... sampling
% b ... FIR coefficients
s=s(:); % make sure s is column

%% filtrace 
% %Fstops = [ F1 F2 F3 F4]  F2 a F3 jsou tz hlavni
% Dstop = 0.001;          % Stopband Attenuation - utlum 60 db/dec
% Dpass = 0.17099735734;  % Passband Ripple
% dens  = 20;             % Density Factor
% [N, Fo, Ao, W] = firpmord(Fstops/(fs/2), [0 1 0], [ Dstop, Dpass, Dstop]);
% b  = firpm(N, Fo, Ao, W, {dens});

%freqz(b,1)
%fd=filtfilt(bcoef,1,s);

fd = filteringfun(s);
det_struct=[];
figdata=[];

%%
rms_length=round(rmsLen*10^-3*fs); % delka segmentu = 3ms ze ktere se pocita rms
rms_fd=zeros(size(fd));


seg_down=floor((rms_length-1)/2);
seg_up=ceil((rms_length-1)/2);
for i=1:size(s,1)
    seg_start=i-seg_down; %nastaveni zacatku segmentu
    seg_end=i+seg_up; %nastaveni konce segmentu
    if seg_start<1 %korekce u zacatku signalu
        seg_start=1;
    end
    if seg_end>size(s,1) %korekce u konce signalu
        seg_end=size(s,1);
    end
    rms_fd(i,:)=sqrt(  mean(fd(seg_start:seg_end,:).^2));   % rms value of filtred signal fd of the size rms_length 
end
   
%% prahovani
m_rms_fd=mean(rms_fd); % mean rms of the whole filtered signal
s_rms_fd=std(rms_fd); % mean std of the whole filtered signal

vector_threshold=repmat((m_rms_fd+n_std_rms*s_rms_fd),size(fd,1),1);
hfo_cand=rms_fd>vector_threshold; % boolean of samples , HFO candidtes



%% kontrola delky, kratke se vyhodi, blizke spoji
join_gap=round(join_gap*10^-3*fs); % gap in indexes
minAcceptLen=round(minAcceptLen*10^-3*fs); % min len in indexes

hfo_cand(1)=0;
hfo_cand(end)=0;
% hfo_open=imopen(hfo_cand,strel('line',minAcceptLen,90)); % remove shorter than minAcceptLen
% hfo_close=imclose(hfo_open,strel('line',join_gap,90)); % join closer than join_gap


hfo_open=imopen(hfo_cand,strel('line',round(fs/fmax),90)); % remove shorter than 1 period of fmax
hfo_close=imclose(hfo_open,strel('line',join_gap,90)); % join closer than join_gap
hfo_close=imopen(hfo_close,strel('line',minAcceptLen,90)); % remove shorter than minAcceptLen

% hold on;
% plot(fd);
% plot(rms_fd);
% plot(vector_threshold)
% plot(s);
% plot(0.1*hfo_cand)
% plot(0.1*hfo_close)
% disp('')
% close(gcf); 
   
% v hfo_close jsou všechny nad trhresholdem, s minlength a spojeny vedlejsi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplot(2,1,1);
% hold on;
% plot(0.4*hfo_close,'k');
% plot(rms_fd,'r')
% plot(fd,'b')
% plot(vector_threshold,'k')
% if sum(hfo_cand)~=0
% nonzerohfoc=find(hfo_cand);
% tt=zeros(size(fd)); tt(nonzerohfoc(1):nonzerohfoc(1)+minAcceptLen)=max(fd);
% plot(tt,'g');
% end
% subplot(2,1,2);
% plot(s);
% close(gcf);


if ~isempty(hfo_close)


%% 
% abs_fd=abs(fd);
% m_abs_fd=mean( abs_fd ); % rectified filtered
% s_abs_fd=std( abs_fd );
%  % pocet vrcholku ktere maji byt vyssi jak ntimes std
% vector_threshold2=repmat((m_abs_fd+n_std_peak*s_abs_fd),size(fd,1),1);
%% kontrola autokorel.

OOI=get_OOI(double(hfo_close));
len_OOI=size(OOI,1);
hfo_freqs=zeros(1,len_OOI);
selectedIDx=logical(ones(len_OOI,1));
peaksIndsL=false(len_OOI,length(fd));
for i=1:len_OOI
    start=OOI(i,1); stop=OOI(i,2);
    Nw=round( widen*(stop-start)/2  );
    start = start - Nw;
    stop = stop + Nw;
    if stop>numel(fd), stop = numel(fd); end;
    if start < 1, start =1; end;
    % start autocorelation freq detection
    x=fd(start:stop);
    %f=[];
    x=x-mean(x); 
    
    
    distanceSec=1/fmax;
    [fp,fi,~,p]=findpeaks(xcorr(x,x),fs,'SortStr','descend','MinPeakDistance',distanceSec); %,'MinPeakWidth',widthSec);
    if numel(fp)>=minPeaks
       prominanceSecondVsFirst=p(1)/p(2);
       if prominanceSecondVsFirst<4
           hfo_freqs(i)=1/mean(diff(sort(fi(1:3))));
%            if  hfo_freqs(i)>50 && hfo_freqs(i)<120
%                disp('')
%            end;
                 [fdp,fdi,~,pd]=findpeaks(x,'SortStr','descend');
            peaksIndsL(i,start+fdi')=true;
       end 
    end
    
    
    if hfo_freqs(i)==0
        selectedIDx(i)=false; % delete because false detection
    end
  


 if b_disp %%&& selectedIDx(i) % Zobrazeni na požádání
figurefull;

subplot(3,1,1);
hold on;
plot(0.4*hfo_close,'g');
plot(0.2*hfo_cand,'k');
plot(rms_fd,'r')
plot(fd,'b')
plot(vector_threshold,'k')
dd=zeros(size(vector_threshold,1),1);
dd(start:stop)=0.4;
%plot(dd,'y')

subplot(3,1,2);
plot(s);

subplot(3,1,3)
%plotstockwell(s,fs,1.8,[300 800],10,'linear')

title(num2str( selectedIDx(i) ) )
pause
    
close(gcf)
%     hf=figure;
%     subplot(2,1,1)
%     hold on;
%     off=0;
%     nstr=start-off; nstp=stop+off;
%     if nstr<0, nstr=1; end;
%     if nstp>numel(rms_fd), nstp=numel(rms_fd); end;
%     ncrop=nstp-nstr+1;
%     t=0:1/fs:(ncrop-1)/fs; 
%     plot(t,rms_fd(nstr:nstp),'b'); 
%     plot(t,0.4*hfo_close(nstr:nstp),'k');
%     plot(t,fd(nstr:nstp),'r');
%     plot(t,s(nstr:nstp),'g')
%     plot(t,vector_threshold(nstr:nstp),'k')
%     title(num2str(hfo_freqs(i)))
%     xlabel('time')
%     ylabel('amplitude')
%     title(num2str(selectedIDx(i)));
%     set(gca,'Color','white')
%     hold off;
%     subplot(2,1,2);
%     plot(t,s(nstr:nstp),'k');
    
    title(num2str(selectedIDx(i)));
    f=getframe(gcf);
    figdata=f.cdata;
    close(gcf); 
 end


   
end



det_struct=struct;
%det_struct.detections=detections; % save detections
det_struct.OOI=OOI(selectedIDx,:); % save detections in onset offset format
det_struct.peaksInd = peaksIndsL(selectedIDx,:);
det_struct.fd=fd; % save filtered signal
det_struct.rms_fd=rms_fd; %save rms of filtered
det_struct.hfo_freqs=hfo_freqs(selectedIDx); % save frequency
det_struct.figdata = figdata;


if ~isempty(det_struct.OOI) && ~isempty(sW) % jeste jednou ale pro delsi signal
    %% wider shit
    sW=sW(:);  
    fdFull =filtfilt(b,1,sW);
    det_struct.fdFull=fdFull;
    rms_fdFull=zeros(size(fdFull));

    seg_down=floor((rms_length-1)/2);
    seg_up=ceil((rms_length-1)/2);
    for i=1:size(sW,1)
        seg_start=i-seg_down; %nastaveni zacatku segmentu
        seg_end=i+seg_up; %nastaveni konce segmentu
        if seg_start<1 %korekce u zacatku signalu
            seg_start=1;
        end
        if seg_end>size(sW,1) %korekce u konce signalu
            seg_end=size(sW,1);
        end
        rms_fdFull(i,:)=sqrt(  mean(fdFull(seg_start:seg_end,:).^2));   % rms value of filtred signal fd of the size rms_length 
    end
    det_struct.rms_fdFull=rms_fdFull;
    
end


end



