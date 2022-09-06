
function print2pngPaper(fpname,w,h)
%return

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 w h]);
print(fpname, '-dpng' , '-r700');
close(gcf);
end