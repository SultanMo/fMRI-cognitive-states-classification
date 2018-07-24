clear all
for subject=1:6
    switch(subject)
        case 1
            load('data-starplus-04799-v7.mat')
            single_subject_classification_final
            acc1= optimize_range(X_P,X_S,Y);
        case 2
            load('data-starplus-04820-v7.mat')
            single_subject_classification_final
            acc2= optimize_range(X_P,X_S,Y);
        case 3
            load('data-starplus-04847-v7.mat')
            single_subject_classification_final
            acc3= optimize_range(X_P,X_S,Y);
        case 4
            load('data-starplus-05675-v7.mat')
            single_subject_classification_final
            acc4= optimize_range(X_P,X_S,Y);
        case 5
            load('data-starplus-05680-v7.mat')
            single_subject_classification_final
            acc5= optimize_range(X_P,X_S,Y);
        case 6
            load('data-starplus-05710-v7.mat')
            single_subject_classification_final
            acc6= optimize_range(X_P,X_S,Y);
    end
end

acc= [acc1;acc2;acc3;acc4;acc5;acc6];