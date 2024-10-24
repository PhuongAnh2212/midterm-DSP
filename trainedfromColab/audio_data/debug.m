% Get audio file info
audioFile = '/Users/phamdoanphuonganh/Desktop/midterm-dsp/midterm-DSP/trainedfromColab/audio_data/OAF_bar_happy.wav'; % Update with your audio file path

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