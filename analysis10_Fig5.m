
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fig 5. Gamma ripples
%----------------------------Prepare window----------------------------
figurefull;
% tiledlayout definition

row_widths_3columns=[4 4 4];
row_widths_lastRow = [2 4 4 2];
row_heights = [4 4 4 4];

% na prvni dobrou
h_subplot = @(m,n,p) subtightplot (m, n, p, [0.05658 0.0565], [0.081 0.051], [0.0998 0.0293]);
h_subplot = @(m,n,p) subtightplot (m, n, p, [0.05658 0.0565], [0.081 0.051], [0.0998 0.0293]);
%h_subplot = @(m,n,p) subtightplot (m, n, p, [0.12 0.0575], [0.099 0.051], [0.0998 0.0293]);
%ax_layout
% [hax] = layoutaxesrows(h_subplot,row_heights,row_widths_3columns,row_widths_3columns,row_widths_3columns,row_widths_lastRow);
[hax] = layoutaxesrows(h_subplot,row_heights,row_widths_3columns,row_widths_3columns,row_widths_3columns,row_widths_lastRow);

drawnow;
%--------------------------Position to centimeters--------------------------
resize2cm(9.5,14); % paper size on figure but axes are still on auto mode
previous_units_C = axesunits(hax,'centimeters');
resizeaxes_center(hax(1:9),[plt.w_square_boxplot plt.w_square_boxplot]);
resizeaxes_center(hax([11 12]),[plt.w_square_boxplot plt.w_square_boxplot]);
hideaxis(hax(10));
hideaxis(hax(13));
axesunits(hax,previous_units_C);

%----------------------------Plotting of individual axes----------------------------
ha = hax(1);
axes(ha); hold on;
feature = 'rateR_min';
[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(plt.labelrateMin);
%set(gca,'YLim', plt.YLimRippleRate );
%ylimfromzero();
ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);
title('Gamma-ripple rate');
format_axes(ha);
squareaxis(ha);


ha = hax(2);
axes(ha); hold on;
feature = 'rateR_min';
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
%ylabel(plt.labelrateMin);
%set(gca,'YLim', plt.YLimRippleRate );
%ylimfromzero();
ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);
title('Gamma-ripple rate');
format_axes(ha);
squareaxis(ha);

ha = hax(3);
axes(ha); hold on;
feature = 'rateR_min';
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
%ylabel(plt.labelrateMin);
%set(gca,'YLim', plt.YLimRippleRate);
%ylimfromzero();
%set(gca,'YTick', []);
ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);
title('Gamma-ripple rate');
format_axes(ha);
squareaxis(ha);

ha = hax(4);
axes(ha); hold on;
feature = 'Rfreq';
[hs,hb] = plotDotBoxplot_CXvsTREAT(TsubRes,feature,Tplt_CtrlVsTreat);
ylabel(plt.labelfreqHz);
% set(gca,'YLim',  plt.YLimRippleFreq  );
a.set_yprops(ha,'ripplefreq'); 
title('Gamma-ripple freq.');
format_axes(ha);
squareaxis(ha);

ha = hax(5);
axes(ha); hold on;

feature = 'Rfreq';
[hs] = plotSwarm_CXvsTREAT(Tiedf,feature);
%ylabel(plt.labelfreqHz);
a.set_yprops(ha,'ripplefreq'); 
title('Gamma-ripple freq.');
format_axes(ha);
squareaxis(ha);

ha = hax(6);
axes(ha); hold on;
feature = 'Rfreq';
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
%ylabel(plt.labelfreqHz);
a.set_yprops(ha,'ripplefreq'); 
title('Gamma-ripple freq.');
format_axes(ha);
squareaxis(ha);

ha = hax(7);
axes(ha); hold on;
feature = 'Rfreq';
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel(plt.labelfreqHz);
a.set_yprops(ha,'ripplefreq'); 
%set(gca,'YTick', []);
title('Gamma-ripple freq.');
format_axes(ha);
squareaxis(ha);

ha = hax(8);
axes(ha); hold on;
feature = 'RtoIEDrateShare';
[h] = plotBox_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
ylabel('GR/IED ratio (%)');
%ylimfromzero();
a.set_yprops(ha,'gammaripple2IEDshare'); 
title('Gamma-ripple/IED ratio');
format_axes(ha);
squareaxis(ha);

ha = hax(9);
axes(ha); hold on;
feature = 'RtoIEDrateShare';
[h] = plotDot_OutvsIn(TsubRes_inout,feature,Tplt_OutVsIn);
%ylabel('R/IED rate share, %');
%ylimfromzero();
a.set_yprops(ha,'gammaripple2IEDshare'); 
title('Gamma-ripple/IED ratio');
format_axes(ha);
squareaxis(ha);

% R plot histogram of oscillations
ha = hax(11);
axes(ha); hold on;
feature = 'RpeaksCount';
Tplot = TsubRes_inout(TsubRes_inout.Role == 'TREAT' & TsubRes_inout.InLesion == false, :);
plotHistCount(Tplot ,feature);
ylabel('Probability (%)');
title('Time relationship - out');
format_axes(ha);
squareaxis(ha);

ha = hax(12);
axes(ha); hold on;
feature = 'RpeaksCount';
Tplot = TsubRes_inout(TsubRes_inout.Role == 'TREAT' & TsubRes_inout.InLesion == true, :);
plotHistCount(Tplot ,feature);
% ylabel('Probability (%)');
title('Time relationship - in');
format_axes(ha);
squareaxis(ha);

