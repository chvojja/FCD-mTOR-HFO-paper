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