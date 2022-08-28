classdef a < Analyzer
    %A Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        root = 'D:\temp_FCD_analyza_1';
        
    end
    
    methods
        function obj = a(inputArg1,inputArg2)
            %A Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end

    methods (Static)



    end
end

