dataFolder = "/Users/phamdoanphuonganh/Desktop/midterm-dsp/midterm-DSP/test";
dataset = fullfile(dataFolder, "Emo-DB");


% Check if the dataset already exists (use 'exist' instead of 'datasetExists')
if ~exist(dataset, 'dir')  % 'dir' checks if it's a directory
    url = "http://emodb.bilderbar.info/download/download.zip";
    disp("Downloading Emo-DB (40.5 MB) ...")
    
    % Unzip the dataset into the specified folder
    unzip(url, dataset)
else
    disp("Dataset already exists.")
end

ads = audioDatastore(fullfile(dataset,"wav"));

filepaths = ads.Files;
emotionCodes = cellfun(@(x)x(end-5),filepaths,UniformOutput=false);
emotions = replace(emotionCodes,["W","L","E","A","F","T","N"], ...
    ["Anger","Boredom","Disgust","Anxiety/Fear","Happiness","Sadness","Neutral"]);

speakerCodes = cellfun(@(x)x(end-10:end-9),filepaths,UniformOutput=false);
labelTable = cell2table([speakerCodes,emotions],VariableNames=["Speaker","Emotion"]);
labelTable.Emotion = categorical(labelTable.Emotion);
labelTable.Speaker = categorical(labelTable.Speaker);
summary(labelTable)
ads.Labels = labelTable;


% Load the pre-trained network
downloadFolder = matlab.internal.examples.downloadSupportFile("audio/examples","serbilstm.zip");
dataFolder = tempdir;  % Temporary directory for unzipping
unzip(downloadFolder, dataFolder); % Unzip the model
load(fullfile(dataFolder, "network_Audio_SER.mat")); % Load the network


disp(class(net));  % Display the class of the loaded net

ads = audioDatastore(fullfile(dataset, "wav"));
filepaths = ads.Files;
emotionCodes = cellfun(@(x)x(end-5),filepaths,UniformOutput=false);
emotions = replace(emotionCodes,["W","L","E","A","F","T","N"], ...
    ["Anger","Boredom","Disgust","Anxiety/Fear","Happiness","Sadness","Neutral"]);

speakerCodes = cellfun(@(x)x(end-10:end-9),filepaths,UniformOutput=false);
labelTable = cell2table([speakerCodes,emotions],VariableNames=["Speaker","Emotion"]);
labelTable.Emotion = categorical(labelTable.Emotion);
labelTable.Speaker = categorical(labelTable.Speaker);
summary(labelTable)
ads.Labels = labelTable;

% Define Hamming window
windowLength = 400;
hammingWindow = 0.54 - 0.46 * cos(2 * pi * (0:windowLength-1)' / (windowLength-1));

numCoefficients = 23;  % Set to match network's expected input size

% Example configuration to extract 40 features
afe = audioFeatureExtractor( ...
    'SampleRate', 16000, ...
    'Window', hamming(400, 'periodic'), ...
    'OverlapLength', 200, ...
    'mfcc', true, ...                     % Mel-frequency cepstral coefficients
    'spectralCentroid', true, ...         % Spectral centroid
    'spectralRolloff', true, ...          % Spectral rolloff
    'spectralFlux', true, ...             % Spectral flux
    'pitch', true);                       % Pitch features

% This should total to 40 features when configured correctly.


fs = afe.SampleRate;
disp(fs);

speaker = categorical("03");
emotion = categorical("Anger");

adsSubset = subset(ads,ads.Labels.Speaker==speaker & ads.Labels.Emotion==emotion);

audio = read(adsSubset);
sound(audio,fs)

% Step 1: Extract features
features = extract(afe, audio);
disp(size(features));  % Check the size of extracted features

% Ensure featureSequences is shaped correctly
if size(features, 2) ~= 17  % Or the expected number of features
    error('Feature sequences do not have the correct size.');
end

% Step 2: Define normalizers
normalizers.Mean = mean(features, 1);
normalizers.StandardDeviation = std(features, 0, 1);

% Step 3: Normalize features
featuresNormalized = (features - normalizers.Mean) ./ normalizers.StandardDeviation;

% Ensure featuresNormalized has the correct shape
disp(size(featuresNormalized));  % Check normalized features

% Prepare feature sequences for the model
numOverlap = 10;
sequenceLength = 20;
featureSequences = HelperFeatureVector2Sequence(featuresNormalized, sequenceLength, numOverlap);
disp(size(featureSequences));  % Check the shape of feature sequences

% Ensure the feature sequences have the expected channel dimension
YPred = double(minibatchpredict(net, featureSequences));

% Step 6: Aggregate predictions
average = "mode";
switch average
    case "mean"
        probs = mean(YPred, 1);
    case "median"
        probs = median(YPred, 1);
    case "mode"
        probs = mode(YPred, 1);
end

% Step 7: Visualize the results
pie(probs ./ sum(probs));
legend(string(classes), 'Location', 'eastoutside');
