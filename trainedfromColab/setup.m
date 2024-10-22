function setup()
    support_vectors = readmatrix('models/support_vectors.csv');
    intercept = readmatrix('models/intercept.csv');
    dual_coefficients = readmatrix('models/dual_coefficients.csv');

    global svmModel;
    % Display the size of the intercept
    disp('Size of Intercept:');
    disp(size(intercept));  % Should output [21, 1]
    
    % Check if intercept is too long
    if size(intercept, 1) >= 6
        intercept = intercept(1:6, :);  % Take the first 6 values if more than needed
    else
        error('Intercept does not have enough values for the classes.');
    end
    
    % Reshape to be a row vector
    intercept = intercept';  % This makes it a row vector of size [1, 6]
    
    % Check the size of the intercept after reshaping
    disp('Size of Intercept after adjustment:');
    disp(size(intercept));  % Should output [1, 6]

    
    % Create the SVM model
    svmModel = SVMModel(support_vectors, intercept, dual_coefficients);


    disp("Model load successfully")
    
end