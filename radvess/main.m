%% Realtime data input from Matlab Mobile

% Create a mobiledev object to interface with your mobile device
m = mobiledev;

% Enable audio recording on the mobile device
m.AudioRecordingEnabled = 1;

% Start logging audio data
m.Logging = 1;

% Pause to capture some audio (e.g., 10 seconds of audio)
pause(10);

% Retrieve the audio data from the mobile device
[audioData, timeStamps] = m.Audio;

% Stop logging after capturing the audio
m.Logging = 0;

% Play the recorded audio (optional)
sound(audioData, m.SampleRate);

%% Preprocess realtime data

% Resample the audio to match the model’s sample rate (if needed)
fsTarget = 16000;  % Target sample rate (used in Colab for training)
audioDataResampled = resample(audioData, fsTarget, m.SampleRate);

% Normalize the audio data
audioDataNormalized = audioDataResampled / max(abs(audioDataResampled));

% Initialize an audio feature extractor for MFCC features
afe = audioFeatureExtractor('SampleRate', fsTarget, 'mfcc', true, 'mfccDelta', true);

% Extract MFCC features from the audio data
mfccFeatures = extract(afe, audioDataNormalized);

% You may need to reshape or average the features based on your SVM model’s input requirements
mfccFeaturesAvg = mean(mfccFeatures, 1);  % Take average across frames if necessary


%% Load dataset

dataFolder = '/Users/phamdoanphuonganh/Desktop/midterm-dsp/midterm-DSP/radvess/Speech Actors 01-24';

% Load audio data and labels from the RAVDESS dataset
ads = audioDatastore(dataFolder, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
ads.Labels = categorical(ads.Labels);  % Ensure labels are categorical

% Initialize arrays to store extracted information
emotions = [];
actors = [];
genders = [];
emotionalIntensities = [];

% Loop through the audio files and extract metadata from the filenames
for i = 1:length(ads.Files)
    % Extract the filename without the path
    [~, filename, ~] = fileparts(ads.Files{i});
    
    % Parse the filename, assuming it follows the format:
    % Modality_VocalChannel_Emotion_EmotionIntensity_Statement_Repetition_Actor.wav
    tokens = strsplit(filename, '-');
    
    % Extract relevant metadata
    emotion = str2double(tokens{3});  % Emotion (01 to 08)
    emotionalIntensity = str2double(tokens{4});  % Emotional intensity (01 or 02)
    actor = str2double(tokens{7});  % Actor (01 to 24)
    
    % Gender based on actor number (odd = male, even = female)
    if mod(actor, 2) == 0
        gender = 'Female';
    else
        gender = 'Male';
    end
    
    % Append to the arrays
    emotions = [emotions; emotion];
    actors = [actors; actor];
    genders = [genders; {gender}];
    emotionalIntensities = [emotionalIntensities; emotionalIntensity];
end

%% Plot the data
% 1. Distribution of emotions
emotionCategories = {'Neutral', 'Calm', 'Happy', 'Sad', 'Angry', 'Fearful', 'Disgust', 'Surprised'};
emotionCounts = histcounts(emotions, 1:9);  % Count occurrences of each emotion

figure;
bar(categorical(emotionCategories), emotionCounts);
title('Distribution of Emotions in the RAVDESS Dataset');
xlabel('Emotion');
ylabel('Count');

% 2. Distribution of actors (male vs female)
genderCategories = {'Male', 'Female'};
genderCounts = [sum(strcmp(genders, 'Male')), sum(strcmp(genders, 'Female'))];

figure;
bar(categorical(genderCategories), genderCounts);
title('Distribution of Genders in the RAVDESS Dataset');
xlabel('Gender');
ylabel('Count');

% 3. Distribution of emotional intensity
intensityCategories = {'Normal', 'Strong'};
intensityCounts = histcounts(emotionalIntensities, 1:3);

figure;
bar(categorical(intensityCategories), intensityCounts);
title('Distribution of Emotional Intensity in the RAVDESS Dataset');
xlabel('Emotional Intensity');
ylabel('Count');

% 4. Distribution of actors
figure;
histogram(actors, 'BinMethod', 'integers');
title('Distribution of Actors in the RAVDESS Dataset');
xlabel('Actor ID');
ylabel('Count');


%% Data Preprocessing
% Resampling
for i = 1:numel(ads.Files)
    [audio, fs] = audioread(ads.Files{i});
    audio = resample(audio, 16000, fs);  % Resample to 16 kHz
end

%Feature extraction using MFCC

afe = audioFeatureExtractor('SampleRate', 16000, 'mfcc', true);
mfccFeatures = extract(afe, audio);  % Extract MFCC features

