function mfccFeatures = preprocessAudioData(audioData, fs, windowLength)
    % Check if audioData is stereo (2 channels)
    if size(audioData, 2) == 2
        % Convert to mono by averaging the two channels
        audioData = mean(audioData, 2); % Take the mean of the two channels
    end

    % Display audio length
    audioLength = size(audioData, 1);
    disp(['Audio Length for preprocessing: ', num2str(audioLength)]);

    % Ensure the window length is valid
    if windowLength < 2 || windowLength > audioLength
        error('Invalid window length. It must be in the range [2, audioLength].');
    end

    % Set overlap length for the window
    overlapLength = round(windowLength / 2); % Example overlap length
    
    % Create a Hamming window of the specified length
    window = hamming(windowLength, 'periodic');
    
    % Extract MFCC features using the Hamming window
    mfccFeatures = mfcc(audioData, fs, 'Window', window, 'OverlapLength', overlapLength, 'NumCoeffs', 40);

    % Normalize the MFCCs
    mfccFeatures = (mfccFeatures - mean(mfccFeatures, 1)) ./ std(mfccFeatures, [], 1);

    % Debugging: Ensure the output size is correct
    disp(['Size of MFCC Features before mean: ', num2str(size(mfccFeatures))]); % Should be [num_frames, 40 or 41]

    % If necessary, take the mean of the MFCC features across the time axis
    mfccFeatures = mean(mfccFeatures, 1); % This will output a 1x40 (or 41) feature vector

    % Check the size after mean
    disp(['Size of MFCC Features after mean: ', num2str(size(mfccFeatures))]); % Should be [1, 40 or 41]

    % Trim to exactly 40 features if more than 40 are produced
    if size(mfccFeatures, 2) > 40
        mfccFeatures = mfccFeatures(1, 1:40); % Keep only the first 40 features
    elseif size(mfccFeatures, 2) < 40
        error('The number of MFCC features is less than 40.');
    end
end
