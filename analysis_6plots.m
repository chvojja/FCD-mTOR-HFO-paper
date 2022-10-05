

%%

% Tiedf.Subject=Tiedf.Subject;
% 
% Tiedf = leftjoinsorted(Tiedf,Tsub,'LeftKeys',{'Subject'},'RightKeys',{'Subject'},'RightVariables',{'Role'});
% 
% TieddSubset = Tiedf;
% save7fp = 'D:\temp_FCD_analyza_1\TieddSubset.mat'; save7

%% plot settings



% %% Histogram of oscillations
% % 
% controlsL = Tiedf.Role == 'CTRL' ;
% 
% selectL = controlsL;
% x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
% x = readvar( Folder = a.pwd(['Tied' filesep 'Signal']), Tiedf.ID( selectL  );
% x = readvar( Files = Tiedf.SignalFile( selectL ) , ReadFun = @(x)loadbin(x, [1,5000] , 'double' ), 1 );
% ied_avg_CTRL =  mean( x - mean(x,2) , 1 ) ;
% 
% x = double( cell2mat( Tiedf.RpeaksInd( selectL & Tiedf.HasR )  ) );
% RpeaksCount_CTRL = sum(x);
% x = double( cell2mat( Tiedf.FRpeaksInd( selectL & Tiedf.HasFR )  ) );
% FRpeaksCount_CTRL = sum(x);
% 
% 
% 
% fcdsL = Tiedf.Role == 'TREAT'  ;
% 
% selectL = fcdsL;
% x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
% ied_avg_TREAT =  mean( x - mean(x,2) , 1 ) ;
% 
% x = double( cell2mat( Tiedf.Signal( selectL & Tiedf.HasR  )  ) );
% ied_avgR_TREAT =  mean( x - mean(x,2) , 1 ) ;
% x = double( cell2mat( Tiedf.Signal( selectL & Tiedf.HasFR  )  ) );
% ied_avgFR_TREAT =  mean( x - mean(x,2) , 1 ) ;
% 
% x = double( cell2mat( Tiedf.RpeaksInd( selectL & Tiedf.HasR )  ) );
% RpeaksCount_TREAT = sum(x);
% x = double( cell2mat( Tiedf.FRpeaksInd( selectL & Tiedf.HasFR )  ) );
% FRpeaksCount_TREAT = sum(x);
% 
%% R plot histogram of oscillations
feature = 'peakOscillations_Lesion_R';
feature = 'peakOscillations_OUT_R';
NbinsOnseSide = 20;
NsOneBin = 25;
% IN lesion

selectL =  TsubRes_inout.InLesion == false;
meanIED = mean( double( cell2mat( TsubRes_inout.meanIED( selectL  )  ) )  );

peakcounts_subjects = double( cell2mat( TsubRes_inout.RpeaksCount( selectL )  ) );
peakcountsC = cell(size(data_RpeaksCount,1),1);

for i = 1: size(data_RpeaksCount,1)
    %[c,b,Nb,sI,eI] = binPeakCounts(peakcounts_subjects(i,:),NbinsOnseSide);
Nframe = 5000;
NOneSide = NsOneBin * NbinsOnseSide;
sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
peakCountsCropped = peakcounts_subjects(i, sI : eI );
groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
counts = splitapply(@sum,peakCountsCropped,groups_bins);
Nb=eI-sI+1;

    peakcountsC{i} = counts/sum(counts);
end
peakcounts=cell2mat(peakcountsC);
meancounts = nanmean(peakcounts);
sems = zeros(size(meancounts));
% compute sem
for i=1:size(peakcounts,2)
    [~,ss] =meansem(peakcounts(:,i));
    sems(i) = ss;
end



figure;
h1 = plot(meanIED(sI:eI), 'LineWidth',1.5,'Color','k'); hold on;
Nb=eI-sI+1;
bar(linspace(1,Nb,NbinsOnseSide*2)  ,    meancounts ,'k')  %max(ied_avg)

hold on
er = errorbar(linspace(1,Nb,NbinsOnseSide*2),  meancounts  ,sems,sems);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off

ylabel('probability')
title('Distribution of R oscillation peaks (FCD) with respect to average IED (Out FCD)');

print2pngPaper(a.pwd([ picIdentifier feature '2.png']),1.3*paperW,1.3*paperH/2);

%%

% figure;
% h1 = plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color','k'); hold on;
% Nb=eI-sI+1;
% bar(linspace(1,Nb,NbinsOnseSide*2)  ,    counts/sum(counts)  ,'k')  %max(ied_avg)
% 
% ied_avg = ied_avg_CTRL -0.2;
% h2 = plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color',[0.8 0.8 0.8]); hold on;
% 
% legend([h1 h2], {'FCD','CTRL'})
% hold off;
% 
% title('Distribution of R oscillation peaks (FCD) with respect to average IED (FCD, CTRL)');




% 
% ied_avg = ied_avg_CTRL -0.2;
% peakcounts = RpeaksCount_CTRL;
% 
% ied_avg = ied_avgR_TREAT -0.2; % Comment if you need CTRL
% peakcounts = RpeaksCount_TREAT;
% 
% NbinsOnseSide = 20;
% NsOneBin = 25;
% Nframe = 5000;
% 
% NOneSide = NsOneBin * NbinsOnseSide;
% 
% sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
% peakCountsCropped = peakcounts( sI : eI );
% groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
% counts = splitapply(@sum,peakCountsCropped,groups_bins);
% 
% figure;
% h1 = plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color','k'); hold on;
% Nb=eI-sI+1;
% bar(linspace(1,Nb,NbinsOnseSide*2)  ,    counts/sum(counts)  ,'k')  %max(ied_avg)
% 
% ied_avg = ied_avg_CTRL -0.2;
% h2 = plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color',[0.8 0.8 0.8]); hold on;
% 
% legend([h1 h2], {'FCD','CTRL'})
% hold off;
% 
% title('Distribution of R oscillation peaks (FCD) with respect to average IED (FCD, CTRL)');
% 
% 
% %% FR  plot histogram of oscillations
% 
% ied_avg = ied_avg_CTRL -0.2;
% peakcounts = FRpeaksCount_CTRL;
% 
% ied_avg = ied_avgFR_TREAT -0.2;      % Comment if you need CTRL
% peakcounts = FRpeaksCount_TREAT;
% % 
% % ied_avg = ied_avgFR_TREAT -0.2;
% 
% NbinsOnseSide = 20;
% NsOneBin = 25;
% Nframe = 5000;
% 
% NOneSide = NsOneBin * NbinsOnseSide;
% 
% sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
% peakCountsCropped = peakcounts( sI : eI );
% groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
% counts = splitapply(@sum,peakCountsCropped,groups_bins);
% 
% figure;
% h1 = plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color','k'); hold on;
% Nb=eI-sI+1;
% bar(linspace(1,Nb,NbinsOnseSide*2)  ,    counts/sum(counts)  ,'k')  %max(ied_avg)
% 
% ied_avg = ied_avg_CTRL -0.2;
% h2 = plot(ied_avg(sI:eI), 'LineWidth',1.5,'Color',[0.8 0.8 0.8]); hold on;
% 
% legend([h1 h2], {'FCD','CTRL'})
% hold off;
% 
% title('Distribution of FR oscillation peaks (FCD) with respect to average IED (FCD, CTRL)');
% 
% %%
% % 
% % plot(ied_avg_CTRL);
% % hold on;
% % plot(ied_avg_TREAT);



% %% PSD each 
% r = size(Tsub,1);
% 
% for i = 1:r
%     pw = Tsub.IEDpwelch{i};
%     fw = Tsub.IEDfwelch{i};
%     subplot(5,2,i);
%     semilogy(fw,pw,'Color',0.5*color.( char(Tsub.Role(i))   )  ,'LineWidth',1 );
%     grid
%     title([ char(Tsub.Subject(i)) '  '  num2str(Tsub.Number(i))  ]);
%     %legend({'Control', 'FCD'});
%     xlabel('Hz');
%     ylabel('PSD')
% end
% paperW = 8;
% paperH = 12;
% print2pngPaper(a.pwd([ picIdentifier 'PSDeach.png']),paperW,paperH);
% 
% %% PSD means
% 
% for i = 1:r
%     pw = Tsub.IEDpwelch{i};
%     fw = Tsub.IEDfwelch{i};
% 
%     semilogy(fw,pw,'Color',0.5*color.( char(Tsub.Role(i))   )  ,'LineWidth',0.5 ); hold on;
% end
% % means
% group = 'CTRL';
% x = double( cell2mat( Tsub.IEDpwelch(  Tsub.Role ==  group  )  ) );
% %x =  mean( x - mean(x,2) , 1 ) ;
% x =  mean( x , 1 ) ;
% semilogy(fw,x,'Color',color.( group  )  ,'LineWidth',1.5 ); hold on;
% 
% group = 'TREAT';
% x = double( cell2mat( Tsub.IEDpwelch(  Tsub.Role ==  group  )  ) );
% %x =  mean( x - mean(x,2) , 1 ) ;
% x =  mean( x , 1 ) ;
% semilogy(fw,x,'Color',color.( group  )  ,'LineWidth',1.5 ); hold on;
% grid
% 
% title('Welch Power Spectral Density estimate, all subjects with means')
% %legend({'Control', 'FCD'});
% xlabel('Hz');
% ylabel('PSD')
% hold off;
% 
% 
% paperW = 8;
% paperH = 5;
% print2pngPaper(a.pwd([ picIdentifier 'PSD.png']),paperW,paperH);


% %% PSD FCD lesion vs outer
% x1 = double([Tiedf.Signal{  Tiedf.Role == 'TREAT'  && Tiedf.Position == 'OUT'    }]) ;
% x2 = double([Tiedf.Signal{ Tiedf.Role == 'TREAT'  && Tiedf.Position == 'IN'     }]);
% 
% nff = 5000; fs = 5000;
% plotPSDWelch(x1,fs,nff,[0 0 1]);
% plotPSDWelch(x2,fs,nff,[1 0 0]);
% title('Welch Power Spectral Density estimate, electrodes in the lesion vs outside the lesion, FCD animals')
% legend({'Outside, FCD', 'Inside, FCD'});
% hold off;

% %% IED plots
% Nb = 50;
% 
% controlsL = Tiedf.Role == 'CTRL' ;
% fcdsL = Tiedf.Role == 'TREAT' ;
% 
% selectL = fcdsL;
% x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
% x=  mean( x - mean(x,2) , 1 ) ;
% x = x(:,2300:2700);
% x=x(:);
% 
% ht = histogram(x,Nb,"FaceColor",color.TREAT,'Normalization','probability');
% 
% 
% hold on;
% 
% selectL = controlsL;
% x = double( cell2mat( Tiedf.Signal( selectL  )  ) );
% x=  mean( x - mean(x,2) , 1 ) ;
% x = x(:,2300:2700);
% x=x(:);
% 
% hc = histogram(x,Nb,"FaceColor",color.CTRL,'Normalization','probability'); 
% 
% bw = 0.02;
% ht.Normalization = 'probability';
% ht.BinWidth = bw;
% hc.Normalization = 'probability';
% hc.BinWidth = bw;
% 
% title('Distribution of IED samples')
% legend({'FCD', 'Control'});
% 
% 
% xlim([-1.5 1.5])
% xlabel('Positivity/negativity, mV')
% ylabel('Probability [-]')
% 
% hold off;
% 
% paperW = 4;
% paperH = 4;
% print2pngPaper(a.pwd('IEDpob.png'),paperW,paperH);


%%
% color.TREAT = favouritecolors('EpiPink');
% cellparams.scatter.TREAT = {velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color_pink,'MarkerEdgeColor',color };


paperW = 6;
paperH = 10;

%% IED Skewness

feature = 'IEDskew'; featuremean = 'IEDskew_mean';
labels.ylabel = 'Skewness, [-]';

[hu,hl] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,featuremean,labels);
set(hu,'YLim',[-8 6]);
print2pngPaper(a.pwd([ picIdentifier feature '1.png']),paperW,paperH);

