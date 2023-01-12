


magnitude = gaussmagbp([35 45 250 300],5000);  % more detections
filteringfun_R = @(x,x1)filterfft2(x,magnitude);

magnitude = gaussmagbp([250 300 800 900],5000);
filteringfun_FR = @(x,x1)filterfft2(x,magnitude);



%selectL = Tiedf.HasFR & Tiedf.Role == 'CTRL';
%selectL = Tiedf.HasR & Tiedf.Role == 'TREAT';
%selectL = Tiedf.HasFR & Tiedf.Role == 'TREAT' & Tiedf.Subject=='Naty419';

folder_label = 'OnlyRipples';
group_label = 'TREAT';
selectL = Tiedf.HasR & ~Tiedf.HasFR & Tiedf.Role == group_label;
export_hfo_singlegroup(selectL,Tiedf,folder_label,group_label,filteringfun_R,filteringfun_FR);


folder_label = 'OnlyRipples';
group_label = 'CTRL';
selectL = Tiedf.HasR & ~Tiedf.HasFR & Tiedf.Role == group_label;
export_hfo_singlegroup(selectL,Tiedf,folder_label,group_label,filteringfun_R,filteringfun_FR);

folder_label = 'OnlyFastRipples';
group_label = 'TREAT';
selectL = Tiedf.HasFR & ~Tiedf.HasR & Tiedf.Role == group_label;
export_hfo_singlegroup(selectL,Tiedf,folder_label,group_label,filteringfun_R,filteringfun_FR);

folder_label = 'OnlyFastRipples';
group_label = 'CTRL';
selectL = Tiedf.HasFR & ~Tiedf.HasR & Tiedf.Role == group_label;
export_hfo_singlegroup(selectL,Tiedf,folder_label,group_label,filteringfun_R,filteringfun_FR);


folder_label = 'BothRipplesFastRipples';
group_label = 'TREAT';
selectL = Tiedf.HasFR & Tiedf.HasR & Tiedf.Role == group_label;
export_hfo_singlegroup(selectL,Tiedf,folder_label,group_label,filteringfun_R,filteringfun_FR);

folder_label = 'BothRipplesFastRipples';
group_label = 'CTRL';
selectL = Tiedf.HasFR & Tiedf.HasR & Tiedf.Role == group_label;
export_hfo_singlegroup(selectL,Tiedf,folder_label,group_label,filteringfun_R,filteringfun_FR);




function y = export_hfo_singlegroup(selectL,Tiedf,folder_label,group_label,filteringfun_R,filteringfun_FR)
% spectro
res = 1.9;
frange_R = [30 200];
frange_FR = [300 750];
Nfreqpoints = 12;

fs = 5000;
inds = find(selectL); inds=inds(:);
for row = inds'
    s =  loadfun( plt.loadSignalIED, Tiedf.Signal( row )  );
    s_r = filteringfun_R(s);
    s_fr = filteringfun_FR(s);

    figurefull;
    subplot(6,2,[1 3]);
    
        tSampling=1/fs;
        N=numel(s);
        t=0:tSampling:0+(N-1)*tSampling;
        h = plot(t,s,'k');
        ha = gca;
        ha.YLim=[-0.25 0.25]*4;
        title('1. Raw signal, 2. Ripple filtered, 3. FastRipple filtered');
        ylabel('Amplitude, original, mV')
        

    subplot(6,2,[5 7]);
    hr = plot(t,s_r,'k');
    ha = gca;
    ha.YLim=[-0.25 0.25]*2;
    ylabel('Amplitude, x2, mV')

    subplot(6,2,[9 11]);
    hfr = plot(t,s_fr,'k');
    ha = gca;
    ha.YLim=[-0.25 0.25];
    xlabel('Time, s');
    ylabel('Amplitude, x4, mV')

    % spectrogram
    sc = cropfill("Signal",s,"CropPercent",50,"WhatToFill",[]);

    subplot(6,2,[2 4 6]);
    h1 = plotstockwell(sc,fs,res,frange_R,Nfreqpoints,'linear');
    ylabel('Frequency, Hz');
    hfo_text = [];
    if Tiedf.HasR(row), hfo_text=[hfo_text '-Ripple-']; end
    if Tiedf.HasFR(row), hfo_text=[hfo_text '-FastRipple-']; end
    title(['Detected because of: ' hfo_text ]);

    subplot(6,2,[8 10 12]);
    h2 = plotstockwell(sc,fs,res,frange_FR,Nfreqpoints,'linear');
    xlabel('samples');
    ylabel('Frequency, Hz');
%     subplot(6,2,[2 4 6 8 10 12]);
%     h = plotstockwell(sc,fs,res,[30 750],Nfreqpoints,'linear');

    fpname = [a.pwd([folder_label '_' group_label]) '\' [folder_label '_' group_label] '_Tiedf_' num2str(row) '.png'];
    printpaper(fpname);
    %pause
end

end

