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

% Recreate the audioFeatureExtractor with the manually defined Hamming window
afe = audioFeatureExtractor( ...
    'SampleRate', 16000, ...               % Adjust sample rate as needed
    'Window', hammingWindow, ...           % Manually defined Hamming window
    'OverlapLength', 200, ...              % Adjust overlap length
    'mfcc', true);                         % Extract MFCC features (adjust as needed)

fs = afe.SampleRate;
disp(fs);

speaker = categorical("03");
emotion = categorical("Anger");

adsSubset = subset(ads,ads.Labels.Speaker==speaker & ads.Labels.Emotion==emotion);

audio = read(adsSubset);
sound(audio,fs)

% Step 1: Extract features
features = extract(afe, audio);

% Step 2: Define normalizers
normalizers.Mean = mean(features, 1);
normalizers.StandardDeviation = std(features, 0, 1);

% Step 3: Normalize features
featuresNormalized = (features - normalizers.Mean) ./ normalizers.StandardDeviation;

% Step 4: Prepare feature sequences
numOverlap = 10;
sequenceLength = 20;
featureSequences = HelperFeatureVector2Sequence(featuresNormalized, sequenceLength, numOverlap); % Ensure this line works

% Step 5: Predict using the network
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
