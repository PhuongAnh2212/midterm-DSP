classdef originalSVM
    properties
        SupportVectors
        Intercept
        DualCoefficients
    end
    
    methods
        function obj = originalSVM(support_vectors, intercept, dual_coefficients)
            obj.SupportVectors = support_vectors;
            obj.Intercept = intercept;
            obj.DualCoefficients = dual_coefficients;
        end
        
        function [label, decisionValue] = predict(obj, x)
            decisionValue = (x * obj.SupportVectors') * obj.DualCoefficients';
            decisionValue = decisionValue + obj.Intercept;
            [~, predictedIndex] = max(decisionValue, [], 2);
            label = predictedIndex;
        end
        
        function printModelSizes(obj)
            fprintf('Size of Support Vectors: [%d, %d]\n', size(obj.SupportVectors));
            fprintf('Size of Dual Coefficients: [%d, %d]\n', size(obj.DualCoefficients));
            fprintf('Size of Intercept: [%d, %d]\n', size(obj.Intercept));
        end
    end
end
