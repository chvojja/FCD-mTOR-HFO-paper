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