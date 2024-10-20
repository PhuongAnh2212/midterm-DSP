function featureSequences = HelperFeatureVector2Sequence(features, sequenceLength, overlap)
    % Helper function to convert feature vectors to sequences for training/prediction
    % Parameters:
    %   features - The feature matrix (features x time)
    %   sequenceLength - Length of each sequence
    %   overlap - Number of overlapping frames
    
    % Calculate the number of sequences
    numFeatures = size(features, 2);
    numSequences = floor((size(features, 1) - sequenceLength) / (sequenceLength - overlap)) + 1;
    
    % Preallocate the output
    featureSequences = zeros(sequenceLength, numFeatures, numSequences);
    
    for i = 1:numSequences
        startIndex = (i - 1) * (sequenceLength - overlap) + 1; % Calculate start index
        featureSequences(:, :, i) = features(startIndex:startIndex + sequenceLength - 1, :); % Store sequence
    end
end
