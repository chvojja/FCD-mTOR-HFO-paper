



fs = 5000;
% spectro
res = 1.8;
frange = [80 1000];
frange = [30 250];
frange = [300 800];
Nfreqpoints = 10;

selectL = Tiedf.HasR & Tiedf.Role == 'CTRL';
selectL = Tiedf.HasFR & Tiedf.Role == 'TREAT';
%selectL = Tiedf.HasFR & Tiedf.Role == 'TREAT' & Tiedf.Subject=='Naty419';


inds = find(selectL);
for i = inds'
    s = Tiedf.Signal{i} ;

    
    subplot(3,1,1)

    tSampling=1/fs;
    N=numel(s);
    t=0:tSampling:0+(N-1)*tSampling;
    plot(t,s);

    subplot(3,1,2)

    h = plotstockwell(s,fs,res,frange,Nfreqpoints,'linear');


    pause

end