[hu,hl] = plotUpperLower_OutvsIn(TsubRes_inout,featuremean,labels);
print2pngPaper(a.pwd([ picIdentifier featuremean '2.png']),paperW,paperH);

% %% IED rate
% 
% group = 'CTRL';
% y = Tsub.rateIED_min(Tsub.Role == group);
% h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
% text(1*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );
% 
% group = 'TREAT';
% y = Tsub.rateIED_min(Tsub.Role == group);
% %color = ;
% h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
% text(2*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );
% 
% %set(gca,'YLim',[0 6]);
% 
% set(gca,'XLim',[0.5 2.5]);
% set(gca,'XTick',[1 2]);
% set(gca,'xticklabel',{'Control','FCD'});
% % xlabel('Skewness');
% ylabel('IED rate, event/min.');
% 
% 
% print2pngPaper(a.pwd([ picIdentifier 'IEDrate.png']),paperW,paperH);

% %% IED amplitude
% 
% group = 'CTRL';
% y = Tsub.IEDampl_mV(Tsub.Role == group);
% h = scatterrandomized(1, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
% text(1*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );
% 
% group = 'TREAT';
% y = Tsub.IEDampl_mV(Tsub.Role == group);
% %color = ;
% h = scatterrandomized(2, y ,velikostKolecka,'LineWidth',1.5,'MarkerFaceColor',color.(group),'MarkerEdgeColor',color.(group));  hold on;
% text(2*ones(size(y))+0.2,y,   num2str( Tsub.Number(Tsub.Role == group) )   );
% 
% set(gca,'YLim',[0 1]);
% 
% set(gca,'XLim',[0.5 2.5]);
% set(gca,'XTick',[1 2]);
% set(gca,'xticklabel',{'Control','FCD'});
% % xlabel('Skewness');
% ylabel('IED amplitude, mV');
% 
% 
% print2pngPaper(a.pwd([ picIdentifier 'IEDamp.png']),paperW,paperH);

%% IED width

feature = 'IEDwidth_sec'; featuremean = 'IEDwidth_sec';
labels.ylabel = 'IED width, s';

[hu,hl] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,featuremean,labels);
%set(hu,'YLim',[-8 6]);
print2pngPaper(a.pwd([ picIdentifier feature '1.png']),paperW,paperH);

