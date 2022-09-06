function   plotPSDWelch(x,fs,nff,color)
%PLOTPSDWELCH Summary of this function goes here
%   Detailed explanation goes here
% 
% Nx = length(x);
% nsc = floor(Nx/200);
% nov = floor(nsc/2);
% nff = max(256,2^nextpow2(nsc));

%[pxx,f,pxxc] = pwelch(x,hamming(nsc),nov,nff,fs, 'ConfidenceLevel',0.95);

% [pxx,f,pxxc] = pwelch(x,ones(nff,1), [], nff, fs) ; % , 'ConfidenceLevel',0.95);
[pxx,f] = pwelch(x,ones(nff,1), [], nff, fs) ; % , 'ConfidenceLevel',0.95);

% plot(f,10*log10(pxx))
% 
% xlabel('Frequency (Hz)')
% ylabel('PSD (dB/Hz)')


plot(f,10*log10(pxx),'Color',color,'LineWidth',1)


xlim([25 1000])
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')
hold on;
end

