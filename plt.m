classdef plt  
    %A Constants and Static methods for current analysis same for testing and full
    
    properties (Constant)  % Custom constants
        % Common settings that should be transferable to other plots too
        FontSize = 7;
        FontSizeAnnotate = 6;

        LineWidthThin = 0.5;
        LineWidthThicker = 0.8;


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

        OptimAxLimOffsetPercentage = 0.05;

        loadSignalIED = @(x)loadbin(x, [1,5000] , 'double' );

        IedCropPercent = 80;
       
% 
%         T = struct('Tst_OutVsIn',[], 'Tst_CtrVsTreat',[] );
% % 
        % Signal shits
        fs = 5000;
        bpR = designfilt('bandpassfir','StopbandFrequency1',60,'PassbandFrequency1',100,'PassbandFrequency2',300,'StopbandFrequency2',350,'StopbandAttenuation1',40,'PassbandRipple',0.0001,'StopbandAttenuation2',40,'SampleRate',5000);
        bpFR = designfilt('bandpassfir','StopbandFrequency1',250,'PassbandFrequency1',300,'PassbandFrequency2',1000,'StopbandFrequency2',1050,'StopbandAttenuation1',40,'PassbandRipple',0.0001,'StopbandAttenuation2',40,'SampleRate',5000);
        %
    end



% 
%     
    methods (Static)

        function formatSpecial1()
            ax = gca;
            ax.Position(3)=ax.Position(3)-0.009;
        end

%         function computeFreqStats(frqs,feature)
% 
%             stats = load2( a.pwd('stats.mat') );
%             switch feature
%                 case 'Rfreq'
%                     [mus,sems] = multimodalstats(frqs,2,'sem');
%                     stats.([feature '_multimodals_mu']) = mus;
%                     stats.([feature '_multimodals_sems']) = sems;
%                     stats.([feature '_multimodals_AsText_1']) = printmeansem(mus(1),sems(1));
%                     stats.([feature '_multimodals_AsText_2']) = printmeansem(mus(2),sems(2));
% 
%                 case 'FRfreq'
%                     [mus,sems] = multimodalstats(frqs,1,'sem');
%                     stats.([feature '_multimodals_mu']) = mus;
%                     stats.([feature '_multimodals_sems']) = sems;    
%                     stats.([feature '_multimodals_AsText_1']) = printmeansem(mus(1),sems(1));
%             end
%             save(a.pwd('stats.mat'),'stats')
% 
%         end




        
    

    end

end


% exportgraphics(gcf, 'kokoti.pdf','ContentType','vector')

