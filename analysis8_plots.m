

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - IED plots

% IED traces

linewidth = 1.2;
figurefull;
sp(1) = subplot(2,6,[1 2 3]);  % This has to be drawn first to be able to draw significant line exactly :((
sp(2) = subplot(2,6,[4 5 6]);
sp(3) = subplot(2,6,[7 8]);
sp(4) = subplot(2,6,[9 10]);
sp(5) = subplot(2,6,[11 12]);
% pause(0.5);
drawnow;
resize2cm(plt.w,plt.h);
%

%sp(1) = subplot(2,6,[1 2 3]);
axes(sp(1));
[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'CTRL' , :)    ,   Tiedf( Tiedf.InLesion == true , : )    ) ;
confidenceshade( 1:5000 , ied-iedsems , ied+iedsems, Color = 'r' ); hold on; 
hp1 = plot(ied,'r','LineWidth',linewidth); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'CTRL', :)    ,   Tiedf( Tiedf.InLesion == false , : )    ) ;
confidenceshade( 1:5000 , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
hp2 = plot(ied,'k','LineWidth',linewidth); 

ylabel('Amplitude, mV');
legend([hp1 hp2],'Lesion', 'Outside');
title('Controls');


%sp(2) = subplot(2,6,[4 5 6]);
axes(sp(2));

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.InLesion == true , : )    ) ;
confidenceshade( 1:5000 , ied-iedsems , ied+iedsems, Color = 'r' ); hold on; 
hp1 = plot(ied,'r','LineWidth',linewidth); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.InLesion == false , : )    ) ;
confidenceshade( 1:5000 , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
hp2 = plot(ied,'k','LineWidth',linewidth); 

%ylabel('Amplitude, mV');
%legend([hp1 hp2],'Lesion', 'Outside');
title('FCD');


% IED rate

% pcka a tabulku spocitat jinde a tady jen kreslit
% p lajnu vykreslit az nakonec

feature = 'rateIED_min';
labels.ylabel = 'IED rate, event/min.';

%sp(3) = subplot(2,6,[7 8]);
axes(sp(3));

[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(labels.ylabel);

%sp(4) = subplot(2,6,[9 10]);
axes(sp(4));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);

%sp(5) =  subplot(2,6,[11 12]);
axes(sp(5));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);

%resize2tight();

