% 
% % %%%%% st_GFP = load('D:\tempHFO_Naty_GFPcontrols\stGFP_oneSamplesCorrected.mat');
%  st_GFP = load('D:\tempHFO_Naty_GFPcontrols\stGFP_origAlesionSize.mat');
%   st_GFP.subjects(:,2) = {'554';'600';'601';'602'}; % pozor, ten posledni ma NaNy v outer elektrodach
%   st_TREAT = load('D:\tempPremek\st20220113.mat');
%  %%%%%% save('D:\tempHFO_Naty_GFPcontrols\stGFP_origAlesionSize.mat','-struct','st');
 
 subjects_idx_GFP=1:numel(st_GFP.subjNames);
 subjects_idx_TREAT=1:size(st_TREAT.subjects,1);
 subjects_idx_TREAT([3 6]) = [];
 
subjects_idx_GFP_safe=[1 2 3];
subjects_idx_TREAT_safe=subjects_idx_TREAT(1:end-1);

charStrings.CZ.FREQ = 'Frekvence, Hz';
charStrings.EN.FREQ = 'Frequency, Hz';
lang = 'EN';
COLOR_TREAT=[0.7176    0.2745    1.0000]; 
COLOR_CTRL=[0.9412    0.9412    0.9412];
COLOR_CTRL=[0 0 0];

velikostKolecka=45;
alpha=1;
w = 7.87*0.85;
h = 2.36*0.85;

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%



%% IED rate
disp('starting IED rate')
% control  group
st = st_GFP;

tb = st.rateIED(subjects_idx_GFP,:);
ydataLabels=st.subjects(subjects_idx_GFP,2);

data = zeros(size(tb,1),2);
for i = 1:size(tb,1)
    lesion=tb(i,logical(st.lesionnonlesion(i,2:end)));
    outer=tb(i,~logical(st.lesionnonlesion(i,2:end)));
    data(i,[1 2]) = [nanmean(lesion) nanmean(outer)];
    disp('');
    
end
plotBeforeAfterLinked(data,0,velikostKolecka,alpha,COLOR_CTRL,ydataLabels);
set(gca,'xticklabel',{'lesion','non-lesion'});

dataGFP = data;

% treatment group
st = st_TREAT;

tb = st.rateIED(subjects_idx_TREAT,:);
ydataLabels=st.subjects(subjects_idx_TREAT,2);

data = zeros(size(tb,1),2);
for i = 1:size(tb,1)
    lesion=tb(i,logical(st.lesionnonlesion(i,2:end)));
    outer=tb(i,~logical(st.lesionnonlesion(i,2:end)));
    data(i,[1 2]) = [nanmean(lesion) nanmean(outer)];
    disp('');
    
end
plotBeforeAfterLinked(data,-2,velikostKolecka,alpha,COLOR_TREAT,ydataLabels);
set(gca,'xticklabel',{'lesion','non-lesion'});
ylabel('IED rate, event/min.');

dataTREAT = data;

 set(gca,'XLim',[0.5 4.5]);
 set(gca,'XTick',[1 2 3 4]);
 
 compute_statistic(dataGFP,dataTREAT)
 print2pngPaper('IEDrate',w,h);
 close(gcf);
 
%% FR rate
disp('starting FR rate')
% control  group
st = st_GFP;

tb = st.rateFR(subjects_idx_GFP,:);
ydataLabels=st.subjects(subjects_idx_GFP,2);

data = zeros(size(tb,1),2);
for i = 1:size(tb,1)
    lesion=tb(i,logical(st.lesionnonlesion(i,2:end)));
    outer=tb(i,~logical(st.lesionnonlesion(i,2:end)));
    data(i,[1 2]) = [nanmean(lesion) nanmean(outer)];
    disp('');
    
end
plotBeforeAfterLinked(data,0,velikostKolecka,alpha,COLOR_CTRL,ydataLabels);
set(gca,'xticklabel',{'lesion','non-lesion'});

dataGFP = data;

