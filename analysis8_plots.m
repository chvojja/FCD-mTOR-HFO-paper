% On Subsampled
% selectedIdx = randpickpercent(1:size(Tiedf,1),20);
% Tiedf = Tiedf(selectedIdx,:);


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
ied = cropfill( Signal = ied, CropPercent = plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
% selectL = TpltSig_CtrlVsTreat.Role == 'CTRL' & TpltSig_CtrlVsTreat.InLesion;
% ied = TpltSig_CtrlVsTreat.ied( selectL );
% iedsems = TpltSig_CtrlVsTreat.iedsems( selectL );

confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'r' ); hold on; 
hp1 = plot( 1000*s2t(ied,fs),ied,'r','LineWidth',linewidth); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'CTRL', :)    ,   Tiedf( Tiedf.InLesion == false , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
hp2 = plot( 1000*s2t(ied,fs),ied,'k','LineWidth',linewidth); 

xlabel('time, ms')
ylabel('amplitude, mV');
legend([hp1 hp2],'Lesion', 'Outside');
title('Controls');


%sp(2) = subplot(2,6,[4 5 6]);
axes(sp(2));

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.InLesion == true , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'r' ); hold on; 
hp1 = plot( 1000*s2t(ied,fs) , ied,'r','LineWidth',linewidth); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.InLesion == false , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
hp2 = plot( 1000*s2t(ied,fs), ied,'k','LineWidth',linewidth); 

xlabel(plt.labeltimems);
%ylabel('Amplitude, mV');
%legend([hp1 hp2],'Lesion', 'Outside');
title('FCD');

%
% IED rate

% pcka a tabulku spocitat jinde a tady jen kreslit
% p lajnu vykreslit az nakonec

feature = 'rateIED_min';
labels.ylabel = 'IED rate, event/min.';

axes(sp(3));
[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(labels.ylabel);

axes(sp(4));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);

axes(sp(5));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);

