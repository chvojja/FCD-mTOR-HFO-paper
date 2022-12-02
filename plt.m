classdef plt  
    %A Constants and Static methods for current analysis same for testing and full
    
    properties (Constant)  % Custom constants
        % Common settings that should be transferable to other plots too
        FontSize = 7;
        FontSizeAnnotate = 6;

        LineWidthBox = 1;
        LineWidthThicker = 1.2;


        colors = struct('CTRL',[0 0 0], 'TREAT', [1 0 0] );
        kolecko = struct('CLOUD', 20 , 'SUBJECTS', 50 );
        colorscloud = struct('CTRL', 'k'  , 'TREAT', 'k' );
      
        xticklabelCTRLTREAT = {'Control','FCD'}; %{'Cx','FCD'}; 
        xticklabelOutvsIn  = {'Outside','Inside'};


        % Common xylabels
        labeltimems = 'Time (ms)';
        labelfreqHz = 'Frequency (Hz)';
        labelamplitudemv = 'Amplitude (mV)';
        labelrateMin = 'Rate (events/min)';
        labelpsd = 'PSD (mV^2/Hz)'
        labelpsdratio = 'FCD/Cx PSD ratio (-)';

   

        hfodetector_param = 'default';

        YLimRippleRate = [ 0  0.3];
        YLimRippleFreq  = [40 140];

        YLimFRippleFreq = [350 700];

%         w = 12;
%         h = 12;
% 
%         w = 38;
%         h = 28;
        w = 9.5;
        h = 10.5;

        w_square_boxplot = 2.36;

        dpi = 1000;
        formatExt = 'png';
        closeFigs = true;
        savefigs_b = false;

        barsMeanFun = @nanmedian;

        OptimAxLimOffsetPercentage = 0.2;

        loadSignalIED = @(x)loadbin(x, [1,5000] , 'double' );

        IedCropPercent = 80;
        
% 
%         T = struct('Tst_OutVsIn',[], 'Tst_CtrVsTreat',[] );
% % 

% Signal shits
fs = 5000;
      

    end



% 
%     
    methods (Static)

        function formatSpecial1()
            ax = gca;
            ax.Position(3)=ax.Position(3)-0.009;
        end



        
    

    end

end


% exportgraphics(gcf, 'kokoti.pdf','ContentType','vector')

