function formatAsPSDplot()

% set(gca, 'XScale', 'log', 'YScale','log');
% %grid on

hax = gca;
hax.XScale ="log";
hax.YScale = "log";
hax.Box ="on";


hax.XLim = [1 2*10^3];
hax.YLim = [10^-9 10^-2];

%hax.XTick =
% ylim([10^-9 10^-2]);
% xlim([1 2*10^3]);
xlabel(plt.labelfreqHz);



end

