function format_post_histograms()
% normal bars
ha = gca;
%  post formatting
hl = findall(ha.Children,'Type','Line');
[hl(:).LineWidth] = deal( plt.LineWidthThicker );


% compact bars
% ha = gca;
% %  post formatting
% hl = findall(ha.Children,'Type','Line');
% hl.LineWidth = plt.LineWidthThicker;
% hl = findall(ha.Children,'Type','ErrorBar');
% hl.LineStyle = ':';



end