function format_post_histograms()

ha = gca;
%  post formatting
hl = findall(ha.Children,'Type','Line');
hl.LineWidth = 1.1;
hl = findall(ha.Children,'Type','ErrorBar');
hl.LineStyle = ':';



end