% Load parameters
function setup()
    % Load SVM parameters from CSV files
    support_vectors = readmatrix('models/support_vectors.csv');
    intercept = readmatrix('models/intercept.csv');
    dual_coefficients = readmatrix('models/dual_coefficients.csv');

    % Create an instance of the SVMModel class
    global svmModel;
    svmModel = SVMModel(support_vectors, intercept, dual_coefficients);

    disp('Model parameters loaded successfully.');
end
