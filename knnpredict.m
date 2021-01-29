function knnPred= knnpredict(xtrain,xunseen,ytrain)

trainData= xtrain;
testData=xunseen;
trainClass = ytrain;

%# compute pairwise distances between each test instance vs. all training data
D = pdist2(testData, trainData, 'euclidean');
[D,idx] = sort(D, 2, 'ascend');

%# K nearest neighbors
if(size(D,2)<10)
    K=size(D,2);
else 
    K = 10;
end
D = D(:,1:K);
idx = idx(:,1:K);

%# majority vote
if (size(xunseen,1)==1)
    pred_Knn = mode(trainClass(idx));
else
    pred_Knn = mode(trainClass(idx),2);
end 
knnPred = pred_Knn; 


