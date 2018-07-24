single_subject_classification_test
% function PWM= Generate_PWM(X,Y)
addpath ./Leave1out_PWM


% global PWM_P PWM_S
for i=1:size(X(1:40,:),1)
    for j=1:size(X,2)
        if X(i,j) <= -1
            X(i,j)= 1;
        elseif X(i,j) <= -1
            X(i,j)= 2;
        elseif X(i,j) <= 0 %check for -0.6
            X(i,j)= 3;
        elseif X(i,j) < 3
            X(i,j)= 4;
        else 
            X(i,j)= 5;
        end
    end
end

for i=41:size(X,1)
    for j=1:size(X,2)
        if X(i,j) <= -3
            X(i,j)= 1;
        elseif X(i,j) <= -1
            X(i,j)= 2;
        elseif X(i,j) <= 1
            X(i,j)= 3;
        elseif X(i,j) < 3
            X(i,j)= 3;
        else 
            X(i,j)= 4;
        end
    end
end

catogries= 5;


C = cvpartition(Y, 'LeaveOut');

for num_fold = 1:C.NumTestSets
    clearvars -except X Y catogries PWM_P PWM_S acc1 num_fold C
    PWM_P= zeros(catogries, size(X,2));
    PWM_S= zeros(catogries, size(X,2));
    PWM= zeros(size(X,1),2);
    
    trIdx = C.training(num_fold);
    teIdx = C.test(num_fold);
    Idx= find(teIdx);
    X_train= X(trIdx,:);
    X_test= X(teIdx,:);
    Y_train= Y(trIdx);
    Y_test= Y(teIdx);
    
    if (Idx>=41) && (Idx<=80) % the test from a sentence sample
        for i=1:size(X_train, 2)
            PWM_P(1,i)= sum(X_train(1:40, i) == 1)/40;
            PWM_P(2,i)= sum(X_train(1:40, i) == 2)/40;
            PWM_P(3,i)= sum(X_train(1:40, i) == 3)/40;
            PWM_P(4,i)= sum(X_train(1:40, i) == 4)/40;
            PWM_P(5,i)= sum(X_train(1:40, i) == 5)/40;
        end
        
        for i=1:size(X_train, 2)
            PWM_S(1,i)= sum(X_train(41:79, i) == 1)/39;
            PWM_S(2,i)= sum(X_train(41:79, i) == 2)/39;
            PWM_S(3,i)= sum(X_train(41:79, i) == 3)/39;
            PWM_S(4,i)= sum(X_train(41:79, i) == 4)/39;
            PWM_S(5,i)= sum(X_train(41:79, i) == 5)/39;
        end
        
    else % the test from a picture sample
        for i=1:size(X_train, 2)
            PWM_P(1,i)= sum(X_train(1:39, i) == 1)/39;
            PWM_P(2,i)= sum(X_train(1:39, i) == 2)/39;
            PWM_P(3,i)= sum(X_train(1:39, i) == 3)/39;
            PWM_P(4,i)= sum(X_train(1:39, i) == 4)/39;
            PWM_P(5,i)= sum(X_train(1:39, i) == 5)/39;
        end
        
        for i=1:size(X_train, 2)
            PWM_S(1,i)= sum(X_train(40:79, i) == 1)/40;
            PWM_S(2,i)= sum(X_train(40:79, i) == 2)/40;
            PWM_S(3,i)= sum(X_train(40:79, i) == 3)/40;
            PWM_S(4,i)= sum(X_train(40:79, i) == 4)/40;
            PWM_S(5,i)= sum(X_train(40:79, i) == 5)/40;
        end 
    end
    
