% Specify the file path
filePath = 'sensorlog_20241022_180302.m4a';

% Read the audio file
[audioData, sampleRate] = audioread(filePath);

size(audioData)

% Create a time vector based on the sample rate
timeVector = (0:length(audioData)-1) / sampleRate;

% Create a figure
figure;

% Plot the left channel
subplot(2, 1, 1); % 2 rows, 1 column, 1st subplot
plot(timeVector, audioData(:, 1), 'b'); % Left channel in blue
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Left Channel Waveform');
grid on;

% Plot the right channel
subplot(2, 1, 2); % 2 rows, 1 column, 2nd subplot
plot(timeVector, audioData(:, 2), 'r'); % Right channel in red
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Right Channel Waveform');
grid on;

% Adjust layout
sgtitle('Audio Waveforms of Left and Right Channels'); % Overall title

