
function [hs,hb] = plotDotBoxplot_CXvsTREAT(Tsub,feature,Tstats)
hold on;

% plot per subject s boxplotem
d = 0.2;

Tplot = Tsub(:,{'Subject','Role',feature});
Tplot.Role = cat2num(Tplot.Role,'CTRL',1+d,'TREAT',2+d);

hb=boxchart(Tplot.Role,Tplot.(feature)); hold on;
hb.BoxWidth = 2*d;
format_boxchart(hb);
% 'LineWidth',plt.LineWidthBox

% now lets add jitter
Tplot.Role = Tplot.Role -2*d;
x12Sig = sort( unique( Tplot.Role ) ); % x for sig line
% hs = scatterbetter(Tplot,'Role',feature,'filled','ColorVariable','Role' );

hs = scatter(Tplot,'Role',feature); % ,'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5  );
hs.MarkerEdgeColor = 'k';
hs.Marker="o";
hs.SizeData=5;

%colormap(gca,'hsv')
%s.MarkerFaceColor = 'k';
% xlabel([]);
% ylabel([]);

% colormap([ plt.colors.CTRL; plt.colors.TREAT] );
% hs.SizeData=30;

%hlbl = labelpoints (Tplot.Role, Tplot.(feature), Tsub.Number, 'SW', 0.15, 'FontSize', 7);

box on
hax = gca;
hax.XLabel.String=[];
hax.YLabel.String=[];
hax.YLabel=[];
hax.XLim =[0.6 2.6];
hax.XTick =[1 2];
hax.XTickLabel = plt.xticklabelCTRLTREAT ;
hax.XTickLabelRotationMode="manual";
hax.XTickLabelRotation=0;

%h.XRuler.TickLength = 50;

ylimoptimal(PercentMargin = plt.OptimAxLimOffsetPercentage);

%Tstats{feature,'p'} =0.005;
plotsigline(  Tstats{feature,'p'}   , x12Sig, hb.YData );

end