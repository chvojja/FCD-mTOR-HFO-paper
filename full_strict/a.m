classdef a < Analyzer %& JancaSpike %& Verboser
    %A Constants and Static methods for current analysis
    
    properties (Constant)  % Custom constants
        root = 'D:\temp_FCD_analyza_full_strict';
        labelFolder = 'IEDFRRfinal_strict'; 
        verboser = Verboser();
           
%         names =            { JancaSpike.strict5000Hz.VKJlabelsName    JancaSpike.default.VKJlabelsName  };
%         colors =           { JancaSpike.strict5000Hz.VKJlabelsColor   JancaSpike.default.VKJlabelsColor };
%         jancaStrings =     { JancaSpike.strict5000Hz.settingsStr      JancaSpike.default.settingsStr };
%         names =            {    JancaSpike.default.VKJlabelsName  };
%         colors =           { JancaSpike.default.VKJlabelsColor };
%         jancaStrings =     {    JancaSpike.default.settingsStr };

        names =            { JancaSpike.strict5000Hz.VKJlabelsName      };
        colors =           { JancaSpike.strict5000Hz.VKJlabelsColor   };
        jancaStrings =     { JancaSpike.strict5000Hz.settingsStr    };       

    end


    
    methods (Static)


    
    function T = filefilter(TfilesOneSub)
    
    %load(a.pwd('VKJeegSubsetIDs.mat'));
    
    % Keep only first 2 files and all label files
    Teeg = TfilesOneSub( TfilesOneSub.Type =='eeg' & TfilesOneSub.SubFold1 == '5000HZ' , :); 
    Tlbl = TfilesOneSub( TfilesOneSub.Type =='lbl' & TfilesOneSub.SubFold1 == a.labelFolder, : ); 
    T = [Teeg; Tlbl];
    
    
    end

    function TallDetectionsOneLblFile = labelfilter(TallDetectionsOneLblFile)
        % filter some labels
        T = TallDetectionsOneLblFile( TallDetectionsOneLblFile.LabelName =='strict5000Hz' , : ); 
        %T = TallDetectionsOneLblFile( TallDetectionsOneLblFile.LabelName =='default' , : );
        %T = TallDetectionsOneLblFile( TallDetectionsOneLblFile.LabelName =='dontmiss5000Hz' , : ); 
    end


    function set_yprops(ha,nameOfPlot) 
        switch nameOfPlot
            case 'gammaripple2IEDshare'
                ha.YLim = [-0.2 3];
                ha.YTick = [0 1 2];
            case 'ripplefreq'
                ha.YLim = [30 150];
                ha.YTick = [40 60 80 100 120 140];
            case 'fripple2IEDshare'
                ha.YLim = [-0.2 12];
                ha.YTick = [0 5 10];
            case 'fripplefreq'
                ha.YLim = [350 750];
                ha.YTick = [ 400 500 600 700];


            case 'IEDsWithHFOs'
%                 ha.YLim = [0 10];
%                 ha.YTick = [0 2 4 6 8 10];
                ha.YLim = [0 6];
                ha.YTick = [0 2 4 6];
        end
        %%hax(9).YTick = [0 5 10 15];
    end



    end

end

