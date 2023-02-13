

[r,~] = size(Tiedf); 

rows_FRs = find(  Tiedf.HasFR );

%d = designfilt('highpassiir','FilterOrder',3, 'HalfPowerFrequency',100,'SampleRate',fs);

for ir = rows_FRs'
%for ir = 183173:r
    % ir = 115  % 115
     %ir = 19;
     %ir = 100;
     %ir = 183173;

     %s = subtractmed(  readvar( Files = Tied.Signal( ir ) , ReadFun = @(x)loadbin(x, [1,5000] , 'double' ), CatDim = 1 )   );
     s =  loadfun(plt.loadSignalIED, Tiedf.Signal( ir )  );
     %s = plt.filteringfun_FR(s);

%      sf = filtfilt(d,s);
%      s = sf;

%      subplot(2,1,1);
%      plot(s)
%      subplot(2,1,2);
%      plot(sf)

     
     pks = Tiedf.FRpeaksInd{ir};
     idx_fr = round(median(find(pks)));

     s = centersig(Signal = s, AroundIndex = idx_fr);
     scrop = cropfill("Signal",s,"KeepSamples",140);

     %plot(scrop);
     %pause


     frange = [100 800];
     Nb = 35; % bins
     fbins = linspace(frange(1),frange(2),Nb+1); % bin edges
     [p,f] = pspectrum(scrop,fs,'FrequencyLimits',frange);
     %p = 10*log10(p);
     pbins = zeros(1,Nb); % powers
     for ib = 1:Nb
         f_li = f>=fbins(ib) & f<fbins(ib+1);
         pbins(ib) = sum(p(f_li));
     end

     % treat it as statistical distribution / area = 1;
     pbins = pbins-min(pbins);
     pbins = pbins / sum(pbins);
     pbins = pbins +eps; % for every zero to be zero to the right

     % FRindex
     % 16.bin is 400Hz and above
     Tiedf.FRindex( ir ) = sum(pbins(16:end));

     % entropy
     ent=0;
     for ib = 1:Nb
         ent = ent + pbins(ib)*log2(pbins(ib));
     end
     ent = -ent;
     Tiedf.Entropy( ir ) = ent;

    % mode of the "prob.distribution"
    %[pmax,pmax_ind] = max(pbins);

    % print 
    %[FRindex,ent, pmax_ind]
   

%      subplot(2,1,1);
%      plot(f,p)
%      subplot(2,1,2);
%      plot(fbins(1:end-1), pbins)
%      %pause

     %power_in_bins(scrop, fs, fbins);


end

x = Tiedf.Entropy( rows_FRs );
y = Tiedf.FRindex( rows_FRs );
scatter( x, y,5,'k'); 

% labels
ylabel('FRindex [-]');
xlabel('Entropy [-]');

% format
ha = gca; 
ha.XLim = [0 5.5];
ha.YLim = [0 1];
axis square

% save 
save7fp = a.pwd('Tiedf'); save7;
savefig(a.pwd('FRindex_entropy.fig'));

% N = length(x);
% xdft = fft(x);
% xdft = xdft(1:N/2+1);
% psdx = (1/(fs*N)) * abs(xdft).^2;
% psdx(2:end-1) = 2*psdx(2:end-1);
% freq = 0:fs/length(x):fs/2;
% 
% plot(freq,pow2db(psdx))
% 
% %
% n = 0:319;
% x = cos(pi/4*n)+randn(size(n));
% nfft = length(x);
% periodogram(x,[],128)