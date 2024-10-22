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

% Define the emotion labels (Make sure the number matches the number of classes in your model)
emotion_data = struct(...
    'angry', 'images/angry.png', ...
    'disgust', 'images/disgust.png', ...
    'fearful', 'images/anxiety.webp', ...
    'happy', 'images/joy.webp', ...
    'neutral', 'images/neutral.png', ...
    'sad', 'images/sad.jpeg', ...
    'surprised', 'images/surprise.png'...
);
% Check if the predicted index is valid and map to the corresponding emotion label
if predictedIndex > 0 && predictedIndex <= length(emotion_labels)
    predictedLabel = emotion_labels{predictedIndex};  % Get the corresponding emotion label
else
    error('Invalid predicted index: %d', predictedIndex);
end

% Display the predicted emotion
disp(['Predicted emotion: ', predictedLabel]);
predictedImagePath = emotion_data.(predictedLabel);
predictedImage = imread(predictedImagePath);  % Load the image for further use

imshow(predictedImage);
