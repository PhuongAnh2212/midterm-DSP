function mfccFeatures = preprocessAudioData(audioData, fs, windowLength)
    if size(audioData, 2) == 2
        audioData = mean(audioData, 2);
    end

    audioLength = size(audioData, 1);
    disp(['Audio Length for preprocessing: ', num2str(audioLength)]);

    if windowLength < 2 || windowLength > audioLength
        error('Invalid window length. It must be in the range [2, audioLength].');
    end

    overlapLength = round(windowLength / 2);
    
    window = hamming(windowLength, 'periodic');
    
    mfccFeatures = mfcc(audioData, fs, 'Window', window, 'OverlapLength', overlapLength, 'NumCoeffs', 40);

    mfccFeatures = (mfccFeatures - mean(mfccFeatures, 1)) ./ std(mfccFeatures, [], 1);

    disp(['Size of MFCC Features before mean: ', num2str(size(mfccFeatures))]);

    mfccFeatures = mean(mfccFeatures, 1);

    disp(['Size of MFCC Features after mean: ', num2str(size(mfccFeatures))]);

    if size(mfccFeatures, 2) > 40
        mfccFeatures = mfccFeatures(1, 1:40);
    elseif size(mfccFeatures, 2) < 40
        error('The number of MFCC features is less than 40.');
    end
end
