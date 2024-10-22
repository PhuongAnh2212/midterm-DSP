function setup()
    support_vectors = readmatrix('models/support_vectors.csv');
    intercept = readmatrix('models/intercept.csv');
    dual_coefficients = readmatrix('models/dual_coefficients.csv');

    global svmModel;
    svmModel = SVMModel(support_vectors, intercept, dual_coefficients);

    disp("Model load successfully")
end