[hu,hl] = plotUpperLower_OutvsIn(TsubRes_inout,featuremean,labels);
print2pngPaper(a.pwd([ picIdentifier featuremean '2.png']),paperW,paperH);


%% R rate
feature = 'rateR_min';
labels.ylabel = 'Ripple rate, event/min.';
plotDotBoxplot_CXvsTREAT(TsubRes,feature,labels);
print2pngPaper(a.pwd([ picIdentifier feature '1.png']),paperW,paperH/2);

[hu,hl] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels) ;

print2pngPaper(a.pwd([ picIdentifier feature '2.png']),paperW,paperH);
%% R amp

feature = 'Rpwr'; featuremean = 'Rpwr';
labels.ylabel = 'Ripple power';

[hu,hl] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,featuremean,labels);
%set(hu,'YLim',[-8 6]);
print2pngPaper(a.pwd([ picIdentifier feature '1.png']),paperW,paperH);

[hu,hl] = plotUpperLower_OutvsIn(TsubRes_inout,featuremean,labels);
print2pngPaper(a.pwd([ picIdentifier featuremean '2.png']),paperW,paperH);


%% R freq

feature = 'Rfreq'; featuremean = 'Rfreq';
labels.ylabel = 'Frequency, Hz';

[hu,hl] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,featuremean,labels);
%set(hu,'YLim',[-8 6]);
print2pngPaper(a.pwd([ picIdentifier feature '1.png']),paperW,paperH);

