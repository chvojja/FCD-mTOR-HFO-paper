classdef plt  
    %A Constants and Static methods for current analysis same for testing and full
    
    properties (Constant)  % Custom constants
        colors = struct('CTRL',[0 0 0], 'TREAT', [1 0 0] );
        kolecko = struct('CLOUD', 20 , 'SUBJECTS', 50 );
        colorscloud = struct('CTRL', 'k'  , 'TREAT', 'k' );
      
        xticklabelCTRLTREAT = {'Control','FCD'}; %{'Cx','FCD'}; 
        labeltimems = 'time, ms';
        labelfreqHz = 'frequency, Hz';
        labelrateMin = 'rate, event/min.';

        w = 12;
        h = 12;

        dpi = 1000;
        formatExt = 'png';
        closeFigs = true;

        barsMeanFun = @nanmedian;

        OptimAxLimOffsetPercentage = 0.2;

        loadSignalIED = @(x)loadbin(x, [1,5000] , 'double' );

        IedCropPercent = 80;
        FontSize = 5;
% 
%         T = struct('Tst_OutVsIn',[], 'Tst_CtrVsTreat',[] );
% % 

      

    end



% 
%     
    methods (Static)




        
    

    end

end