% treatment group
st = st_TREAT;

tb = st.rateFR(subjects_idx_TREAT,:);
ydataLabels=st.subjects(subjects_idx_TREAT,2);

data = zeros(size(tb,1),2);
for i = 1:size(tb,1)
    lesion=tb(i,logical(st.lesionnonlesion(i,2:end)));
    outer=tb(i,~logical(st.lesionnonlesion(i,2:end)));
    data(i,[1 2]) = [nanmean(lesion) nanmean(outer)];
    disp('');
    
end
plotBeforeAfterLinked(data,-2,velikostKolecka,alpha,COLOR_TREAT,ydataLabels);
set(gca,'xticklabel',{'lesion','non-lesion'});
ylabel('FR rate, event/min.')

dataTREAT = data;

 set(gca,'XLim',[0.5 4.5]);
 set(gca,'XTick',[1 2 3 4]);

  compute_statistic(dataGFP,dataTREAT)
  print2pngPaper('FRrate',w,h);
  close(gcf);
 
 
%% Freq
disp('starting freq')
%% control  group
st = st_GFP;

% subjectsLPL=[1 2 3 4 6 7];
meansFreqs =NaN(max(4),5);
meansAmps =NaN(max(4),5);
for ks = 1:4
    for ke=1:numel(st.freq)
        freqs =st.freq{ke}(:,ks);
        notFR = freqs<250;
        freqs(notFR)=NaN;
        
        meansFreqs(ks,ke)=nanmean(freqs);
        
        amps = st.ampl{ke}(:,ks);
        amps(notFR)=NaN;
        meansAmps(ks,ke)=nanmean(amps);      
    end
end
st.meansFreqs = meansFreqs;
st.meansAmps = meansAmps;


tb = st.meansFreqs(subjects_idx_GFP_safe,:);
ydataLabels=st.subjects(subjects_idx_GFP_safe,2);

data = zeros(size(tb,1),2);
for i = 1:size(tb,1)
    lesion=tb(i,logical(st.lesionnonlesion(i,2:end)));
    outer=tb(i,~logical(st.lesionnonlesion(i,2:end)));
    data(i,[1 2]) = [nanmean(lesion) nanmean(outer)];
    disp('');
    
end
plotBeforeAfterLinked(data,0,velikostKolecka,alpha,COLOR_CTRL,ydataLabels);
set(gca,'xticklabel',{'lesion','non-lesion'});

dataGFP = data;

% treatment group
st = st_TREAT;

subjectsAll=1:8;
% subjectsLPL=[1 2 3 4 6 7];
meansFreqs =NaN(max(subjectsAll),5);
meansAmps =NaN(max(subjectsAll),5);
for ks = subjectsAll
    for ke=1:numel(st.freq)
        freqs =st.freq{ke}(:,ks);
        notFR = freqs<250;
        freqs(notFR)=NaN;
        
        meansFreqs(ks,ke)=nanmean(freqs);
        
        amps = st.ampl{ke}(:,ks);
        amps(notFR)=NaN;
        meansAmps(ks,ke)=nanmean(amps);      
    end
end
st.meansFreqs = meansFreqs;
st.meansAmps = meansAmps;

tb = st.meansFreqs(subjects_idx_TREAT_safe,:);
ydataLabels=st.subjects(subjects_idx_TREAT_safe,2);

data = zeros(size(tb,1),2);
for i = 1:size(tb,1)
    lesion=tb(i,logical(st.lesionnonlesion(i,2:end)));
    outer=tb(i,~logical(st.lesionnonlesion(i,2:end)));
    data(i,[1 2]) = [nanmean(lesion) nanmean(outer)];
    disp('');
    
end
plotBeforeAfterLinked(data,-2,velikostKolecka,alpha,COLOR_TREAT,ydataLabels);
set(gca,'xticklabel',{'lesion','non-lesion'});
ylabel('Frequency, Hz')

dataTREAT = data;

