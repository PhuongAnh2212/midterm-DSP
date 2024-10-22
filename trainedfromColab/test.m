global svmModel; 
setup();

audioFile = '/Users/phamdoanphuonganh/Desktop/midterm-dsp/midterm-DSP/trainedfromColab/audio_data/sensorlog_20241022_180302.m4a'; % Update with your audio file path
% Get audio file info
info = audioinfo(audioFile);
disp('Audio File Information:');
disp(info);

% Read the audio data
[audioData, fs] = audioread(audioFile);

% Display the size of audio data and sample rate
disp(['Audio data size: ', num2str(size(audioData))]);
disp(['Sample rate: ', num2str(fs)]);

% Check the audio length
audioLength = size(audioData, 1);
disp(['Audio Length: ', num2str(audioLength)]);

% Set a window length based on audio length
if audioLength < 1024
    windowLength = audioLength; % Use the entire length if it's less than 1024
else
    windowLength = 1024; % Default to 1024
end

% Preprocess the audio data to extract features
features = preprocessAudioData(audioData, fs, windowLength);

% Ensure features are a row vector
features = features(:)'; 

% Check dimensions
disp(['Size of features: ', num2str(size(features))]);
disp(['Size of Support Vectors: ', num2str(size(svmModel.SupportVectors))]);
disp(['Size of Dual Coefficients: ', num2str(size(svmModel.DualCoefficients))]);

% Make prediction using the SVM model
predictedIndex = svmModel.predict(features);

disp(class(svmModel));
% Ensure predictedIndex is valid
if any(predictedIndex)
    % Assuming predictedIndex returns the index of the predicted class
    predictedLabel = emotion_labels{predictedIndex}; 
else
    disp('No emotion detected');
    return; % Exit the script if no valid prediction is made
end

% Display the predicted label
disp(['Predicted emotion: ', predictedLabel]);