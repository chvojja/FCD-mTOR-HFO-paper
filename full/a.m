classdef a < Analyzer %& JancaSpike %& Verboser
    %A Constants and Static methods for current analysis
    
    properties (Constant)  % Custom constants
        root = 'C:\temp_FCD_analyza_1Full';
        labelFolder = 'IEDFRRfinal1'; 
        verboser = Verboser();
           
%         names =            { JancaSpike.strict5000Hz.VKJlabelsName    JancaSpike.default.VKJlabelsName  };
%         colors =           { JancaSpike.strict5000Hz.VKJlabelsColor   JancaSpike.default.VKJlabelsColor };
%         jancaStrings =     { JancaSpike.strict5000Hz.settingsStr      JancaSpike.default.settingsStr };
        names =            {    JancaSpike.default.VKJlabelsName  };
        colors =           { JancaSpike.default.VKJlabelsColor };
        jancaStrings =     {    JancaSpike.default.settingsStr };

    end


    
    methods (Static)


    
    function T = filefilter(TfilesOneSub)
    
    %load(a.pwd('VKJeegSubsetIDs.mat'));
    
    % Keep only first 2 files and all label files
    Teeg = TfilesOneSub( TfilesOneSub.Type =='eeg' & TfilesOneSub.SubFold1 == '5000HZ' , :); 
    Tlbl = TfilesOneSub( TfilesOneSub.Type =='lbl' & TfilesOneSub.SubFold1 == a.labelFolder, : ); 
    T = [Teeg; Tlbl];
    
    
    end

    end

end

