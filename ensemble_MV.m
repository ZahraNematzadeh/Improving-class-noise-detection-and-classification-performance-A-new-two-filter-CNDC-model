 function[inoise_strong,strongnoise_array, inoise_weak,weaknoise_array, inoise,noise_array,noise_free]= ensemble_MV(xtrain,ytrain,xtest,ytest,b3)
compare = [];
SVMPerf = zeros();
SVMPerf = zeros();
NBPerf = zeros();
NNPerf = zeros();
DTPerf = zeros();
knnPerf = zeros();
Maj_V_Perf = zeros(); 
inoise_strong=[];
inoise_weak=[];
inoise=[];x_noise=[];
strongnoise_array=[];
x_sn=[];y_sn=[];
x_wn=[]; y_wn=[];
inoise_strong=[];
weaknoise_array=[];
noise_array=[];
% --------------------- KNN -----------------------------------------------
knnPred = knnpredict(xtrain,xtest,ytrain); 
%------------------- Random Forest500 -------------------------------------
t1 = TreeBagger(500,xtrain,ytrain,'Method', 'classification' ); % RF500
Predtree1 = t1.predict(xtest);
Pred1= str2double (Predtree1);
Pred1(Pred1>=0)=1;
Pred1(Pred1<0)=-1;
%-------------------- Naive bayes------------------------------------------
NBModel = fitcnb(xtrain,ytrain);
NBPred = NBModel.predict(xtest);       
%--------------------- RBF kernel -----------------------------------------
options = optimset('maxiter',1000);
svmStruct = svmtrain(xtrain, ytrain, ...
            'Autoscale',true, 'Showplot',false, 'Method','QP', ...
            'BoxConstraint',2e-1, 'Kernel_Function','rbf', 'rbf_sigma',1,'quadprog_opts', options );  
predrbf = svmclassify(svmStruct,xtest, 'Showplot',false); 
% ------------------------- NN --------------------------------------------
net = newff(minmax(xtrain'),ytrain',100,{'logsig','tansig'},'traingd');
net.trainParam.epochs = 2000; % Number of iteration
net = train(net,xtrain',ytrain');   % training phase         
NNPred = sign(sim(net,xtest'))';
%--------------------- majority voting ------------------------------------
 d =[NBPred(:,:),  predrbf(:,:),Pred1(:,:),NNPred(:,:),knnPred(:,:)];
 [Maj_V_Pred m] = mode(d,2);
 tempResult = [ ytest Maj_V_Pred m];
 compare =  [compare; tempResult];
 n=size (compare,1);
%----------------------- check noise --------------------------------------
f=1;
h=1;
u=1;
tt=1;
rr=1;
r=1 ;
A=0;    % noise array 
A1=0;   % noise free array   
ll=1;
 for i=1:n 
     sum_compare=(compare(i,1) + compare (i,2));
         if sum_compare == 0 % noise detection using ensmeble filtering(majority voting)
               A(r,1)=compare(i,1);
               inoise(ll)=b3(i);  %total noise indices including weak noise and strong noise
               if compare(i,3)==5
                   inoise_strong(tt)=b3(i);% strong noise indices
                   x_sn(tt,:)=xtest(i,:);
                   y_sn(tt,1)=ytest(i);
                   tt=tt+1;
               else
                   inoise_weak(rr)=b3(i);  %weak noise indices
                   x_wn(rr,:)=xtest(i,:);
                   y_wn(rr,1)=ytest(i);
                   rr=rr+1;
               end
               x_noise (h,:) = xtest(i,:);
               y_noise(h,1) = ytest(i);
               r=r+1;
               h=h+1;
               ll=ll+1;
               else
               A1(f,1)=compare(i,1);% noise free indices in each set
               x_nf(u,:)= xtest(i,:);
               y_nf(u,1)= ytest(i);
               f= f+1;
               u=u+1;
          end
 end
%--------------------------------------------------------------------------
     if ~isempty(x_noise)
         noise_array (:,:)= [x_noise,y_noise] ; %  noise array deteced from this phase
     end
     if ~isempty(x_sn)
         strongnoise_array (:,:)=[x_sn, y_sn];
     end
     if ~isempty(x_wn)
         weaknoise_array(:,:)=[x_wn, y_wn];
     end
     pp = unique (noise_array,'rows');
     Numbernoise = size(A, 1);
        if A1(1,1)==0
                noise_free(:,:) = 0;   % noise free array detected from this phase
        else
                noise_free (:,:) = [x_nf, y_nf]; 
        end
        
end
        
        
        