setuptest();
global svmModel;

audioFile = '/Users/phamdoanphuonganh/Desktop/midterm-dsp/midterm-DSP/trainedfromColab/audio_data/NicoNicokneecut.m4a'; % Update with your audio file path

info = audioinfo(audioFile);
disp('Audio File Information:');
disp(info);

[audioData, fs] = audioread(audioFile);
disp(['Audio data size: ', num2str(size(audioData))]);
disp(['Sample rate: ', num2str(fs)]);
audioLength = size(audioData, 1);
disp(['Audio Length: ', num2str(audioLength)]);

if audioLength < 1024
    windowLength = audioLength; 
else
    windowLength = 1024; 
end

features = preprocessAudioData(audioData, fs, windowLength);

disp('Processed Audio Features:');
disp(features);

features = features(:)'; 
disp(['Size of features: ', num2str(size(features))]);
disp(['Size of Support Vectors: ', num2str(size(svmModel.SupportVectors))]);
disp(['Size of Dual Coefficients: ', num2str(size(svmModel.DualCoefficients))]);

[predictedIndex, decisionValue] = svmModel.predict(features);
disp(class(svmModel));

disp('Raw Decision Values for Each Emotion Class:');
disp(decisionValue);

emotion_data = struct(...
    'angry', 'images/angry.png', ...
    'disgust', 'images/disgust.png', ...
    'fearful', 'images/anxiety.webp', ...
    'happy', 'images/joy.webp', ...
    'neutral', 'images/neutral.png', ...
    'sad', 'images/sad.jpeg', ...
    'surprised', 'images/surprise.png'...
);


emotion_labels = fieldnames(emotion_data);

if all(predictedIndex > 0) && all(predictedIndex <= length(emotion_labels))
    predictedLabel = emotion_labels{predictedIndex};  % Get the corresponding emotion label
else
    error('Invalid predicted index: %d', predictedIndex);
end


figure;
disp(['Predicted emotion: ', predictedLabel]);
predictedImagePath = emotion_data.(predictedLabel);
predictedImage = imread(predictedImagePath);
imshow(predictedImage);

figure;
bar(decisionValue);
set(gca, 'XTickLabel', emotion_labels);
title('Prediction Scores for Each Emotion Class');
xlabel('Emotion');
ylabel('Score');

% Check sizes of predictedIndex and decisionValue
disp(['Size of predictedIndex: ', num2str(size(predictedIndex))]);
disp(['Size of decisionValue: ', num2str(size(decisionValue))]);

% Create a table with all decision values alongside the predicted index
predictionsTable = array2table(decisionValue, 'VariableNames', strcat('DecisionValue_Class', string(1:size(decisionValue, 2))));
predictionsTable.PredictedIndex = predictedIndex;

disp('Predicted Index and Corresponding Decision Values:');
disp(predictionsTable);