clear all
load('data-starplus-04799-v7.mat')

trials=find([info.cond]>1); % The trials of S and P 

%% Returns data for specified trials
[info0,data0,meta0]=transformIDM_selectTrials(info,data,meta,trials);

%% Take the average of each ROIs
 [infoAvg,dataAvg,metaAvg] = transformIDM_avgROIVoxels(info0,data0,meta0,{'CALC' 'LIPL' 'LT' 'LTRIA' 'LOPER' 'LIPS' 'LDLPFC'});

%% Returns data for specified firstStimulus
[infoP,dataP,metaP]=transformIDM_selectTrials(infoAvg,dataAvg,metaAvg,find([infoAvg.firstStimulus]=='P'));
[infoS,dataS,metaS]=transformIDM_selectTrials(infoAvg,dataAvg,metaAvg,find([infoAvg.firstStimulus]=='S'));

%% Returns IDM for the 1st 8 seconds 
[infoP1,dataP1,metaP1]=transformIDM_selectTimewindow(infoP,dataP,metaP,[1:16]);
[infoS1,dataS1,metaS1]=transformIDM_selectTimewindow(infoS,dataS,metaS,[1:16]);

%% Returns IDM for the 2nd 8 seconds 
[infoP2,dataP2,metaP2]=transformIDM_selectTimewindow(infoS,dataS,metaS,[17:32]);
[infoS2,dataS2,metaS2]=transformIDM_selectTimewindow(infoP,dataP,metaP,[17:32]);

%% Normalize each snapshot
% [infoP1,dataP1,metaP1] = transformIDMalizeTrials(infoP1,dataP1,metaP1);
% [infoP2,dataP2,metaP2] = transformIDMalizeTrials(infoP2,dataP2,metaP2);
% [infoS1,dataS1,metaS1] = transformIDMalizeTrials(infoS1,dataS1,metaS1);
% [infoS2,dataS2,metaS2] = transformIDMalizeTrials(infoS2,dataS2,metaS2);

%% Create X and labels, data is converted to X by concatenating the multiple data rows to one single row
[X_P1,labelsP1,exInfoP1]=idmToExamples_condLabel(infoP1,dataP1,metaP1);
[X_P2,labelsP2,exInfoP2]=idmToExamples_condLabel(infoP2,dataP2,metaP2);
[X_S1,labelsS1,exInfoS1]=idmToExamples_condLabel(infoS1,dataS1,metaS1);
[X_S2,labelsS2,exInfoS2]=idmToExamples_condLabel(infoS2,dataS2,metaS2);

%% combine X and create labels.  Label 'picture' 1, label 'sentence' 2.
X_P=[X_P1;X_P2]; %X_P1 is the 1st 8s and X_P2 for 2nd 8s for firstStimulus='P'
X_S=[X_S1;X_S2]; %X_S1 is the 1st 8s and X_S2 for 2nd 8s for firstStimulus='S'
labelsP=ones(size(X_P,1),1);
labelsS=ones(size(X_S,1),1)+1;
X=[X_P;X_S];
Y=[labelsP;labelsS];

%% Shuffle data
[X,Y,shuffledRow] = shuffleRow(X,Y);

% %% Run Classification
% for l=1:10
%     Acc(l)=Apply_GNB(0.72, X, Y);
%     plot(Acc);
% end
%% Append Amplitude of fourier transform to the features
[X_FT, Max_X_FT, I]= apply_fourier(X);
X(:, size(X,2)+1)= Max_X_FT(:,1);


%% Apply GNB

[classifier] = trainClassifier(X,Y,'nbayes');   %train classifier
[predictions] = applyClassifier(X,classifier);       %test it
[result,predictedLabels,trace] = summarizePredictions(predictions,classifier,'averageRank',Y);
1-result{1}  % rank accuracy
