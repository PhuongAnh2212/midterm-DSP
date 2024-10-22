function mfccFeatures = preprocessAudioData(audioData, fs)
    % Check if audioData is stereo (2 channels)
    if size(audioData, 2) == 2
        % Convert to mono by averaging the two channels
        audioData = mean(audioData, 2); % Take the mean of the two channels
    end

    % Set window length and overlap
    windowLength = 1024; % Example of a fixed window length
    overlapLength = round(windowLength / 2); % Example overlap length
    
    % Create a Hamming window of the specified length
    window = hamming(windowLength, 'periodic');
    
    % Check audio length
    audioLength = size(audioData, 1);
    disp(['Audio Length: ', num2str(audioLength)]);

    % Ensure window length is valid
    if windowLength < 2 || windowLength > size(audioData, 1)
        error('Invalid window length. It must be in the range [2, size(audioData, 1)].');
    end

    % Extract MFCC features using the Hamming window
    mfccFeatures = mfcc(audioData, fs, 'Window', window, 'OverlapLength', overlapLength);

    % Normalize the MFCCs
    mfccFeatures = (mfccFeatures - mean(mfccFeatures, 1)) ./ std(mfccFeatures, [], 1);
end