%%%%%%
 set(gca,'XLim',[0.5 4.5]);
  set(gca,'YLim',[300 600]);
 set(gca,'XTick',[1 2 3 4]);

  compute_statistic(dataGFP,dataTREAT)
  print2pngPaper('freq',w,h);
   close(gcf);
  
%% AMPL
disp('starting amplitude')
%%% control  group
st = st_GFP;

tb = st.meansAmps(subjects_idx_GFP_safe,:);
ydataLabels=st.subjects(subjects_idx_GFP_safe,2);

data = zeros(size(tb,1),2);
for i = 1:size(tb,1)
    lesion=tb(i,logical(st.lesionnonlesion(i,2:end)));
    outer=tb(i,~logical(st.lesionnonlesion(i,2:end)));
    data(i,[1 2]) = [nanmean(lesion) nanmean(outer)];
    disp('');
    
end
plotBeforeAfterLinked(data,0,velikostKolecka,alpha,COLOR_CTRL,ydataLabels);
set(gca,'xticklabel',{'lesion','non-lesion'});
ylabel('Amplitude, mV');

dataGFP = data;

%%treatment group
st = st_TREAT;

tb = st.meansAmps(subjects_idx_TREAT_safe,:);
ydataLabels=st.subjects(subjects_idx_TREAT_safe,2);

data = zeros(size(tb,1),2);
for i = 1:size(tb,1)
    lesion=tb(i,logical(st.lesionnonlesion(i,2:end)));
    outer=tb(i,~logical(st.lesionnonlesion(i,2:end)));
    data(i,[1 2]) = [nanmean(lesion) nanmean(outer)];
    disp('');
    
end
plotBeforeAfterLinked(data,-2,velikostKolecka,alpha,COLOR_TREAT,ydataLabels);
set(gca,'xticklabel',{'lesion','non-lesion'});
ylabel('Amplitude, mV');

dataTREAT = data;

set(gca,'YLim',[0.05 0.15]);
set(gca,'XLim',[0.5 4.5]);
set(gca,'XTick',[1 2 3 4]);

 compute_statistic(dataGFP,dataTREAT)
 print2pngPaper('ampl',w,h);
 close(gcf);
%% statistika shit shit
[p,h] = signrank(data(:,1),data(:,2))
[p,h] = signrank(data(:,1),data(:,2))


[p,tbl,stats]=friedman(st.meansAmps(1:7,:));

c = multcompare(stats)



function plotBeforeAfterLinked(data,offset,velikostKolecka,alpha,color,ydataLabels)
% data is two columns before, after
fontSize = 10;

miny=min( min(data));
maxy=max( max(data));
dy=(maxy-miny)/10;

hold on;

for i = 1:size(data,1)
    y1=data(i,1);
    y2 =data(i,2);
    
    if ~isnan(y1) && ~isnan(y2)
        plot([1 2]-offset,[y1 y2],'Color','k');
        
    end
    lw = 1.5;
   
        hb1 = scatter([1]-offset,y1 ,velikostKolecka,'LineWidth',lw); 
  
        hb2 = scatter([2]-offset,[ y2],velikostKolecka,'filled','LineWidth',lw); 

    set(hb1,'MarkerFaceColor',color,'MarkerEdgeColor',color,'MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha);
    set(hb2,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',color,'MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha);
    %text(2+0.38-offset,y2+dy/10,ydataLabels(i),'HorizontalAlignment','right','FontSize',fontSize,'Color',color); 
end

set(gca,'YLim',[miny-dy maxy+dy]);
box off;
end


function y = preprocess(data)

y = data(1:7,:);
end





function compute_statistic(dataGFP,dataTREAT)
    disp('testing GFP Group')
    [p,h] = signrank(dataGFP(:,1),dataGFP(:,2))
    
    disp('testing Treat Group')
    [p,h] = signrank(dataTREAT(:,1),dataTREAT(:,2))
    
    disp('testing ctrl vs treat Lesion:')
    [p,h] = ranksum(dataGFP(:,1),dataTREAT(:,1))
end
