% Script: visualizeData.m
% Load the dataset
dataFolder = "/Users/phamdoanphuonganh/Desktop/midterm-dsp/midterm-DSP/test";
dataset = fullfile(dataFolder, "Emo-DB");

% Create an audio datastore for the 'wav' folder
ads = audioDatastore(fullfile(dataset, "wav"));

% Extract file paths
filepaths = ads.Files;

% Extract emotion codes (based on filename convention)
emotionCodes = cellfun(@(x)x(end-5), filepaths, 'UniformOutput', false);

% Map emotion codes to their corresponding labels
emotions = replace(emotionCodes, ["W","L","E","A","F","T","N"], ...
    ["Anger","Boredom","Disgust","Anxiety/Fear","Happiness","Sadness","Neutral"]);

% Extract speaker codes
speakerCodes = cellfun(@(x)x(end-10:end-9), filepaths, 'UniformOutput', false);

% Create a table with speaker and emotion labels
labelTable = cell2table([speakerCodes, emotions], 'VariableNames', ["Speaker", "Emotion"]);
labelTable.Emotion = categorical(labelTable.Emotion);
labelTable.Speaker = categorical(labelTable.Speaker);

% Display a summary of the table
summary(labelTable);

% Assign the labels to the audio datastore
ads.Labels = labelTable;

% Visualize the emotion distribution with a bar chart
emotionCounts = countcats(labelTable.Emotion);
emotionLabels = categories(labelTable.Emotion);

figure;
bar(emotionCounts);
set(gca, 'XTickLabel', emotionLabels);
xlabel('Emotion');
ylabel('Count');
title('Emotion Distribution in the Dataset');

% Open the labelTable in the Variable Editor for inspection
openvar('labelTable');
