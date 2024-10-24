function analyzeAudioFeatures(audioFile)
    % Read the audio file
    [audioData, fs] = audioread(audioFile);
    
    % Display basic information
    disp('Audio File Information:');
    info = audioinfo(audioFile);
    disp(info);

    % Extract pitch using autocorrelation method
    pitch = extractPitch(audioData, fs);
    disp(['Estimated Pitch: ', num2str(pitch), ' Hz']);
    
    % Extract MFCC features for tone analysis
    mfccFeatures = mfcc(audioData, fs);
    disp('Mean MFCC Features:');
    disp(mean(mfccFeatures, 1));  % Print mean of MFCCs

    % Calculate dynamics using RMS
    rmsValue = sqrt(mean(audioData.^2));
    disp(['RMS Energy: ', num2str(rmsValue)]);

    % Optional: Visualizations
    figure;
    subplot(3, 1, 1);
    plot(audioData);
    title('Audio Signal');
    xlabel('Samples');
    ylabel('Amplitude');

    subplot(3, 1, 2);
    plot(mfccFeatures);
    title('MFCC Features');
    xlabel('Frame');
    ylabel('MFCC Coefficients');

    subplot(3, 1, 3);
    bar(pitch);
    title('Estimated Pitch');
    xlabel('Frame');
    ylabel('Pitch (Hz)');
end

function pitch = extractPitch(audioData, fs)
    % Use the autocorrelation method to estimate the pitch
    % This is a basic implementation; for real applications, consider using a library or more advanced methods
    audioData = audioData(:, 1); % Use only one channel if stereo
    frameSize = round(0.03 * fs); % 30 ms frames
    hopSize = round(0.01 * fs);   % 10 ms hop size
    numFrames = floor((length(audioData) - frameSize) / hopSize) + 1;
    
    pitch = zeros(numFrames, 1);
    
    for i = 1:numFrames
        frame = audioData((i-1)*hopSize + 1:(i-1)*hopSize + frameSize);
        % Compute autocorrelation
        autocorr = xcorr(frame, 'biased');
        autocorr = autocorr(frameSize:end); % Only take the second half
        
        % Find the first peak in autocorrelation that corresponds to pitch
        [~, locs] = findpeaks(autocorr);
        if ~isempty(locs)
            fundamentalPeriod = locs(1); % First peak is the fundamental frequency
            pitch(i) = fs / fundamentalPeriod; % Convert to frequency (Hz)
        else
            pitch(i) = 0; % No pitch detected
        end
    end
    
    pitch = mean(pitch(pitch > 0)); % Take mean of detected pitches
end

% Run the analysis on your audio file
audioFile = '/Users/phamdoanphuonganh/Desktop/midterm-dsp/midterm-DSP/trainedfromColab/audio_data/NicoNicoknee.mp3'; % Update with your audio file path
analyzeAudioFeatures(audioFile);
