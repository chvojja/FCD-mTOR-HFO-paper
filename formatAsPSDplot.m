function formatAsPSDplot()

set(gca, 'XScale', 'log', 'YScale','log');
grid on

%title('Welch Power Spectral Density estimate, all subjects with means')

ylim([10^-9 10^-2]);
xlim([1 2*10^3]);
xlabel('Frequency, Hz');


end

