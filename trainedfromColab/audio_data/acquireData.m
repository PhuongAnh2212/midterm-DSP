% Define the path to the file stored in MATLAB Drive
audioFile = fullfile('~/MATLAB Drive', 'your_audio_file.wav'); % Adjust the path and file name

% Read the audio file
[audioData, fs] = audioread(audioFile);

% Play the audio file
sound(audioData, fs);

% Optional: Process the audio further, e.g., emotion recognition