printpaper(  a.pwd([ ' Fig3.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);


%% Fig 4 PSD plots

figurefull;
sp(1) = subplot(2,6,[1 2]);  % This has to be drawn first to be able to draw significant line exactly :((
sp(2) = subplot(2,6,[3 4]);
sp(3) = subplot(2,6,[5 6]);
sp(4) = subplot(2,6,[7 8]);
sp(5) = subplot(2,6,[9 10 11 12]);
% pause(0.5);
drawnow;
resize2cm(plt.w,plt.h);


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
% %% R plot histogram of oscillations
% feature = 'peakOscillations_Lesion_R';
% feature = 'peakOscillations_OUT_R';
% NbinsOnseSide = 20;
% NsOneBin = 25;
% % IN lesion
% 
% selectL =  TsubRes_inout.InLesion == false;
% meanIED = mean( double( cell2mat( TsubRes_inout.meanIED( selectL  )  ) )  );
% 
% peakcounts_subjects = double( cell2mat( TsubRes_inout.RpeaksCount( selectL )  ) );
% peakcountsC = cell(size(data_RpeaksCount,1),1);
% 
% for i = 1: size(data_RpeaksCount,1)
%     %[c,b,Nb,sI,eI] = binPeakCounts(peakcounts_subjects(i,:),NbinsOnseSide);
% Nframe = 5000;
% NOneSide = NsOneBin * NbinsOnseSide;
% sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
% peakCountsCropped = peakcounts_subjects(i, sI : eI );
% groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
% counts = splitapply(@sum,peakCountsCropped,groups_bins);
% Nb=eI-sI+1;
% 
%     peakcountsC{i} = counts/sum(counts);
% end
% peakcounts=cell2mat(peakcountsC);
% meancounts = nanmean(peakcounts);
% sems = zeros(size(meancounts));
% % compute sem
% for i=1:size(peakcounts,2)
%     [~,ss] =meansem(peakcounts(:,i));
%     sems(i) = ss;
% end
% 
% 
% 
% figure;
% h1 = plot(meanIED(sI:eI), 'LineWidth',1.5,'Color','k'); hold on;
% Nb=eI-sI+1;
% bar(linspace(1,Nb,NbinsOnseSide*2)  ,    meancounts ,'k')  %max(ied_avg)
% 
% hold on
% er = errorbar(linspace(1,Nb,NbinsOnseSide*2),  meancounts  ,sems,sems);    
% er.Color = [0 0 0];                            
% er.LineStyle = 'none';  
% hold off
% 
% ylabel('probability')
% title('Distribution of R oscillation peaks (FCD) with respect to average IED (Out FCD)');
% 
% print2pngPaper(a.pwd([ picIdentifier feature '2.png']),1.3*paperW,1.3*paperH/2);

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

%% 

% 
% iToPlot = [1];
% 
% for i = iToPlot
% 
% end
% 

Tst_CtrlVsTreat = table;
Tst_OutVsIn = table;
%% IED Skewness

feature = 'IEDskew'; 
labels.ylabel = 'Skewness, [-]';

[hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
set(hu,'YLim',[-8 6]);
printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;

[hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_OutVsIn{ feature , 'p' } =  stats.p;



%% IED ampl

feature = 'IEDampl_mV'; 
labels.ylabel = 'IED amplitude, mV';

[hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;

[hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_OutVsIn{ feature , 'p' } =  stats.p;


%% IED width


feature = 'IEDwidth_msec'; 
labels.ylabel = 'IED width, ms';

[hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;

[hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_OutVsIn{ feature , 'p' } =  stats.p;


%% R rate   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% smaller size
feature = 'rateR_min';
labels.ylabel = 'Ripple rate, event/min.';

stats = plotDotBoxplot_CXvsTREAT(TsubRes,feature,labels,plt.w,plt.h/2);
printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;


[hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_OutVsIn{ feature , 'p' } =  stats.p;


%% R amp

feature = 'Rpwr'; 
labels.ylabel = 'Ripple power';

[hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;
%%
[hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_OutVsIn{ feature , 'p' } =  stats.p;


%% R freq

feature = 'Rfreq'; 
labels.ylabel = 'Frequency, Hz';

[hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;

[hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_OutVsIn{ feature , 'p' } =  stats.p;



%% R duration

feature = 'Rlength_ms'; 
labels.ylabel = 'Ripple duration, ms';

[hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;

[hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_OutVsIn{ feature , 'p' } =  stats.p;

%% R in IEDs
feature = 'RinIEDs';
labels.ylabel = '% ripples in IEDs';

stats = plotDotBoxplot_CXvsTREAT(TsubRes,feature,labels,plt.w,plt.h/2);
printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;


[hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_OutVsIn{ feature , 'p' } =  stats.p;
%% FR in Rs
feature = 'FRinRFRs';
labels.ylabel = '% fast ripples in ripples';

stats = plotDotBoxplot_CXvsTREAT(TsubRes,feature,labels,plt.w,plt.h/2);
printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;


[hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_OutVsIn{ feature , 'p' } =  stats.p;

%% IED MED
feature = 'IEDmed';
labels.ylabel = 'Median of IED, mV';

stats = plotDotBoxplot_CXvsTREAT(TsubRes,feature,labels,plt.w,plt.h/2);
printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;


[hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);

lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
Tst_OutVsIn{ feature , 'p' } =  stats.p;


%% 5 Ripples  , IED with and without R  with  confidence

%figurefull;

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.HasR == true , : )    ) ;
confidenceshade( 1:5000 , ied-iedsems , ied+iedsems, Color = 'r' ); hold on; 
plot(ied,'r','LineWidth',1.2); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.HasR == false , : )    ) ;
confidenceshade( 1:5000 , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
plot(ied,'k','LineWidth',1.2); 

ylabel('Amplitude, mV');

legend({'IED with ripple','IED without ripple'});





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


function [hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,Tsub,feature,labels,w,h)

figurefull;
labels.xticklabel = {'Control','FCD'};

hu = subplot(2,1,1);

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
ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);

resize2cm(w,h);
%resize2tight();
%----------------------------------

hl = subplot(2,1,2);  hold on;
% plot per subject s boxplotem
stats = plotDotBoxplot_CXvsTREAT(Tsub,feature,labels,w,h);



end

function [hs,hb2] = plotDotBoxplot_CXvsTREAT(Tsub,feature,Tstats)
hold on;

% plot per subject s boxplotem
d = 0.2;
labels.xticklabel = {'Control','FCD'};
%xLabelsForStats = {'CTRL', 'TREAT'};

Tplot = Tsub(:,{'Subject','Role',feature});
Tplot.Role = cat2num(Tplot.Role,'CTRL',1+d,'TREAT',2+d);

hb2=boxchart(Tplot.Role,Tplot.(feature),'BoxFaceColor','k','LineWidth',1.2); hold on;
hb2.BoxWidth = 2*d;

% now lets add jitter
Tplot.Role = Tplot.Role -2*d;
x12Sig = sort( unique( Tplot.Role ) ); % x for sig line
hs = scatterbetter(Tplot,'Role',feature,'filled','ColorVariable','Subject' );
hs.SizeData=30;

hlbl = labelpoints (Tplot.Role, Tplot.(feature), Tsub.Number, 'SW', 0.15, 'FontSize', 7);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',labels.xticklabel);

ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);

Tstats{feature,'p'} =0.005;
plotsigline(  Tstats{feature,'p'}   , x12Sig, hb2.YData );

% resize2cm(w,h);
% %resize2tight();
% 
% % add statistics
% xVals = sort( unique( hb2.XData ) );
% 
% labelSelected = 'CTRL';
% data =  hb2.YData( hb2.XData == xVals(1)  ); data1 = data;
% stats.(labelSelected).meanmeasure =  printmeansem(  plt.barsMeanFun(data)  , nansem( data ) );
% labelSelected = 'TREAT';
% data =  hb2.YData( hb2.XData == xVals(2)  ); data2 = data;
% stats.(labelSelected).meanmeasure =  printmeansem(  plt.barsMeanFun(data)  , nansem( data ) );
% 
% %[x,y] = tablegroups2num(Tplot(:,{feature,'Role'}),'Role');
% 
% if (   any(~isnan(data1)) && any(~isnan(data2))    )
%         stats.p = ranksum( data1 , data2 ) ;  %sp = 0.01;  % plt.Tst_CtrVsTreat{ feature , 'p' }
%         plotsigline(  stats.p   , x12Sig, hb2.YData );
%           disp('Plotted stats')
% else
%     disp('Unable to do statistics');
%     stats.p = NaN;
% end


end




function [hs] = plotDot_OutvsIn(TsubRes_inout,feature,Tstats)  % only FCD animals
hold on;
labels.xticklabel = {'Outside','Inside'};

% only treatment animals
Tplot = TsubRes_inout( TsubRes_inout.Role == 'TREAT' , {'Subject','Number','InLesion',feature}); 
Tplot.InLesion = categorical(Tplot.InLesion);
Tplot.InLesion = cat2num(Tplot.InLesion,'false',2,'true',1);

hs = scatterbetter(Tplot,'InLesion',feature,'filled','ColorVariable','Subject' );
hlbl = labelpoints (Tplot.InLesion, Tplot.(feature), Tplot.Number, 'SW', 0.15, 'FontSize', 7);
%hs.XJitterWidth = 0.5;
%set(gca,'YLim',[-3.5 0]);
x12 = [1 2];
hp = plot(x12, [  Tplot(Tplot.InLesion==1,:).(feature)  Tplot(Tplot.InLesion==2,:).(feature)  ] , 'LineWidth', 2    );


set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',labels.xticklabel);
ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);

plotsigline(  Tstats{feature,'p'}   , x12, hs.YData );
end


function [h] = plotBox_OutvsIn(TsubRes_inout,feature,Tstats)
hold on;
labels.xticklabel = {'Outside','Inside'};

% only treatment animals
Tplot = TsubRes_inout( TsubRes_inout.Role == 'TREAT' , {'Subject','Number','InLesion',feature}); 
Tplot.InLesion = categorical(Tplot.InLesion);
Tplot.InLesion = cat2num(Tplot.InLesion,'false',2,'true',1);

h=boxchart(Tplot.InLesion,Tplot.(feature),'BoxFaceColor','k','LineWidth',1.2);

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',labels.xticklabel);

ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);
x12 = [1 2];
plotsigline(  Tstats{feature,'p'}   , x12, h.YData );

%resize2tight();


% %% Stats
% 
% labelSelected = 'Outside';
% data =  hb2.YData( hb2.XData == find(ismember(labels.xticklabel, labelSelected  ))  ); data1 = data;
% stats.(labelSelected).meanmeasure = printmeansem(  plt.barsMeanFun(data)  , nansem( data ) );
% 
% labelSelected = 'Inside';
% data =  hb2.YData( hb2.XData == find(ismember(labels.xticklabel, labelSelected  ))  ); data2 = data;
% stats.(labelSelected).meanmeasure = printmeansem(  plt.barsMeanFun(data)  , nansem( data ) );
% 
% if (   any(~isnan(data1)) && any(~isnan(data2))    )
%         stats.p = signrank( data1 , data2 ); % stats.p =0.01;
%         axes(hu)
%         plotsigline(  stats.p   , [1 2], hb2.YData ); % x12Sig = sort( unique( Tplot.Role ) ); % x for sig line
%         axes(hl)
%         plotsigline(  stats.p   , [1 2], hb2.YData ); % x12Sig = sort( unique( Tplot.Role ) ); % x for sig line
%         disp('Plotted stats')
% else
%     disp('Unable to do statistics');
%     stats.p = NaN;
% end

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



