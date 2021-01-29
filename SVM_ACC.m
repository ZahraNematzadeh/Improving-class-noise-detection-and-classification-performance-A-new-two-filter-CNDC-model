function [SVM_mean, SVM_STD]= SVM_ACC(pure_data)
x= pure_data (:,1:end-1);
y= pure_data (:,end);
Pass=10;
Kfold=10;
for j=1:Pass
    indices = crossvalind('Kfold',y,Kfold);
    for i = 1:10
     testix = (indices == i); trainix = ~testix;
     xtrain = x(trainix,:);  ytrain = y(trainix);
     xtest  = x(testix,:);  ytest  = y(testix); 
     options = optimset('maxiter',1000); % SVM-RBF kernel
     svmStruct = svmtrain(xtrain, ytrain, ...
         'Autoscale',true, 'Showplot',false, 'Method','QP', ...
         'BoxConstraint',2e-1, 'Kernel_Function','rbf', 'rbf_sigma',1,'quadprog_opts', options );  
     predrbf = svmclassify(svmStruct,xtest, 'Showplot',false);    
     cMat = confusionmat(ytest,predrbf);
     s=size(cMat);
     if s>1
         Accuracy = (cMat(1,1)+cMat(2,2))./(cMat(1,1)+cMat(1,2)+cMat(2,1)+cMat(2,2));
         SVMPerf((j-1).*Kfold+i,:) = Accuracy;
     else
         Accuracy = 1;
         SVMPerf((j-1).*Kfold+i,:) = Accuracy;
     end
    end
end
SVM_mean=mean(SVMPerf)*100;
SVM_STD= std(SVMPerf);
end