% the test from a sentence sample
    if (Idx>=41) && (Idx<=80)
        PWM_P_ex= zeros(80, size(X,2));
        PWM_S_ex= zeros(78, size(X,2)); 
        PWM_ex= zeros(80,2);
        PWM_S_ex_test= zeros(2,size(X,2));
        PWM_ex_test= zeros(2,1);
        
        for i=1:(size(X,1)/2) %1->40
            for j=1:size(X,2)
                if X_train(i,j)==1
                    PWM_P_ex(i,j)= PWM_P(1,j);
                    PWM_P_ex(i+(size(X,1)/2),j)= PWM_S(1,j);
                elseif X_train(i,j)==2
                    PWM_P_ex(i,j)= PWM_P(2,j);
                    PWM_P_ex(i+(size(X,1)/2),j)= PWM_S(2,j);
                elseif X_train(i,j)==3
                    PWM_P_ex(i,j)= PWM_P(3,j);
                    PWM_P_ex(i+(size(X,1)/2),j)= PWM_S(3,j);
                elseif X_train(i,j)==4
                    PWM_P_ex(i,j)= PWM_P(4,j);
                    PWM_P_ex(i+(size(X,1)/2),j)= PWM_S(4,j);
                elseif X_train(i,j)==5
                    PWM_P_ex(i,j)= PWM_P(5,j);
                    PWM_P_ex(i+(size(X,1)/2),j)= PWM_S(5,j);
                end
            end
        end
        for i=41:79
            for j=1:size(X,2)
                if X_train(i,j)==1
                    PWM_S_ex(i-(size(X,1)/2),j)= PWM_S(1,j);
                    PWM_S_ex(i-1,j)= PWM_P(1,j);
                elseif X_train(i,j)==2
                    PWM_S_ex(i-(size(X,1)/2),j)= PWM_S(2,j);
                    PWM_S_ex(i-1,j)= PWM_P(2,j);
                elseif X_train(i,j)==3
                    PWM_S_ex(i-(size(X,1)/2),j)= PWM_S(3,j);
                    PWM_S_ex(i-1,j)= PWM_P(3,j);
                elseif X_train(i,j)==4
                    PWM_S_ex(i-(size(X,1)/2),j)= PWM_S(4,j);
                    PWM_S_ex(i-1,j)= PWM_P(4,j);
                elseif X_train(i,j)==5
                    PWM_S_ex(i-(size(X,1)/2),j)= PWM_S(5,j);
                    PWM_S_ex(i-1,j)= PWM_P(5,j);
                end
            end
        end
        for i=1:size(X,2)
                if X_test(1,j)==1
                    PWM_S_ex_test(1,i)= PWM_S(1,i);
                    PWM_S_ex_test(2,i)= PWM_P(1,i);
                elseif X_test(1,j)==2
                    PWM_S_ex_test(1,i)= PWM_S(2,j);
                    PWM_S_ex_test(2,i)= PWM_P(2,i);
                elseif X_test(1,j)==3
                    PWM_S_ex_test(1,i)= PWM_S(3,i);
                    PWM_S_ex_test(2,i)= PWM_P(3,i);
                elseif X_test(1,j)==4
                    PWM_S_ex_test(1,i)= PWM_S(4,i);
                    PWM_S_ex_test(2,i)= PWM_P(4,i);
                elseif X_test(1,j)==5
                    PWM_S_ex_test(1,i)= PWM_S(5,i);
                    PWM_S_ex_test(2,i)= PWM_P(5,i);
                end
        end
                
        
        for i=1:size(PWM_P_ex,1)
            PWM_ex(i,1)=sum(PWM_P_ex(i,:));
        end
        
        for i=1:size(PWM_S_ex,1)
            PWM_ex(i,2)=sum(PWM_S_ex(i,:));
        end
        %sum the test(sentence) columns to obtain the PWM feature
        PWM_ex_test(1,1)= sum(PWM_S_ex_test(1,:)); %+ve
        PWM_ex_test(2,1)= sum(PWM_S_ex_test(2,:)); %-ve

        PWM(1:40,1)=PWM_ex(1:40,1);
        PWM(1:40,2)=PWM_ex(41:80,1);
        PWM(41:79,1)=PWM_ex(1:39,2);
        PWM(41:79,2)=PWM_ex(40:78,2);
        PWM(80,1)= PWM_ex_test(1,1);
        PWM(80,2)= PWM_ex_test(2,1);
        
