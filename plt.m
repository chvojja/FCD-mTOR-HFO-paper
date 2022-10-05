classdef plt  
    %A Constants and Static methods for current analysis same for testing and full
    
    properties (Constant)  % Custom constants
        colors = struct('CTRL',[0 0 1], 'TREAT', [1 1 0] );
        kolecko = struct('CLOUD', 20 , 'SUBJECTS', 50 );
        colorscloud = struct('CTRL', 'k'  , 'TREAT', 'k' );
      
        xticklabelCTRLTREAT = {'Cx','FCD'};

        w = 12;
        h = 12;

        dpi = 300;
        formatExt = 'png';
        closeFigs = true;

        barsMeanFun = @nanmedian;

        OptimAxLimOffsetPercentage = 0.2;
% 
%         T = struct('Tst_OutVsIn',[], 'Tst_CtrVsTreat',[] );
% % 

      

    end



% 
%     
    methods (Static)




        
    

    end

end



