classdef a < Analyzer %& JancaSpike %& Verboser
    %A Constants and Static methods for current analysis
    
    properties (Constant)  % Custom constants
        root = 'D:\temp_FCD_analyza_testing';
        labelFolder = 'IEDFRRtesting'; 
        verboser = Verboser();
        
        names =            {    JancaSpike.default.VKJlabelsName  };
        colors =           {    JancaSpike.default.VKJlabelsColor };
        jancaStrings =     {    JancaSpike.default.settingsStr };
%         names =            {    JancaSpike.dontmiss5000Hz.VKJlabelsName  };
%         colors =           {    JancaSpike.dontmiss5000Hz.VKJlabelsColor };
%         jancaStrings =     {    JancaSpike.dontmiss5000Hz.settingsStr };

        
    end


    
    methods (Static)


    function T = filefilter(TfilesOneSub)
        % Keep only first 2 files and all label files
        Teeg = TfilesOneSub( TfilesOneSub.Type =='eeg' & TfilesOneSub.SubFold1 == '5000HZ' , :); 
        Tlbl = TfilesOneSub( TfilesOneSub.Type =='lbl' & TfilesOneSub.SubFold1 == a.labelFolder, : ); 
        T = [Teeg( 1:3 ,:); Tlbl];
    end

    function T = labelfilter(TallDetectionsOneLblFile)
        % filter some labels
        %T = TallDetectionsOneLblFile( TallDetectionsOneLblFile.LabelName =='strict5000Hz' , : ); 
        T = TallDetectionsOneLblFile( TallDetectionsOneLblFile.LabelName =='default' , : );
        %T = TallDetectionsOneLblFile( TallDetectionsOneLblFile.LabelName =='dontmiss5000Hz' , : ); 
    end

    
    end

end

