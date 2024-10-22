setup();

audioFile = '/Users/phamdoanphuonganh/Desktop/midterm-dsp/midterm-DSP/trainedfromColab/audio_data/sensorlog_20241022_180302.m4a'; % Update with your audio file path
fs = 48000;
[audioData, fs] = audioread(audioFile);

% Display the size of audio data and sample rate
disp(['Audio data size: ', num2str(size(audioData))]);
disp(['Sample rate: ', num2str(fs)]);

features = preprocessAudioData(audioFile, fs);

features = features(:)';

predictedLabel = svmModel.predict(features);

emotion_labels = {'angry', 'disgust', 'fearful', 'happy', 'neutral', 'sad', 'surprised'};

% Map index to emotion label
predictedLabel = emotion_labels{predictedIndex};

% Display the predicted label
disp(['Predicted emotion: ', predictedLabel]);