% the test from a picture sample
    elseif (Idx>=0) && (Idx<=40)
        PWM_P_ex= zeros(78, size(X,2));
        PWM_S_ex= zeros(80, size(X,2));
        PWM_ex= zeros(80,2);
        PWM_P_ex_test= zeros(2, size(X,2));
        PWM_ex_test=zeros(2,1);
        
        for i=1:(size(X,1)/2) %1->40
            for j=1:size(X,2)
                if X_train(i+(size(X,1)/2)-1,j)==1
                    PWM_S_ex(i,j)= PWM_S(1,j);
                    PWM_S_ex(i+(size(X,1)/2),j)= PWM_P(1,j);
                elseif X_train(i+(size(X,1)/2)-1,j)==2
                    PWM_S_ex(i,j)= PWM_S(2,j);
                    PWM_S_ex(i+(size(X,1)/2),j)= PWM_P(2,j);
                elseif X_train(i+(size(X,1)/2)-1,j)==3
                    PWM_S_ex(i,j)= PWM_S(3,j);
                    PWM_S_ex(i+(size(X,1)/2),j)= PWM_P(3,j);
                elseif X_train(i+(size(X,1)/2)-1,j)==4
                    PWM_S_ex(i,j)= PWM_S(4,j);
                    PWM_S_ex(i+(size(X,1)/2),j)= PWM_P(4,j);
                elseif X_train(i+(size(X,1)/2)-1,j)==5
                    PWM_S_ex(i,j)= PWM_S(5,j);
                    PWM_S_ex(i+(size(X,1)/2),j)= PWM_P(5,j);
                end
            end
        end
        
        for i=1:39
            for j=1:size(X,2)
                if X_train(i,j)==1
                    PWM_P_ex(i,j)= PWM_P(1,j);
                    PWM_P_ex(i+(size(X,1)/2)-1,j)= PWM_S(1,j);
                elseif X_train(i,j)==2
                    PWM_P_ex(i,j)= PWM_P(2,j);
                    PWM_P_ex(i+(size(X,1)/2)-1,j)= PWM_S(2,j);
                elseif X_train(i,j)==3
                    PWM_P_ex(i,j)= PWM_P(3,j);
                    PWM_P_ex(i+(size(X,1)/2)-1,j)= PWM_S(3,j);
                elseif X_train(i,j)==4
                    PWM_P_ex(i,j)= PWM_P(4,j);
                    PWM_P_ex(i+(size(X,1)/2)-1,j)= PWM_S(4,j);
                elseif X_train(i,j)==5
                    PWM_P_ex(i,j)= PWM_P(5,j);
                    PWM_P_ex(i+(size(X,1)/2)-1,j)= PWM_S(5,j);
                end
            end
        end
        for i=1:size(X,2)
                if X_test(1,i)==1
                    PWM_P_ex_test(1,i)= PWM_P(1,i);
                    PWM_P_ex_test(2,i)= PWM_S(1,i);
                elseif X_test(1,i)==2
                    PWM_P_ex_test(1,i)= PWM_P(2,j);
                    PWM_P_ex_test(2,i)= PWM_S(2,i);
                elseif X_test(1,i)==3
                    PWM_P_ex_test(1,i)= PWM_P(3,i);
                    PWM_P_ex_test(2,i)= PWM_S(3,i);
                elseif X_test(1,i)==4
                    PWM_P_ex_test(1,i)= PWM_P(4,i);
                    PWM_P_ex_test(2,i)= PWM_S(4,i);
                elseif X_test(1,i)==5
                    PWM_P_ex_test(1,i)= PWM_P(5,i);
                    PWM_P_ex_test(2,i)= PWM_S(5,i);
                end
        end
                
        for i=1:size(PWM_P_ex,1)
            PWM_ex(i,1)=sum(PWM_P_ex(i,:));
        end
        
        for i=1:size(PWM_S_ex,1)
            PWM_ex(i,2)=sum(PWM_S_ex(i,:));
        end
        
        %sum the test(picture) columns to obtain the PWM feature
        PWM_ex_test(1,1)= sum(PWM_P_ex_test(1,:)); %+ve
        PWM_ex_test(2,1)= sum(PWM_P_ex_test(2,:)); %-ve

        PWM(1:39,1)=PWM_ex(1:39,1);
        PWM(1:39,2)=PWM_ex(40:78,1);
        PWM(40:79,1)=PWM_ex(1:40,2);
        PWM(40:79,2)=PWM_ex(41:80,2);
        PWM(80,1)= PWM_ex_test(1,1);
        PWM(80,2)= PWM_ex_test(2,1);
        
    end
    
    [classifier] = trainClassifier(PWM(1:79,:),Y_train, 'nbayes');   %train classifier
    [predictions] = applyClassifier(PWM(80,:), classifier);       %test it
    [result,predictedLabels,trace] = summarizePredictions(predictions,classifier,'averageRank',Y_test);
    acc1(num_fold)= 1-result{1};  % rank accuracy

        
end

acc= sum(acc1)/sum(C.TestSize);
