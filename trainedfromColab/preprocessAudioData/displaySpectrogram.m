function displaySpectrogram(audioData, fs)
    % Check if audioData is stereo (2 channels)
    if size(audioData, 2) == 2
        % Convert to mono by averaging the two channels
        audioData = mean(audioData, 2); % Take the mean of the two channels
    end

    % Set parameters for the spectrogram
    windowLength = 1024;   % Window length for the STFT
    overlapLength = round(windowLength / 2);  % Overlap between windows
    nfft = 1024;  % Number of FFT points

    % Compute the spectrogram
    [s, f, t] = spectrogram(audioData, windowLength, overlapLength, nfft, fs);

    % Convert the magnitude of the spectrogram to decibels
    s_db = 10 * log10(abs(s));

    % Plot the spectrogram
    figure;
    imagesc(t, f, s_db);
    axis xy;  % Flip the y-axis so that low frequencies are at the bottom
    colormap jet;  % Use the 'jet' colormap
    colorbar;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title('Spectrogram');
end
