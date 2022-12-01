function [hb] = plotBox_OutvsIn(TsubRes_inout,feature,Tstats)
hold on;

% only treatment animals
Tplot = TsubRes_inout( TsubRes_inout.Role == 'TREAT' , {'Subject','Number','InLesion',feature}); 
Tplot.InLesion = categorical(Tplot.InLesion);
Tplot.InLesion = cat2num(Tplot.InLesion,'false',1,'true',2);

hb=boxchart(Tplot.InLesion,Tplot.(feature));
format_boxchart(hb);


hax = gca;
set(hax,'XLim',[0.5 2.5]);
set(gca,'XTick',[1 2]);
set(gca,'xticklabel',plt.xticklabelOutvsIn);

ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);
x12 = [1 2];
plotsigline(  Tstats{feature,'p'}   , x12, hb.YData );


%resize2tight();

end








