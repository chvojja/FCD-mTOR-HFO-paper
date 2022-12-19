% On Subsampled
% selectedIdx = randpickpercent(1:size(Tiedf,1),20);
% Tiedf = Tiedf(selectedIdx,:);

fs = 5000;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3 - IED plots

% IED traces


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
hp1 = plot( 1000*s2t(ied,fs),ied,'r','LineWidth', plt.LineWidthBox ); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'CTRL', :)    ,   Tiedf( Tiedf.InLesion == false , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
hp2 = plot( 1000*s2t(ied,fs),ied,'k','LineWidth', plt.LineWidthBox ); 

xlabel(plt.labeltimems);
ylabel(plt.labelamplitudemv);
legend([hp1 hp2],'Lesion', 'Outside', 'Location','southwest');
title('Controls');


%sp(2) = subplot(2,6,[4 5 6]);
axes(sp(2));

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.InLesion == true , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'r' ); hold on; 
hp1 = plot( 1000*s2t(ied,fs) , ied,'r','LineWidth', plt.LineWidthBox ); 

[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.InLesion == false , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
hp2 = plot( 1000*s2t(ied,fs), ied,'k','LineWidth', plt.LineWidthBox  ); 

xlabel(plt.labeltimems);
ylabel(plt.labelamplitudemv);
%legend([hp1 hp2],'Lesion', 'Outside');
title('FCD');

%
% IED rate

% pcka a tabulku spocitat jinde a tady jen kreslit
% p lajnu vykreslit az nakonec

feature = 'rateIED_min';

axes(sp(3));
[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(plt.labelrateMin);

axes(sp(4));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel(plt.labelrateMin);

axes(sp(5));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel(plt.labelrateMin);

%resize2tight();
%setall('LineWidth',0.5,'FontSize',plt.FontSize);
if plt.savefigs_b
savefig( a.pwd([ ' Fig3.fig']) );
printpaper(  a.pwd([ ' Fig3.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
end

%% Fig 4 
% T = TsubRes;
% T = TsubRes_inout;
% 
% selectInd = find(T.Subject == 'Naty602');
% 
% for i=1:numel(selectInd)
%     T.IEDpwelch{selectInd(i)} = T.IEDpwelch{selectInd(i)}';
%     T.IEDfwelch{selectInd(i)} = T.IEDfwelch{selectInd(i)}';
% end
% TsubRes_inout = T;
% TsubRes = T;




figurefull;
sp(1) = subplot(2,6,[1 2]);  % This has to be drawn first to be able to draw significant line exactly :((
sp(2) = subplot(2,6,[3 4]);
sp(3) = subplot(2,6,[5 6]);
sp(4) = subplot(2,6,[7 8]);
sp(5) = subplot(2,6,[9 10 11 12]);
% pause(0.5);
drawnow;
resize2cm(plt.w,plt.h);


lw = plt.LineWidthBox ;

% PSD plots
axes(sp(1)); % Mean PSDs
plt.formatSpecial1;

group = 'CTRL';
[pwelch_mean , pwelch_sems, pwelch_f] = getPWELCHmeansems(TsubRes, group);
hp1 = plot(pwelch_f+1,pwelch_mean,'Color',plt.colors.( group  )  ,'LineWidth', lw );  hold on;
hs1 = confidenceshade( pwelch_f+1 , pwelch_mean - pwelch_sems , pwelch_mean + pwelch_sems, Color='k' );
%set(gca, 'XScale', 'log', 'YScale','log');
% for diff graph
pwelch_mean_CTRL = pwelch_mean;
pwelch_sems_CTRL = pwelch_sems;

group = 'TREAT';
[pwelch_mean , pwelch_sems, pwelch_f] = getPWELCHmeansems(TsubRes, group);
hp2 = plot(pwelch_f+1,pwelch_mean,'Color',plt.colors.( group  )  ,'LineWidth', lw ); hold on;
hs2 = confidenceshade( pwelch_f+1 , pwelch_mean - pwelch_sems , pwelch_mean + pwelch_sems, Color='r' );
% for diff graph
pwelch_mean_TREAT = pwelch_mean;
pwelch_sems_TREAT = pwelch_sems;

% % for diff graph
% pwelch_mean_diff = pwelch_mean_TREAT-pwelch_mean_CTRL;
% pwelch_sems_diff = sqrt(pwelch_sems_TREAT.^2 + pwelch_sems_CTRL.^2 );


formatAsPSDplot();
ylabel('PSD, mV^2/Hz');
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
plt.formatSpecial1;
group = 'CTRL';
rows_for_group = find( TsubRes.Role ==  group );
for i = rows_for_group'
    pwelch_y = TsubRes.IEDpwelch{i};
    pwelch_f = TsubRes.IEDfwelch{i};

    plot(pwelch_f+1,pwelch_y,'Color',plt.colors.( group  )  ,'LineWidth', lw ); hold on;
    
end
formatAsPSDplot();
%yticklabels({});
ylabel('PSD, mV^2/Hz');
title('Control');


axes(sp(3)); % Individual plots
plt.formatSpecial1;
group = 'TREAT';
rows_for_group = find( TsubRes.Role ==  group );
for i = rows_for_group'
    pwelch_y = TsubRes.IEDpwelch{i};
    pwelch_f = TsubRes.IEDfwelch{i};

    plot(pwelch_f+1,pwelch_y,'Color',plt.colors.( group  )  ,'LineWidth', lw ); hold on;

end
formatAsPSDplot();
%yticklabels({});
ylabel('PSD, mV^2/Hz');
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
% Tplot = TsubRes_inout( TsubRes_inout.Role == 'TREAT' , {'Subject','Number','InLesion',feature}); 
Tplot = TsubRes_inout( TsubRes_inout.Role == 'TREAT' , {'Subject','Number','InLesion'}); 
Tplot.InLesion = categorical(Tplot.InLesion);
Tplot.InLesion = cat2num(Tplot.InLesion,'false',2,'true',1);

percentsEachAnimal = 100*[countsOnlyIEDsNoRsNoFRs countsOnlyRs countsOnlyFRs  countsOnlyRFRs ]./T.Nieds;

yyaxis left
barsData = [percentsEachAnimal(:,1:end) 100*countsOnlyRFRs./(countsOnlyRFRs+countsOnlyFRs) ];
barsData(:,2:end) = NaN;
hbcounts1=boxchart( barsData ,'BoxFaceColor','k','LineWidth',plt.LineWidthBox);
ax= gca; ax.YAxis(1).Color= favouritecolors('epipink');
hbcounts1(1).BoxFaceColor = favouritecolors('epipink');
ylabel('IED, %');

yyaxis right
barsData = [percentsEachAnimal(:,1:end) 100*countsOnlyRFRs./(countsOnlyRFRs+countsOnlyFRs) ];
barsData(:,1) = NaN;
hbcounts2=boxchart( barsData ,'BoxFaceColor','k','LineWidth',plt.LineWidthBox);
hbcounts2(1).MarkerColor = [0 0 0];
ax= gca; ax.YAxis(2).Color= favouritecolors('halflife');
hbcounts2(1).BoxFaceColor = favouritecolors('halflife');
ylabel('HFO, %');

NdetTypes = numel( labelsDetTypes );
set(gca,'xticklabel', [labelsDetTypes([1 2 4 ])  { 'FR+R' 'R/FR' } ] );

%setall('LineWidth',0.5,'FontSize',plt.FontSize);
if plt.savefigs_b
savefig( a.pwd([ ' Fig4.fig']) );
printpaper(  a.pwd([ ' Fig4.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
end

%%
% difference or ratio plot


figurefull;
sp(1) = subplot(2,6,[1 2]);  % This has to be drawn first to be able to draw significant line exactly :((
 sp(2) = subplot(2,6,[3 4]); plot([0 1],[0 1]);
% sp(3) = subplot(2,6,[5 6]);
% sp(4) = subplot(2,6,[7 8]);
% sp(5) = subplot(2,6,[9 10 11 12]);
% pause(0.5);
drawnow;
resize2cm(plt.w,plt.h);

lw = plt.LineWidthBox ;

% PSD plot diff
axes(sp(1)); % Mean PSDs
plt.formatSpecial1;

%pwelch_mean_diff = abs(pwelch_mean_diff);
% 

pwelch_ratio_mean=(pwelch_mean_TREAT./pwelch_mean_CTRL);
pwelch_ratio_sem = pwelch_ratio_mean.*sqrt(  (pwelch_sems_TREAT./pwelch_mean_TREAT).^2 + (pwelch_sems_CTRL./pwelch_mean_CTRL).^2 );
% pwelch_ratio_sem = pwelch_ratio_mean.*sqrt(  (pwelch_sems_TREAT./pwelch_mean_TREAT).^2 + (pwelch_sems_CTRL./pwelch_mean_CTRL)^2  - 2*    );



% |A/B| * sqrt( (sA/A) ² + (sB/B)² )

hp_d = plot(pwelch_f+1,pwelch_ratio_mean,'Color',plt.colors.( group  )  ,'LineWidth', lw );  hold on;
% hp_d = plot(pwelch_f+1,pwelch_mean_diff,'Color',plt.colors.( group  )  ,'LineWidth', lw );  hold on;
% hs_d= confidenceshade( pwelch_f+1 , abs( pwelch_mean_diff - pwelch_sems_diff ) , abs( pwelch_mean_diff + pwelch_sems_diff ), Color='k' );
hs_d= confidenceshade( pwelch_f+1 ,  pwelch_ratio_mean - pwelch_ratio_sem  ,  pwelch_ratio_mean + pwelch_ratio_sem , Color='k' );

 set(gca, 'XScale', 'log', 'YScale','log');
%set(gca,'YScale','log');
%grid on
% ylim([10^-9 10^-2]);
 ylim([0 4]);
 xlim([1 2*10^3]);
xlabel('Frequency, Hz');

ylabel('PSD FCD/CTRL ratio [-]');


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

%[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasR == true , : )    ) ;
ied = stats.meanIEDshapes.withRipple.ied;
iedsems = stats.meanIEDshapes.withRipple.iedsems;
ied = cropfill( Signal = ied, CropPercent = plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'r' ); hold on; 
hp1 = plot( 1000*s2t(ied,fs),ied,'r','LineWidth',plt.LineWidthThicker); 

ied = stats.meanIEDshapes.noRipple.ied;
iedsems = stats.meanIEDshapes.noRipple.iedsems;
%[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.HasR == false , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
hp2 = plot( 1000*s2t(ied,fs),ied,'k','LineWidth',plt.LineWidthThicker); 

xlabel(plt.labeltimems)
ylabel('amplitude, mV');
legend([hp1 hp2],'IED+R', 'IED-R', 'Location','southwest');
title('Mean IED w/wo ripple');

axes(sp(2));
labels =[];
feature = 'rateR_min';
[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(plt.labelrateMin);
%set(gca,'YLim', plt.YLimRippleRate );
ylimfromzero();

axes(sp(3));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel(plt.labelrateMin);
%set(gca,'YLim', plt.YLimRippleRate);
ylimfromzero();
%set(gca,'YTick', []);

axes(sp(4));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel(plt.labelrateMin);
%set(gca,'YLim', plt.YLimRippleRate );
ylimfromzero();
%set(gca,'YTick', []);


axes(sp(5));
feature = 'Rfreq';
[hs] = plotSwarm_CXvsTREAT(Tiedf,feature);
ylabel(plt.labelfreqHz);
set(gca,'YLim', plt.YLimRippleFreq );

axes(sp(6));
[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(plt.labelfreqHz);
set(gca,'YLim',  plt.YLimRippleFreq  );

axes(sp(7));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel(plt.labelfreqHz);
set(gca,'YLim',  plt.YLimRippleFreq  );
%set(gca,'YTick', []);

axes(sp(8));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel(plt.labelfreqHz);
set(gca,'YLim',  plt.YLimRippleFreq  );
%set(gca,'YTick', []);


feature = 'RtoIEDrateShare';
%feature = 'RinIEDs';

axes(sp(9));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel('R/IED rate share, %');
ylimfromzero();

axes(sp(10));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel('R/IED rate share, %');
ylimfromzero();

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
ylabel('share, %');
title('Outside');


%setall('LineWidth',0.5,'FontSize',plt.FontSize);
%%
if plt.savefigs_b
savefig( a.pwd([ ' Fig5.fig']) );

printpaper(  a.pwd([ ' Fig5.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
end

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

ied = stats.meanIEDshapes.withFRipple.ied;
iedsems = stats.meanIEDshapes.withFRipple.iedsems;
%[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT' , :)    ,   Tiedf( Tiedf.HasFR == true , : )    ) ;
ied = cropfill( Signal = ied, CropPercent = plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'r' ); hold on; 
hp1 = plot( 1000*s2t(ied,fs),ied,'r','LineWidth',plt.LineWidthThicker); 

ied = stats.meanIEDshapes.noFRipple.ied;
iedsems = stats.meanIEDshapes.noFRipple.iedsems;
%[ied, iedsems] =  getIEDmeansems(    TsubRes( TsubRes.Role == 'TREAT', :)    ,   Tiedf( Tiedf.HasFR == false , : )    ) ;
ied = cropfill( Signal = ied, CropPercent =  plt.IedCropPercent ); iedsems = cropfill( Signal = iedsems, CropPercent =  plt.IedCropPercent );
confidenceshade( 1000*s2t(ied,fs) , ied-iedsems , ied+iedsems, Color = 'k' ); hold on; 
hp2 = plot( 1000*s2t(ied,fs),ied,'k','LineWidth',plt.LineWidthThicker); 

xlabel(plt.labeltimems)
ylabel('amplitude, mV');
legend([hp1 hp2],'IED+FR', 'IED-FR', 'Location','southwest');
title('Mean IED w/wo FR');


axes(sp(2));
feature = 'rateFR_min';

[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(plt.labelrateMin);
ylimfromzero();
%set(gca,'YLim',[-0.2 1.2]);

axes(sp(3));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel(plt.labelrateMin);
ylimfromzero();
%set(gca,'YLim',[-0.2 1.2]);
%set(gca,'YTick', []);


axes(sp(4));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel(plt.labelrateMin);
ylimfromzero();
%set(gca,'YLim',[-0.2 1.6]);
%set(gca,'YTick', []);


axes(sp(5));
feature = 'FRfreq';
[hs] = plotSwarm_CXvsTREAT(Tiedf,feature);
ylabel(plt.labelfreqHz);
set(gca,'YLim', plt.YLimFRippleFreq );


axes(sp(6));
[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(plt.labelfreqHz);
set(gca,'YLim', plt.YLimFRippleFreq );

axes(sp(7));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel(plt.labelfreqHz);
set(gca,'YLim', plt.YLimFRippleFreq );
%set(gca,'YTick', []);

axes(sp(8));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel(plt.labelfreqHz);
set(gca,'YLim', plt.YLimFRippleFreq );
%set(gca,'YTick', []);

labels =[];
feature = 'FRtoIEDrateShare';
%feature = 'FRinRFRs';

axes(sp(9));
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel('FR/IED rate share, %');
ylimfromzero();

axes(sp(10));
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylimfromzero();

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
ylabel('share, %');
title('Outside');

%%

%setall('LineWidth',0.5,'FontSize',plt.FontSize);
if plt.savefigs_b
savefig( a.pwd([ ' Fig6.fig']) );
printpaper(  a.pwd([ ' Fig6.' plt.formatExt])   , dpi = plt.dpi, close = plt.closeFigs);
end



function plotHistCount(TwithPeakCounts,feature)

hold on
peakcounts =  cell2mat(  TwithPeakCounts.(feature)  );
meanIED = sum(cell2mat(TwithPeakCounts.meanIED),1);

if ~isempty(peakcounts)
    NbinsOnseSide = 6;
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
    
    h1 = plot(1000*s2t(meanIED(sI:eI),fs),meanIED(sI:eI)-2,'Color','k'); hold on;
    xlabel(plt.labeltimems);
    Nb=eI-sI+1;
    
    maxTime = max(get(gca,'XLim'));
    bar(  linspace(0,maxTime,NbinsOnseSide*2)    ,    means ,'k')  %max(ied_avg)
    
    
    er = errorbar( linspace(0,maxTime,NbinsOnseSide*2) ,  means  ,sems,sems);    
    %er.Color = [0 0 0];    
    %er.LineStyle = 'none'; 
    [er(:).Color] = deal([0 0 0 ]);
    [er(:).LineStyle] = deal('none');
    
    
    box on
    set(gca,'YLim', [min(meanIED) max(means+sems)]);
    ylimoptimal(PercentMargin = 0.05);
    
    yt = get(gca,'yticklabels');
    ytNum = cellstr2num(yt);
    yt(ytNum<0)={' '};
    set(gca,'yticklabels',yt);
end

end



% function [counts,groups_bins,Nb] = binPeakCounts(peakcounts,NbinsOnseSide)
% 
% Nframe = 5000;
% NOneSide = NsOneBin * NbinsOnseSide;
% sI = Nframe/2 -NOneSide; eI = Nframe/2 + NOneSide  -1;
% peakCountsCropped = peakcounts( sI : eI );
% groups_bins = repelem(1:2*NbinsOnseSide,NsOneBin);
% counts = splitapply(@sum,peakCountsCropped,groups_bins);
% Nb=eI-sI+1;
% end


function [hs] = plotSwarm_CXvsTREAT(Tiedf,feature)
hold on;
% plot pooled scatter
Tplot = Tiedf(:,{'Subject','Role',feature});
Tplot.Role = cat2num(Tplot.Role,'CTRL',1,'TREAT',2);
hs = swarmchartbetter(Tplot,'Role',feature,'filled','ColorVariable','Subject' );
hs.XJitterWidth = 0.5;

box on
set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel', plt.xticklabelCTRLTREAT);

ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);

end



function [hs,hb2] = plotDotBoxplot_CXvsTREAT(Tsub,feature,Tstats)
hold on;

% plot per subject s boxplotem
d = 0.2;

Tplot = Tsub(:,{'Subject','Role',feature});
Tplot.Role = cat2num(Tplot.Role,'CTRL',1+d,'TREAT',2+d);

hb2=boxchart(Tplot.Role,Tplot.(feature),'BoxFaceColor','k','LineWidth',plt.LineWidthBox); hold on;
hb2.BoxWidth = 2*d;
hb2.MarkerColor = [0 0 0];

% now lets add jitter
Tplot.Role = Tplot.Role -2*d;
x12Sig = sort( unique( Tplot.Role ) ); % x for sig line
hs = scatterbetter(Tplot,'Role',feature,'filled','ColorVariable','Role' );
colormap([ plt.colors.CTRL; plt.colors.TREAT] );
hs.SizeData=30;

%hlbl = labelpoints (Tplot.Role, Tplot.(feature), Tsub.Number, 'SW', 0.15, 'FontSize', 7);

box on
set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel', plt.xticklabelCTRLTREAT );

ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);

%Tstats{feature,'p'} =0.005;
plotsigline(  Tstats{feature,'p'}   , x12Sig, hb2.YData );

end




function [hs] = plotDot_OutvsIn(TsubRes_inout,feature,Tstats)  % only FCD animals
hold on;

% only treatment animals
Tplot = TsubRes_inout( TsubRes_inout.Role == 'TREAT' , {'Subject','Number','InLesion',feature}); 
Tplot.InLesion = categorical(Tplot.InLesion);
Tplot.InLesion = cat2num(Tplot.InLesion,'false',1,'true',2);

hs = scatterbetter(Tplot,'InLesion',feature,'filled','ColorVariable','InLesion');
colormap([ plt.colors.CTRL; plt.colors.TREAT] );
%hlbl = labelpoints (Tplot.InLesion, Tplot.(feature), Tplot.Number, 'SW', 0.15, 'FontSize', 7);
%hs.XJitterWidth = 0.5;
%set(gca,'YLim',[-3.5 0]);
x12 = [1 2];
hp = plot(x12, [  Tplot(Tplot.InLesion==1,:).(feature)  Tplot(Tplot.InLesion==2,:).(feature)  ] , 'LineWidth', 1, 'Color','k'    );

box on
set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',plt.xticklabelOutvsIn);
ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);

plotsigline(  Tstats{feature,'p'}   , x12, hs.YData );


end


function [h] = plotBox_OutvsIn(TsubRes_inout,feature,Tstats)
hold on;

% only treatment animals
Tplot = TsubRes_inout( TsubRes_inout.Role == 'TREAT' , {'Subject','Number','InLesion',feature}); 
Tplot.InLesion = categorical(Tplot.InLesion);
Tplot.InLesion = cat2num(Tplot.InLesion,'false',1,'true',2);

h=boxchart(Tplot.InLesion,Tplot.(feature),'BoxFaceColor','k','LineWidth',plt.LineWidthBox);
h(1).MarkerColor = [0 0 0];

box on
set(gca,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',plt.xticklabelOutvsIn);

ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);
x12 = [1 2];
plotsigline(  Tstats{feature,'p'}   , x12, h.YData );


%resize2tight();

end