%resize2tight();
setall('LineWidth',0.5,'FontSize',plt.FontSize);
savefig( a.pwd([ ' Fig3.fig']) );
printpaper(  a.pwd([ ' Fig3.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);


%% Fig 4 

figurefull;
sp(1) = subplot(2,6,[1 2]);  % This has to be drawn first to be able to draw significant line exactly :((
sp(2) = subplot(2,6,[3 4]);
sp(3) = subplot(2,6,[5 6]);
sp(4) = subplot(2,6,[7 8]);
sp(5) = subplot(2,6,[9 10 11 12]);
% pause(0.5);
drawnow;
resize2cm(plt.w,plt.h);


lw = 1;

% PSD plots
axes(sp(1)); % Mean PSDs

group = 'CTRL';
[pwelch_mean , pwelch_sems, pwelch_f] = getPWELCHmeansems(TsubRes, group);
hp1 = plot(pwelch_f+1,pwelch_mean,'Color',plt.colors.( group  )  ,'LineWidth', lw );  hold on;
hs1 = confidenceshade( pwelch_f+1 , pwelch_mean - pwelch_sems , pwelch_mean + pwelch_sems, Color='k' );
%set(gca, 'XScale', 'log', 'YScale','log');

group = 'TREAT';
[pwelch_mean , pwelch_sems, pwelch_f] = getPWELCHmeansems(TsubRes, group);
hp2 = plot(pwelch_f+1,pwelch_mean,'Color',plt.colors.( group  )  ,'LineWidth', lw ); hold on;
hs2 = confidenceshade( pwelch_f+1 , pwelch_mean - pwelch_sems , pwelch_mean + pwelch_sems, Color='r' );

formatAsPSDplot();
ylabel('PSD');
legend([hp1 hp2],{'Control', 'FCD'},'Location','southwest');
title('All');
hold off;

% set(gca, 'XScale', 'log', 'YScale','log');
% grid
% 

% legend({'Control', 'FCD'});
% ylim([10^-9 10^-2]);
% xlabel('Frequency, Hz');
% ylabel('PSD');
% hold off;


axes(sp(2)); % Individual plots

group = 'CTRL';
rows_for_group = find( TsubRes.Role ==  group );
for i = rows_for_group'
    pwelch_y = TsubRes.IEDpwelch{i};
    pwelch_f = TsubRes.IEDfwelch{i};

    plot(pwelch_f+1,pwelch_y,'Color',plt.colors.( group  )  ,'LineWidth', lw ); hold on;
    
end
formatAsPSDplot();
yticklabels({});
title('Control');


axes(sp(3)); % Individual plots

group = 'TREAT';
rows_for_group = find( TsubRes.Role ==  group );
for i = rows_for_group'
    pwelch_y = TsubRes.IEDpwelch{i};
    pwelch_f = TsubRes.IEDfwelch{i};

    plot(pwelch_f+1,pwelch_y,'Color',plt.colors.( group  )  ,'LineWidth', lw ); hold on;

end
formatAsPSDplot();
yticklabels({});
title('FCD');
%

% Pie Graph
axes(sp(4)); 
T = TsubRes(TsubRes.Role=='TREAT',:);  % Only Treatments
NiedsTotal = sum(T.Nieds);
%
countsOnlyIEDsNoRsNoFRs =  T.Nieds - (T.NRs+T.NFRs-T.NFRswithRs)  ;
countsOnlyRs = T.NRs-T.NFRswithRs;
countsOnlyRFRs = T.NFRswithRs;
countsOnlyFRs = T.NFRs-T.NFRswithRs;

pieData(1) = sum(countsOnlyIEDsNoRsNoFRs) / NiedsTotal ;
pieData(2) = sum(countsOnlyRs) / NiedsTotal;
pieData(3) = sum(countsOnlyRFRs) / NiedsTotal;
pieData(4) = sum(countsOnlyFRs) / NiedsTotal;
labelsDetTypes = {'IED','R',['FR+R'],'FR'};
for i=1:numel(labelsDetTypes )
    labelsPerc{i} = [sprintf('%s (%.1f%%)', labelsDetTypes {i}, 100*pieData(i))   ];     
end

pieHandle = pie(pieData,labelsPerc);
colors = favouritecolors({'epipink','halflife','yellow','red'});
posLabel = 0.13+[0.6 1.1 1.45 1.2];
for iHandle = 2:2:2*numel(labelsPerc)
    pieHandle(iHandle-1).FaceColor=colors(iHandle/2,:);
    pieHandle(iHandle).Position = posLabel(iHandle/2)*pieHandle(iHandle).Position;
end
% rotate
ax = gca;
ax.View = [180 90];
title(['FCD animals, ' newline ' pooled together']);


% counts as boxplots per count type;
axes(sp(5)); 

% only treatment animals
Tplot = TsubRes_inout( TsubRes_inout.Role == 'TREAT' , {'Subject','Number','InLesion',feature}); 
Tplot.InLesion = categorical(Tplot.InLesion);
Tplot.InLesion = cat2num(Tplot.InLesion,'false',2,'true',1);

percentsEachAnimal = 100*[countsOnlyIEDsNoRsNoFRs countsOnlyRs countsOnlyFRs  countsOnlyRFRs ]./T.Nieds;

yyaxis left
barsData = [percentsEachAnimal(:,1:end) 100*countsOnlyRFRs./(countsOnlyRFRs+countsOnlyFRs) ];
barsData(:,2:end) = NaN;
hbcounts1=boxchart( barsData ,'BoxFaceColor','k','LineWidth',1.2);
ax= gca; ax.YAxis(1).Color= favouritecolors('epipink');
hbcounts1(1).BoxFaceColor = favouritecolors('epipink');
ylabel('IED, %');

yyaxis right
barsData = [percentsEachAnimal(:,1:end) 100*countsOnlyRFRs./(countsOnlyRFRs+countsOnlyFRs) ];
barsData(:,1) = NaN;
hbcounts2=boxchart( barsData ,'BoxFaceColor','k','LineWidth',1.2);
hbcounts2(1).MarkerColor = [0 0 0];
ax= gca; ax.YAxis(2).Color= favouritecolors('halflife');
hbcounts2(1).BoxFaceColor = favouritecolors('halflife');
ylabel('HFO, %');

NdetTypes = numel( labelsDetTypes );
set(gca,'xticklabel', [labelsDetTypes([1 2 4 ])  { 'FR+R' 'R/FR' } ] );

setall('LineWidth',0.5,'FontSize',plt.FontSize);

savefig( a.pwd([ ' Fig4.fig']) );
printpaper(  a.pwd([ ' Fig4.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);



%% Fig 5 Ripples
figurefull;
% This has to be drawn first to be able to draw significant line exactly :((
sp(1) = subplot(3,4,1);  
sp(2) = subplot(3,4,2); 
sp(3) = subplot(3,4,3); 
sp(4) = subplot(3,4,4); 
sp(5) = subplot(3,4,5); 
sp(6) = subplot(3,4,6); 
sp(7) = subplot(3,4,7);  
sp(8) = subplot(3,4,8); 
sp(9) = subplot(3,4,9); 
sp(10) = subplot(3,4,10); 
sp(11) = subplot(3,4,11); 
sp(12) = subplot(3,4,12); 
drawnow;
resize2cm(plt.w,plt.h);


axes(sp(1));

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasR == true , : )    ) ;
ied = cropfill( Signal = ied, CropPercent = plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'r' ); hold on; 
hp1 = plot( 1000*s2t(ied,fs),ied,'r','LineWidth',linewidth); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.HasR == false , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
hp2 = plot( 1000*s2t(ied,fs),ied,'k','LineWidth',linewidth); 

xlabel(plt.labeltimems)
ylabel('amplitude, mV');
legend([hp1 hp2],'IED+R', 'IED-R', 'Location','southwest');
title('Mean IED w/wo ripple');

axes(sp(2));
labels =[];
feature = 'rateR_min';
[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(plt.labelrateMin);
set(gca,'YLim',[-0.2 1.2]);

axes(sp(3));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
set(gca,'YLim',[-0.2 1.2]);
set(gca,'YTick', []);

axes(sp(4));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
set(gca,'YLim',[-0.2 1.2]);
set(gca,'YTick', []);


axes(sp(5));
feature = 'Rfreq';
[hs] = plotSwarm_CXvsTREAT(Tiedf,feature);
ylabel(plt.labelfreqHz);
set(gca,'YLim',[30 150]);

axes(sp(6));
[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
set(gca,'YLim',[50 100]);

axes(sp(7));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
set(gca,'YLim',[50 100]);
set(gca,'YTick', []);

axes(sp(8));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
set(gca,'YLim',[50 100]);
set(gca,'YTick', []);

labels =[];
feature = 'RtoIEDrateShare';
feature = 'RinIEDs';

axes(sp(9));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel('R/IED rate share, %');

axes(sp(10));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);


% R plot histogram of oscillations
feature = 'RpeaksCount';

axes(sp(11));
Tplot = TsubRes_inout(TsubRes_inout.Role == 'TREAT' & TsubRes_inout.InLesion == true, :);
plotHistCount(Tplot ,feature);
ylabel('share, %');
title('Inside');


axes(sp(12));
Tplot = TsubRes_inout(TsubRes_inout.Role == 'TREAT' & TsubRes_inout.InLesion == false, :);
plotHistCount(Tplot ,feature);
title('Outside');


setall('LineWidth',0.5,'FontSize',plt.FontSize);

savefig( a.pwd([ ' Fig5.fig']) );
printpaper(  a.pwd([ ' Fig5.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);


%% Fig 6 Fast ripples
figurefull;
% This has to be drawn first to be able to draw significant line exactly :((
sp(1) = subplot(3,4,1);  
sp(2) = subplot(3,4,2); 
sp(3) = subplot(3,4,3); 
sp(4) = subplot(3,4,4); 
sp(5) = subplot(3,4,5); 
sp(6) = subplot(3,4,6); 
sp(7) = subplot(3,4,7);  
sp(8) = subplot(3,4,8); 
sp(9) = subplot(3,4,9); 
sp(10) = subplot(3,4,10); 
sp(11) = subplot(3,4,11); 
sp(12) = subplot(3,4,12); 
drawnow;
resize2cm(plt.w,plt.h);


axes(sp(1));

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasFR == true , : )    ) ;
ied = cropfill( Signal = ied, CropPercent = plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'r' ); hold on; 
hp1 = plot( 1000*s2t(ied,fs),ied,'r','LineWidth',linewidth); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.HasFR == false , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
hp2 = plot( 1000*s2t(ied,fs),ied,'k','LineWidth',linewidth); 

xlabel(plt.labeltimems)
ylabel('amplitude, mV');
legend([hp1 hp2],'IED+FR', 'IED-FR', 'Location','southwest');
title('Mean IED w/wo FR');

axes(sp(2));
feature = 'rateFR_min';

[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(plt.labelrateMin);
%set(gca,'YLim',[-0.2 1.2]);

axes(sp(3));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
%set(gca,'YLim',[-0.2 1.2]);
set(gca,'YTick', []);

axes(sp(4));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
%set(gca,'YLim',[-0.2 1.6]);
set(gca,'YTick', []);


axes(sp(5));
feature = 'FRfreq';
[hs] = plotSwarm_CXvsTREAT(Tiedf,feature);
ylabel(plt.labelfreqHz);
set(gca,'YLim',[100 700]);

axes(sp(6));
[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
set(gca,'YLim',[350 650]);

axes(sp(7));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
set(gca,'YLim',[350 650]);
set(gca,'YTick', []);

axes(sp(8));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
set(gca,'YLim',[350 650]);
set(gca,'YTick', []);

labels =[];
feature = 'FRtoIEDrateShare';
feature = 'FRinRFRs';

axes(sp(9));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel('FR/IED rate share, %');

axes(sp(10));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);


% FR plot histogram of oscillations
feature = 'FRpeaksCount';

axes(sp(11));
Tplot = TsubRes_inout(TsubRes_inout.Role == 'TREAT' & TsubRes_inout.InLesion == true, :);
plotHistCount(Tplot ,feature);
ylabel('share, %');
title('Inside');


axes(sp(12));
Tplot = TsubRes_inout(TsubRes_inout.Role == 'TREAT' & TsubRes_inout.InLesion == false, :);
plotHistCount(Tplot ,feature);
title('Outside');


setall('LineWidth',0.5,'FontSize',plt.FontSize);

savefig( a.pwd([ ' Fig6.fig']) );
printpaper(  a.pwd([ ' Fig6.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);


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

% %% 
% 
% 
% Tst_CtrlVsTreat = table;
% Tst_OutVsIn = table;
% %% IED Skewness
% 
% feature = 'IEDskew'; 
% labels.ylabel = 'Skewness, [-]';
% 
% [hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
% set(hu,'YLim',[-8 6]);
% printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;
% 
% [hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
% printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_OutVsIn{ feature , 'p' } =  stats.p;
% 
% 
% 
% %% IED ampl
% 
% feature = 'IEDampl_mV'; 
% labels.ylabel = 'IED amplitude, mV';
% 
% [hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
% printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;
% 
% [hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
% printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_OutVsIn{ feature , 'p' } =  stats.p;
% 
% 
% %% IED width
% 
% 
% feature = 'IEDwidth_msec'; 
% labels.ylabel = 'IED width, ms';
% 
% [hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
% printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;
% 
% [hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
% printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_OutVsIn{ feature , 'p' } =  stats.p;
% 
% 
% %% R rate   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% smaller size
% feature = 'rateR_min';
% labels.ylabel = 'Ripple rate, event/min.';
% 
% stats = plotDotBoxplot_CXvsTREAT(TsubRes,feature,labels,plt.w,plt.h/2);
% printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;
% 
% 
% [hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
% printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_OutVsIn{ feature , 'p' } =  stats.p;
% 
% 
% %% R amp
% 
% feature = 'Rpwr'; 
% labels.ylabel = 'Ripple power';
% 
% [hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
% printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;
% %%
% [hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
% printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_OutVsIn{ feature , 'p' } =  stats.p;
% 
% 
% %% R freq
% 
% feature = 'Rfreq'; 
% labels.ylabel = 'Frequency, Hz';
% 
% [hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
% printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;
% 
% [hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
% printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_OutVsIn{ feature , 'p' } =  stats.p;
% 
% 
% 
% %% R duration
% 
% feature = 'Rlength_ms'; 
% labels.ylabel = 'Ripple duration, ms';
% 
% [hu,hl,stats] = plotUpperLower_CXvsTREAT(Tiedf,TsubRes,feature,labels,plt.w,plt.h);
% printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;
% 
% [hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
% printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_OutVsIn{ feature , 'p' } =  stats.p;
% 
% %% R in IEDs
% feature = 'RinIEDs';
% labels.ylabel = '% ripples in IEDs';
% 
% stats = plotDotBoxplot_CXvsTREAT(TsubRes,feature,labels,plt.w,plt.h/2);
% printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;
% 
% 
% [hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
% printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_OutVsIn{ feature , 'p' } =  stats.p;
% %% FR in Rs
% feature = 'FRinRFRs';
% labels.ylabel = '% fast ripples in ripples';
% 
% stats = plotDotBoxplot_CXvsTREAT(TsubRes,feature,labels,plt.w,plt.h/2);
% printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;
% 
% 
% [hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
% printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_OutVsIn{ feature , 'p' } =  stats.p;
% 
% %% IED MED
% feature = 'IEDmed';
% labels.ylabel = 'Median of IED, mV';
% 
% stats = plotDotBoxplot_CXvsTREAT(TsubRes,feature,labels,plt.w,plt.h/2);
% printpaper(  a.pwd([ picIdentifier feature '1.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'CTRL';  Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'TREAT'; Tst_CtrlVsTreat( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_CtrlVsTreat{ feature , 'p' } =  stats.p;
% 
% 
% [hu,hl,stats] = plotUpperLower_OutvsIn(TsubRes_inout,feature,labels);
% printpaper(  a.pwd([ picIdentifier feature '2.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
% 
% lbl = 'Inside';  Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% lbl = 'Outside'; Tst_OutVsIn( feature , lbl ) =  { stats.(lbl).meanmeasure  };
% Tst_OutVsIn{ feature , 'p' } =  stats.p;


%% 5 Ripples  , IED with and without R  with  confidence

% %figurefull;
% 
% [ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.HasR == true , : )    ) ;
% confidenceshade( 1:5000 , ied-iedsems , ied+iedsems, Color = 'r' ); hold on; 
% plot(ied,'r','LineWidth',1.2); 
% 
% [ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.HasR == false , : )    ) ;
% confidenceshade( 1:5000 , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
% plot(ied,'k','LineWidth',1.2); 
% 
% ylabel('Amplitude, mV');
% 
% legend({'IED with ripple','IED without ripple'});
% 
% 
% 


function plotHistCount(TwithPeakCounts,feature)

hold on
peakcounts =  cell2mat(  TwithPeakCounts.(feature)  );
meanIED = sum(cell2mat(TwithPeakCounts.meanIED),1);

NbinsOnseSide = 20;
NsOneBin = 20;
fs = 5000;

peakcountsBinedProbabilityPerSubjC = cell(size(peakcounts,1),1);
for i = 1: size(peakcounts,1)
    %[c,b,Nb,sI,eI] = binPeakCounts(peakcounts_subjects(i,:),NbinsOnseSide); [counts,groups_bins,Nb] = binPeakCounts(peakcounts,NbinsOnseSide)
    Nframe = 5000;
    NOneSide = NsOneBin * NbinsOnseSide;
    sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
    peakCountsCropped = peakcounts(i, sI : eI );
    groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
    counts = splitapply(@sum,peakCountsCropped,groups_bins);
    Nb=eI-sI+1;

    peakcountsBinedProbabilityPerSubjC{i} = 100*counts/sum(counts);
end



peakcountsBinedProbabilityPerSubj=cell2mat(peakcountsBinedProbabilityPerSubjC);
means = nanmean(peakcountsBinedProbabilityPerSubj);
sems = nansem( peakcountsBinedProbabilityPerSubj );

% rescale meanIED
meanIED = meanIED - max(meanIED);
meanIED = meanIED * max(means);
% plot

h1 = plot(s2t(meanIED(sI:eI),fs),meanIED(sI:eI)-2,'Color','k'); hold on;
xlabel(plt.labeltimems);
Nb=eI-sI+1;

maxTime = max(get(gca,'XLim'));
bar(  linspace(0,maxTime,NbinsOnseSide*2)    ,    means ,'k')  %max(ied_avg)


er = errorbar( linspace(0,maxTime,NbinsOnseSide*2) ,  means  ,sems,sems);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  

set(gca,'YLim', [min(meanIED) max(means+sems)]);
ylimoptimal(PercentMargin = 0.05);

yt = get(gca,'yticklabels');
ytNum = cellstr2num(yt);
yt(ytNum<0)={' '};
set(gca,'yticklabels',yt);


end



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



function [hs] = plotSwarm_CXvsTREAT(Tiedf,feature)
hold on;
% plot pooled scatter
Tplot = Tiedf(:,{'Subject','Role',feature});
Tplot.Role = cat2num(Tplot.Role,'CTRL',1,'TREAT',2);
hs = swarmchartbetter(Tplot,'Role',feature,'filled','ColorVariable','Subject' );
hs.XJitterWidth = 0.5;

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel', plt.xticklabelCTRLTREAT);

ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);

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

%Tstats{feature,'p'} =0.005;
plotsigline(  Tstats{feature,'p'}   , x12Sig, hb2.YData );

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
h(1).MarkerColor = [0 0 0];

set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',labels.xticklabel);

ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);
x12 = [1 2];
plotsigline(  Tstats{feature,'p'}   , x12, h.YData );

%resize2tight();


end

