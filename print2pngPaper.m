
function print2pngPaper(varargin)
%return
fpname = varargin{1};
w = varargin{2};
h = varargin{3};
dpi = 300; % 700
switch nargin
    case 4
        dpi = varargin{4};

end


set(gcf,'PaperUnits','inches','PaperPosition',[0 0 w h]);
print(fpname, '-dpng' , ['-r' num2str(dpi)] );
close(gcf);
end