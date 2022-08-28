classdef Analyzer
    %A Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        % this needs to be defined in derived class
        %root = 'D:\temp_FCD_analyza_1';
        
    end
    
    methods
        function obj = Analyzer(inputArg1,inputArg2)
        end
        

    end

    methods (Static)

        function y  = pwd(x)  
            %FP create full path
            arguments
                x='';
            end
            y = fullfile(a.root,x);
        end

    end
end

