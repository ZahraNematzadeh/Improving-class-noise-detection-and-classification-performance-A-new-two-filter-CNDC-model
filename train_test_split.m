function [xtest,ytest,xtrain, ytrain,b3]=train_test_split(i,n3,d,r3,data2,l)
%train and test splitting: random without replacement
if i<5
    b3=d(l+1:i*r3);
else
    b3=d(l+1:n3);
end
test=data2(b3,:);
[~,u3]=setdiff(d,b3);
train=data2(u3,:);
xtest=test(:,1:end-1);
ytest= test(:,end);
xtrain=train(:,1:end-1);
ytrain=train(:,end); 
end