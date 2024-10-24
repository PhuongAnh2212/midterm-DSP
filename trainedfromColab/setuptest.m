%Import các feature vectors của model gốc
support_vectors = csvread('models/support_vectors.csv');
intercept = csvread('models/intercept.csv');
dual_coefficients = csvread('models/dual_coefficients.csv');

svmModel = originalSVM(support_vectors, intercept, dual_coefficients);

svmModel.printModelSizes();

