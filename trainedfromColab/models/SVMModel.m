classdef SVMModel
    properties
        SupportVectors
        Intercept
        DualCoefficients
    end
    
    methods
        function obj = SVMModel(support_vectors, intercept, dual_coefficients)
            obj.SupportVectors = support_vectors;
            obj.Intercept = intercept;
            obj.DualCoefficients = dual_coefficients;
        end
        
        function label = predict(obj, x)
            decisionValue = obj.DualCoefficients' * (x * obj.SupportVectors') + obj.Intercept;
            label = decisionValue > 0;
        end
    end
end
