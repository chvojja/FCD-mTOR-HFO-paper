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

    end

end

