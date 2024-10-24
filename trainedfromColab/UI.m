function emotionRecognitionUI
    % Create the main UI figure
    fig = uifigure('Name', 'Emotion Recognition', 'Position', [100, 100, 600, 400]);

    % Create a button to load the audio file
    loadAudioButton = uibutton(fig, 'Text', 'Load Audio', 'Position', [20, 350, 100, 30]);
    loadAudioButton.ButtonPushedFcn = @loadAudioCallback;
    
    % Create a table to display the audio features
    featuresTable = uitable(fig, 'Position', [20, 100, 250, 200], 'ColumnName', {'Feature', 'Value'});
    
    % Create an axes to display the predicted emotion image
    emotionAxes = uiaxes(fig, 'Position', [300, 150, 250, 200]);
    
    % Create a label to display the predicted emotion text
    predictedEmotionLabel = uilabel(fig, 'Position', [300, 350, 250, 30], 'FontSize', 14);

    % Callback function to load the audio and display results
    function loadAudioCallback(~, ~)
        [audioFile, audioPath] = uigetfile('*.wav;*.m4a;*.mp3', 'Select an Audio File');
        
        if isequal(audioFile, 0)
            return;
        end
        
        fullAudioPath = fullfile(audioPath, audioFile);
        
        [predictedLabel, predictedImagePath, features] = processAudioFile(fullAudioPath);
        
        featuresTable.Data = num2cell(features);
        featuresTable.ColumnName = "MFCC Feature";  
        
        % Display the predicted emotion image
        emotionImage = imread(predictedImagePath);
        imshow(emotionImage, 'Parent', emotionAxes);
        
        % Display the predicted emotion label
        predictedEmotionLabel.Text = ['Predicted Emotion: ', predictedLabel];
    end


    % Function to load and process the audio file
    function [predictedLabel, predictedImagePath, features] = processAudioFile(audioFile)
        global svmModel;
        
        % Load and preprocess the audio file (same as your original code)
        [audioData, fs] = audioread(audioFile);
        windowLength = min(size(audioData, 1), 1024);
        features = preprocessAudioData(audioData, fs, windowLength);
        
        % Flatten features for prediction
        featuresFlat = features(:)';
        
        % Predict emotion using SVM model
        [predictedIndex, decisionValue] = svmModel.predict(featuresFlat);
        
        % Define emotion labels and image paths
        emotion_data = struct(...
            'angry', 'images/angry.png', ...
            'disgust', 'images/disgust.jpg', ...
            'fearful', 'images/anxiety.webp', ...
            'happy', 'images/joy.webp', ...
            'neutral', 'images/neutral.png', ...
            'sad', 'images/sad.jpeg', ...
            'surprised', 'images/surprise.png'...
        );
        
        emotion_labels = fieldnames(emotion_data);
        predictedLabel = emotion_labels{predictedIndex};
        predictedImagePath = emotion_data.(predictedLabel);
        
        % Return the predicted label, image path, and features
    end
end
