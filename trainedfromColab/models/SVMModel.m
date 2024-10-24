classdef SVMModel
    properties
        SupportVectors
        Intercept
        DualCoefficients
    end
    
    methods
        function obj = SVMModel(support_vectors, intercept, dual_coefficients)
            obj.SupportVectors = support_vectors;

            % Ensure intercept is a row vector
            if iscolumn(intercept)
                intercept = intercept';  % Convert to row vector
            end
            
            % Validate the size of the intercept
            if size(intercept, 1) ~= 1 || size(intercept, 2) ~= 6
                error('Intercept must be a row vector of size 1 x 6.');
            end
            
            obj.Intercept = intercept;  % Assign the intercept
            obj.DualCoefficients = dual_coefficients;
        end
        
        function [label, decisionValue] = predict(obj, x)
            if iscolumn(x)
                x = x';  % Transpose to make sure it's a row vector
            end
            
            % Check if the feature size matches the support vector size
            if size(x, 2) ~= size(obj.SupportVectors, 2)
                error('Feature size does not match the number of support vectors features.');
            end
        
            % Calculate decision value for each class
            decisionValue = (x * obj.SupportVectors') * obj.DualCoefficients';  % Transpose DualCoefficients
            
            % Add intercept for each class (broadcasting)
            decisionValue = decisionValue + obj.Intercept;  % Add intercept (should be a vector)
            
            % Get the predicted class based on the max decision value
            [~, predictedIndex] = max(decisionValue, [], 2);  % Take the index of the max value along the row

            label = predictedIndex;
        end
    end
end
