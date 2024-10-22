function predictedEmotion = predictEmotion(mfccFeatures, model)
    % Predict emotion using the pre-trained SVM model
    mfccFlattened = mfccFeatures(:)';
    predictedLabel = predict(model, mfccFlattened);
    
    % Map predicted label to emotion name
    emotions = {'angry', 'happy', 'sad', 'neutral', 'fearful', 'surprised'};
    predictedEmotion = emotions{predictedLabel};
end
