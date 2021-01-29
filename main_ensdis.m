% The following codes detect the noisy instances in whole dataset
% and make the noise free dataset.The whole dataset is categorized into 5 sets,
% and then the noise detection is done on each 20% set.
clc
clear all;
eval_dis=[];
eval_ens=[];
%----------------------------- Dataset ------------------------------------
%    data = xlsread('pima.xlsx',1,'A1:H768');
    data = xlsread('wisconsin.xlsx',1,'A1:I683');
%    data = xlsread('liver.xlsx',1,'A1:F345');
%    data = xlsread('heartstatlog.xlsx',1,'A1:M270');
col =size (data,2);
[data]= normlize (data,col); % normalizing data
xlswrite('normalized.xls', data )
x_initial = data(:,:);
%   y_initial = xlsread('pima.xlsx',1,'I1:I768');
   y_initial = xlsread('wisconsin.xlsx',1,'J1:J683');
%   y_initial = xlsread('liver.xlsx',1,'G1:G345');
%   y_initial  = xlsread('heartstatlog.xlsx',1,'N1:N270');
initial_data=[x_initial, y_initial];
%--------------------- phase1: noise injection ----------------------------
%change the intervals in noise_injection function manually
[x_inject,y_inject,x_process,y_process,num_noise_inject]= noise_injection(x_initial, y_initial); 
data2= [x_process, y_process];      %data2 is the dataset with noise injection based on intervals
%--------------------------------------------------------------------------   
for j=1:10
    d=[];
    noise_ens=[];
    inoise_ens=[];
    inoise_Sens=[];
    inoise_Wens=[];
    strong_noise=[];    
    weak_noise=[];
    SD=[];WD=[];
    noisefree=[];
    n3=size(data2,1);
    r3=floor(0.2*n3);% the whole dataset is categorized into 5 sets, and 
    d=randperm(n3);   % and then the noise detection is done on each 20% set
    l=0;
    for i=1:5  % number of noise detected in set "i" using ensemble filtering
       test=[];
       train=[]; 
       [xtest,ytest,xtrain, ytrain,b3]=train_test_split(i,n3,d,r3,data2,l);
       %------- phase2: noise detection using ensemble filtering (majority voting) --------------
       [inoise_strong,strongnoise_array, inoise_weak,weaknoise_array, inoise,noise_array,noise_free]= ensemble_MV(xtrain,ytrain,xtest,ytest,b3);
       noisefree = [noisefree; noise_free];
       if ~isempty(noise_array)
           noise_ens = [noise_ens; noise_array];
           inoise_ens=[inoise_ens inoise];
       end
%        inoise_Sens=[inoise_Sens inoise_strong];    %strong noise indices
%        inoise_Wens=[inoise_Wens inoise_weak];      % weak noise indices
       SD =[SD;strongnoise_array];
       WD=[WD;weaknoise_array];
       l=i*r3; 
    end
    if ~isempty(noise_ens)
    %--checking number of correctly detected noise using majority voting from injected noise
    [number_correctly_noise]= checking_noise(inoise_ens,noise_ens,num_noise_inject,x_inject,y_inject);
    %--Evaluation of noise detection using one-filter(majority voting)
    noise_size= size (noise_ens,1);
    [pre_ens, rec_ens,fm_ens]= evaluation(noise_size, number_correctly_noise,num_noise_inject); 
    eval_ens(j,:)=[pre_ens rec_ens fm_ens]*100;
    %------------------second filter: distance filtering ------------------
    [noisefinal,inoisedis,noisedis,number_noise,number_correctly_noise]= distance_filtering(noisefree, noise_ens,num_noise_inject,inoise_ens,x_inject,y_inject);
    %----------------------------------------------------------------------
    [weak_noise, strong_noise] = final_noise( number_noise, noisedis, SD, WD);
    %--------- Evaluation of noise detection using Two-filter ------------------------------
    [ pre_dis, rec_dis,fm_dis]= evaluation(number_noise, number_correctly_noise,num_noise_inject);
     eval_dis(j,:)=[pre_dis rec_dis fm_dis]*100;
     end
end
%--------------------- Phase3: Noise Classification ----------------------- 
[pure_data_REM_REL, pure_data_relabeling, pure_data_removing]=noise_classification(strong_noise,weak_noise,data2);
[SVM_mean1, SVM_STD1]=SVM_ACC(pure_data_REM_REL);
[SVM_mean2, SVM_STD2]=SVM_ACC(pure_data_relabeling);
[SVM_mean3, SVM_STD3]=SVM_ACC( pure_data_removing);
[SVM_mean4, SVM_STD4]=SVM_ACC( data2); % noisy data 
[SVM_mean5, SVM_STD5]=SVM_ACC( initial_data); %initial data (before noise injection)
j
out1=['Accuracy_REM_REL = ', num2str(SVM_mean1),' , STD = ', num2str(SVM_STD1)]; disp(out1)
out2=['Accuracy_Relabeling = ',num2str(SVM_mean2), ' , STD = ',num2str(SVM_STD2)]; disp(out2)  
out3=['Accuracy_Removing = ',num2str(SVM_mean3),' , STD = ',num2str(SVM_STD3)]; disp(out3)
out4=['Accuracy_noisy data = ', num2str(SVM_mean4),' , STD = ',num2str(SVM_STD4)]; disp(out4)
out5=['Accuracy_initial data = ', num2str(SVM_mean5),' , STD = ',num2str(SVM_STD5)]; disp(out5)
%---- evaluation results of one-filter CNDC model using ensmeble filtering (majority voting) 
disp('-------------------------------------------------------------------')
if ~isempty(eval_ens)
    p1=eval_ens(:,1);r1=eval_ens(:,2);f1=eval_ens(:,3);
    out5=['Precision_OneFilter = ',num2str(mean(p1)),' , STD = ',num2str(std(p1))]; disp(out5)
    out6=['Recall_OneFilter = ',num2str(mean(r1)),' , STD = ',num2str(std(r1))]; disp(out6)
    out7=['F-measure_OneFilter = ', num2str(mean(f1)),' , STD = ',num2str(std(f1))]; disp(out7)
else 
    disp ('The input dataset is unacceptable')
end
% evaluation results of Two filter CNDC model using ensemble and distance filtering
disp('-------------------------------------------------------------------')
if ~isempty(eval_dis)
    p2=eval_dis(:,1);r2=eval_dis(:,2);f2=eval_dis(:,3);
    out8=['Precision_twoFilter = ',num2str(mean(p2)),' , STD = ',num2str(std(p2))]; disp(out8)
    out9=['Recall_twoFilter = ',num2str(mean(r2)),' , STD = ', num2str(std(r2))]; disp(out9)
    out10=['F-measure_twoFilter = ',num2str(mean(f2)),' , STD = ', num2str(std(f2))]; disp(out10)
else
    disp('The input dataset is unacceptable')
end


    
