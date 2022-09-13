classdef a < Analyzer & JancaSpike %& Verboser
    %A Constants and Static methods for current analysis
    
    properties (Constant)  % Custom constants
        root = 'D:\temp_FCD_analyza_1';
        labelFolder = 'IEDFRRfinal1'; 
        verboser = Verboser();
        
        
    end


    
    methods (Static)



    
    function T = filefilter(TfilesOneSub)
    
    %load(a.pwd('VKJeegSubsetIDs.mat'));
    
    % Keep only first 2 files and all label files
    Teeg = TfilesOneSub( TfilesOneSub.Type =='eeg' & TfilesOneSub.SubFold1 == '5000HZ' , :); 
    Tlbl = TfilesOneSub( TfilesOneSub.Type =='lbl' & TfilesOneSub.SubFold1 == a.labelFolder, : ); 
    T = [Teeg( 1:2 ,:); Tlbl];
    
    
    end


    
    end

end

