function plot_detection_algo(s,fs,hfo_close,hfo_cand,fd,rms_fd,threshold_rms_fd,xOver,fsOver)

% 
% figurefull;
figurefull;

% h_subplot = @(m,n,p) subtightplot (m, n, p, [0.05658 0.0565], [0.081 0.051], [0.0998 0.0293]);
h_subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.081 0.051], [0.0998 0.0293]);
%ax_layout
[hax] = layoutaxesrows(h_subplot,[1 1 1 1 1],1,1,1,1,1);

axes(hax(1));
plot(s2t(s,fs),s);
ylim_raw   = hax(1).YLim;
y_half_span = diff(hax(1).YLim)/2;
ylim_raw   = 0.5*[-y_half_span +y_half_span];

ha = hax(2); axes(ha); hold on;
plot(s2t(fd,fs),fd); hold on;
%plot(s2t(rms_fd,fs),rms_fd,':');
hax(2).YLim = 1.1*ylim_raw ;

ha = hax(3); axes(ha); hold on;
%plot(s2t(fd,fs),fd); 
h_rmsfd = plot(s2t(rms_fd,fs),rms_fd);
plot(s2t(rms_fd,fs),threshold_rms_fd,':');

hfo_cand_inv=1-double(hfo_cand); hfo_close_inv=1-double(hfo_close);
hfo_cand_inv(hfo_cand_inv==1)=NaN; hfo_close_inv(hfo_close_inv==1)=NaN;

yspan = max(rms_fd);
h_final = plot(s2t(hfo_close,fs),0*yspan*hfo_close_inv);
h_cand =plot(s2t(hfo_cand,fs),hfo_cand_inv+0.17*yspan);
ha.YLim = 0.5*(ylim_raw + ylim_raw(2)) ;

ha = hax(4); axes(ha); hold on;
plot(s2t(fd,fs),fd); hold on;
fdcrop = fd;
fdcrop(hfo_close==false)=NaN;
h_hfocropped = plot(s2t(fdcrop,fs),fdcrop);
ha.YLim = 1.1*ylim_raw ;

ha = hax(5); axes(ha); hold on;
xcOver = xcorr(xOver,xOver);
findpeaks(xcOver,fsOver/1000,'SortStr','descend'); % lags in miliseconds


% format
% colors
hf = findall(gcf,'Type','Line', '-property', 'Color'); 
set(hf,'Color','k');
h_rmsfd.Color = 'k';
h_hfocropped.Color = 'r';
h_final.Color = 'r';
h_cand.Color = 'k';

%
h_format_axes_assignal = @() inlinefun("set(gca,'XLim',[0.2 0.8]); hideaxis(); ");
h_format_axes_assignal = @() inlinefun("set(gca,'XLim',[0.2 0.8]); ");
axesfun(hax(1:4),h_format_axes_assignal);

ha = hax(5); axes(ha); hold on;
ha.Children(1).MarkerSize=1.2;
ha.Children(1).MarkerFaceColor = 'k';
hideaxis(); grid off
%
resize2cm(4.4,5.5);

axesfun(hax,@format_axes);
%
h_final.LineWidth = 2;
h_cand.LineWidth = 2;


exportgraphics(gcf, 'kokoti2.pdf','ContentType','vector');


end