[hu,hl] = plotUpperLower_OutvsIn(TsubRes_inout,featuremean,labels);
print2pngPaper(a.pwd([ picIdentifier featuremean '2.png']),paperW,paperH);



%% R duration

feature = 'Rlength_ms'; featuremean = 'Rlength_ms';
labels.ylabel = 'Ripple duration, ms';

[hu,hl] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,featuremean,labels);
%set(hu,'YLim',[-8 6]);
print2pngPaper(a.pwd([ picIdentifier feature '1.png']),paperW,paperH);

[hu,hl] = plotUpperLower_OutvsIn(TsubRes_inout,featuremean,labels);
print2pngPaper(a.pwd([ picIdentifier featuremean '2.png']),paperW,paperH);

%% R in IEDs
feature = 'RinIEDs';
labels.ylabel = '% ripples in IEDs';
plotDotBoxplot_CXvsTREAT(TsubRes,feature,labels);
print2pngPaper(a.pwd([ picIdentifier feature '1.png']),paperW,paperH/2);

[hu,hl] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels) ;

print2pngPaper(a.pwd([ picIdentifier feature '2.png']),paperW,paperH);
%% FR in Rs
feature = 'FRinRFRs';
labels.ylabel = '% fast ripples in ripples';
plotDotBoxplot_CXvsTREAT(TsubRes,feature,labels);
print2pngPaper(a.pwd([ picIdentifier feature '1.png']),paperW,paperH/2);

[hu,hl] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels) ;

print2pngPaper(a.pwd([ picIdentifier feature '2.png']),paperW,paperH);

% %%
% labels.y = 'debilni';
% labels.subjects1 = num2cellstr( y1s );  
% labels.subjects2= num2cellstr( y2s );  
% plotUpperLower_CXvsTREAT(y1s,y2s,y1c,y2c,y1c,y2c,labels);

