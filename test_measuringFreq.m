

% 
fs = 5000;
% filteringfun_R = @(x,x1,x2) filtergauss(X = x, BandPass = [80 200]); 
% 
 [b,~] = favouritefilters('bpfastripples',fs);
 filteringfun_FR = @(x,x1,x2)filtfilt(b,1,x);
% 
% [r,~] = size(Tiedf);


mag_FR = bpgaussmag([250 300 800 900],5000);

hfoIdxs = find(Tiedf.HasFR);
Nhfos = numel(hfoIdxs);
hfos = zeros(size(hfoIdxs));
% filteringfun = @(x,x1,x2) filtergauss(X = x, BandPass = [80 200]); 

for i = 1:Nhfos
    ir = hfoIdxs(i);
     
    s =  loadfun(plt.loadSignalIED, Tiedf.Signal( ir )  );

   % s2 = magfilter(s,mag_FR);

    %s3 = filtergauss(X = s, BandPass = [30 800]);
    % s3 = filteringfun_FR(s);
     %s2 = filtergauss2(X = s, BandPass = [250 800]);
     %s3 = filtergauss2(X = s, BandPass = [150 250 800 1500]);
%     figurefull;
%      plot(s); hold on;
%      plot(s2-0.6);
%      plot(s3-1.2)

   s = magfilter(s,mag_FR);

   Nover = 30;
   s2 = interpft(s,Nover*numel(s));


%    figurefull;
%    subplot(2,1,1)
% 
%    plot(s2t(s2,Nover*fs),s2); hold on;
%    plot(s2t(s,fs),s+0.3);
%    hold off;
% 
%     subplot(2,1,2)
%     h = plotstockwell(s,fs,1.8,[270 700],50,'linear');

   %f = fbyxcorr(s,fs);
   f = fbyxcorr(s2,Nover*fs);
   %[f3,~,~]= getFreqStockwell( s  ,fs,250,700);

%     gausswin(L,alpha)
% 
% 
%     [f,absH,faxis]= getFreqStockwell( s  ,fs,30,900);
%     f
%     imagesc(absH);
%     %xc = xcorr(s,s); xs(5000:end); plot( log10(xs) )
     hfos(i) = f;
%     pause
%      close all
   
    a.verboser.sprintf2('ProgressPerc',round(100*i/Nhfos),'HFO feq measuring2');
end


swarmchartbetter(ones(Nhfos,1), hfos );

[Tiedf.FRfreq( hfoIdxs )] = hfos;




function y = bpgaussmag(f_3dB,fs)

% fs even case
gwa = gaussup( f_3dB(2) , (f_3dB(2)-f_3dB(1))  );
Ngwup = numel(gwa);
Nfsh = fs/2+1;
Ntop = f_3dB(3)-f_3dB(2) ;
gwd = gaussdown( Nfsh-Ngwup-Ntop ,  f_3dB(4)-f_3dB(3) );

mag = [  gwa  ones(1,Ntop)  gwd  ];

mag_filter = [fliplr(mag)  mag(2:end-1)]';
y = mag_filter;

    function y = gaussdown(Nmax,samples_3db)
        alpha = 2.5;
        N=samples_3db*128/30;
        %N =128; 
        n = 0:Nmax-1;
        stdev = (N-1)/(2*alpha);
        y = exp(-1/2*(n/stdev).^2);
        %plot(y);

    end

    function y = gaussup(Nmax,samples_3db)
        y = fliplr( gaussdown(Nmax,samples_3db) );
    end

end




function y = magfilter(x,mag_filter)

x=x(:);
% num_rows = size(x,1);
% num_cols = size(x,2);
%[X,Y] = meshgrid(1:num_cols,1:num_rows);
freq_domain = fft2(x);
freq_domain_shifted=fftshift(freq_domain);
freq_pass_window = ones(size(x));
% freq_pass_window_center_x = floor(size(freq_pass_window,2)/2)+1;
% freq_pass_window_center_y = floor(size(freq_pass_window,1)/2)+1;


freq_pass_window = freq_pass_window.*mag_filter;

% plotbode(Magnitude = mag_filter(2500:end), Fs =5000);
% pause

windowed_freq_domain_shifted = freq_domain_shifted.*freq_pass_window;
adjusted_freq_domain = ifftshift(windowed_freq_domain_shifted);
im_2 = ifft2(adjusted_freq_domain);
y = im_2;


end


function f = fbyxcorr(x,fs)
%figure
%findpeaks(xcorr(x,x),fs,'SortStr','descend');
   [fp,fi,~,p]=findpeaks(xcorr(x,x),fs,'SortStr','descend'); %,'MinPeakWidth',widthSec);
   
   f = 1/min(abs(fi(2:end)-fi(1)));
   %sort2(fi,)
   %f=1/mean(diff(sort(fi(1:3))));
end