%% IED with and without R
% TODO, does not work

selectL =  TsubRes.Role == 'CTRL' ;
x = mean( double( cell2mat( TsubRes.meanIED( selectL  )  ) )  );

plot(s2t(x,fs),x,'k')


%%

function [counts,groups_bins,Nb] = binPeakCounts(peakcounts,NbinsOnseSide)

Nframe = 5000;
NOneSide = NsOneBin * NbinsOnseSide;
sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
peakCountsCropped = peakcounts( sI : eI );
groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
counts = splitapply(@sum,peakCountsCropped,groups_bins);
Nb=eI-sI+1;
end


function plotBeforeAfterLinked(data,offset,velikostKolecka,alpha,color1,color2,ydataLabels)
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

    set(hb1,'MarkerFaceColor',color1,'MarkerEdgeColor',color1,'MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha);
    set(hb2,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',color2,'MarkerEdgeAlpha',alpha,'MarkerFaceAlpha',alpha);
    %text(2+0.38-offset,y2+dy/10,ydataLabels(i),'HorizontalAlignment','right','FontSize',fontSize,'Color',color); 
end

set(gca,'YLim',[miny-dy maxy+dy]);
box off;
end


function [hu,hl] = OLDplotUpperLower_CXvsTREAT(y1s,y2s,y1c,y2c,cc1,cc2,labels)
% y1s ... per subject y data
% y1c ... cloud dots y data
% labels.subjects
% labels.y
figurefull;
hu = subplot(2,1,1);

% plot cloud
grafTyp = 'CLOUD';
group = 'CTRL'; 
cloudwidth = 0.2;
%h1 = scatterrandomized( CloudWidth = cloudwidth ,  ScatterParams = { 1 , y1c , plt.kolecko.(grafTyp), 'LineWidth',1.5,'MarkerFaceColor',plt.colorscloud.(group),'MarkerEdgeColor',plt.colorscloud.(group)  } );  hold on;
% h1 = swarmchart(  1 , y1c , plt.kolecko.(grafTyp), 'LineWidth',1.5,'MarkerFaceColor',plt.colorscloud.(group),'MarkerEdgeColor',plt.colorscloud.(group)  );
h1 = swarmchartbetter(  1 , y1c , plt.kolecko.(grafTyp),cc1);
hold on;

group = 'TREAT'; 
%h2 = scatterrandomized( CloudWidth = cloudwidth , ScatterParams = { 2, y2c , plt.kolecko.(grafTyp) ,'LineWidth',1.5,'MarkerFaceColor',plt.colorscloud.(group),'MarkerEdgeColor',plt.colorscloud.(group) } );  hold on;
h2 = swarmchart(  2 , y2c , plt.kolecko.(grafTyp), 'LineWidth',1.5,'MarkerFaceColor',plt.colorscloud.(group),'MarkerEdgeColor',plt.colorscloud.(group)  );

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',plt.xticklabelCTRLTREAT);
ylabel(labels.y);

ylimoptimal(PercentMargin = 0.1);

hold off;



hl = subplot(2,1,2);
% plot per subject s boxplotem
grafTyp = 'SUBJECTS';
group = 'CTRL'; 
d = 0.2; dtext = 0.2;

h3 = scatterrandomized( ScatterParams = { 1, y1s , plt.kolecko.(grafTyp), 'LineWidth',1.5,'MarkerFaceColor',plt.colors.(group),'MarkerEdgeColor',plt.colors.(group) });  
hold on;
text(1*ones(size(y1s))+dtext,y1s,  labels.subjects1  ); % num2str( Tsub.Number(Tsub.Role == group) )  

group = 'TREAT'; 
h4 = scatterrandomized( ScatterParams = { 3, y2s , plt.kolecko.(grafTyp) ,'LineWidth',1.5,'MarkerFaceColor',plt.colors.(group),'MarkerEdgeColor',plt.colors.(group) }); 
text(3*ones(size(y2s))+dtext,y2s,  labels.subjects2  ); % num2str( Tsub.Number(Tsub.Role == group) )  


set(gca,'XLim',[0.5 4.5]);
set(gca,'XTick',[1.5 3.5]);
set(gca,'xticklabel',plt.xticklabelCTRLTREAT);
ylabel(labels.y);

hb2=boxchart([2*ones(size(y1s)); 4*ones(size(y2s))],[y1s; y2s],'BoxFaceColor','k','LineWidth',1.2);

ylimoptimal(PercentMargin = 0.1);

hold off;

end


function [hu,hl] = plotUpperLower_CXvsTREAT(Tiedf,Tsub,featurecloud,featuremean,labels)

figurefull;
labels.xticklabel = {'Control','FCD'};

hu = subplot(2,1,1);
feature = featurecloud;
Tplot = Tiedf(:,{'Subject','Role',feature});
Tplot.Role = cat2num(Tplot.Role,'CTRL',1,'TREAT',2);
hs = swarmchartbetter(Tplot,'Role',feature,'filled','ColorVariable','Subject' );
hs.XJitterWidth = 0.5;

%set(gca,'YLim',[-3.5 0]);
%set(gca,'YLim',[-8 6]);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',labels.xticklabel);
% xlabel('Skewness');
ylabel(labels.ylabel);
ylimoptimal(PercentMargin = 0.1);
%----------------------------------

hl = subplot(2,1,2);  hold on;
% plot per subject s boxplotem
plotDotBoxplot_CXvsTREAT(Tsub,featuremean,labels);

end

function plotDotBoxplot_CXvsTREAT(Tsub,feature,labels)

% plot per subject s boxplotem
d = 0.2;
labels.xticklabel = {'Control','FCD'};

Tplot = Tsub(:,{'Subject','Role',feature});
Tplot.Role = cat2num(Tplot.Role,'CTRL',1+d,'TREAT',2+d);
hb2=boxchart(Tplot.Role,Tplot.(feature),'BoxFaceColor','k','LineWidth',1.2); hold on;
hb2.BoxWidth = 2*d;

% now lets add jitter
Tplot.Role = Tplot.Role -2*d;
hs = scatterbetter(Tplot,'Role',feature,'filled','ColorVariable','Subject' );
hs.SizeData=30;

hlbl = labelpoints (Tplot.Role, Tplot.(feature), Tsub.Number, 'SW', 0.15, 'FontSize', 7);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',labels.xticklabel);
ylabel(labels.ylabel);
ylimoptimal(PercentMargin = 0.1);
hold off;
end




function [hu,hl] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels)  % only FCD animals

figurefull;
labels.xticklabel = {'Outside','Inside'};

hu = subplot(2,1,1); hold on

Tplot = TsubRes_inout( TsubRes_inout.Role == 'TREAT' , {'Subject','Number','InLesion',feature});
Tplot.InLesion = categorical(Tplot.InLesion);
Tplot.InLesion = cat2num(Tplot.InLesion,'false',1,'true',2);
hs = scatterbetter(Tplot,'InLesion',feature,'filled','ColorVariable','Subject' );
hlbl = labelpoints (Tplot.InLesion, Tplot.(feature), Tplot.Number, 'SW', 0.15, 'FontSize', 7);
%hs.XJitterWidth = 0.5;
%set(gca,'YLim',[-3.5 0]);

plot([1 2], [  Tplot(Tplot.InLesion==1,:).(feature)  Tplot(Tplot.InLesion==2,:).(feature)  ]    );



set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',labels.xticklabel);
ylabel(labels.ylabel);
ylimoptimal(PercentMargin = 0.1);
%----------------------------------
hl = subplot(2,1,2); hold on;
% plot per subject s boxplotem

hb2=boxchart(Tplot.InLesion,Tplot.(feature),'BoxFaceColor','k','LineWidth',1.2);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',labels.xticklabel);
ylabel(labels.ylabel);
ylimoptimal(PercentMargin = 0.1);

end

   %hb=boxplot(pd.datavector,pd.groupingvector,'Notch','marker','Color','k');
   
    %hOutliers = findobj(hb,'Tag','Outliers');
%     huw=findobj(hb,'Tag', 'Upper Whisker');
%     hlw=findobj(hb,'Tag', 'Lower Whisker');
%     y_uw=get(huw,'YData'); y_lw=get(hlw,'YData');
%     if iscell(y_uw)
%     max_uw = max(max([y_uw{:}]));
%     min_lw = min(min([y_lw{:}]));
%     else
%     max_uw = max(y_uw);
%     min_lw = min(y_lw);
%     end
%     ylim_no_outliers=[min_lw max_uw]
%     ylim(ylim_no_outliers);

%     set(gca,'XMinorTick','on','YMinorTick','on');
%plot_set_limits(pd,opts);
% plot_set_xylim(0.15,0.15)
% plot_set_optimal_ytick(pd,opts);
% plot_add_labels(pd,opts);



