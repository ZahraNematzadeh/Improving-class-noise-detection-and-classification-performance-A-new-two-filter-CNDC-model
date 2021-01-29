function[noisefinal,inoisedis,noisedis,number_noise,number_correctly_noise]= distance_filtering(noisefree, noise_array,num_noise_inject,inoise,x_inject,y_inject)
%noisefree dataset is separated into two classes based on labels. Then the
%distance of each deteced noise to each class is calculated to evaluate
%either the detected noise using majority voting is a real noise or not. 
Destination2_class2= [];
Destination_class1 = [];
noisefinal=[];

xn = noise_array(:,1:end-1);
yn = noise_array(:,end);
xx = noisefree(:,1:end-1);
yy = noisefree(:,end);
class1 = find (yy == 1);
noisefree_x1 = xx(class1,:);
noisefree_y1 = yy(class1,:);
class2 = find (yy == -1);
noisefree_x2 = xx(class2,:);
noisefree_y2 = yy(class2,:);
%---------------------------- Train Class1 --------------------------------
trainData = noisefree_x1 ;
testData = noise_array(:,1:end-1);
trainClass = noisefree_y1;
%# compute pairwise distances between each test instance vs. all training data
D = pdist2(testData, trainData, 'euclidean');
[D,idx] = sort(D, 2, 'ascend');
if(size(D,2)<10)
    K=size(D,2);
else 
    K = 10;
end
%# K nearest neighbors
D = D(:,1:K);
idx = idx(:,1:K);
p =size (D, 1);
for j=1:p
Destination_class1(j,1)= mean (D(j,:));
end
Destination_class1; 
%----------------------------- Train class2 -------------------------------
trainData2 = noisefree_x2 ;
testData2 = noise_array(:,1:end-1);
trainClass2 = noisefree_y2;
%# compute pairwise distances between each test instance vs. all training data
D2 = pdist2(testData2, trainData2, 'euclidean');
[D2,idx2] = sort(D2, 2, 'ascend');
%# K nearest neighbors
if(size(D2,2)<10)
    K=size(D2,2);
else 
    K = 10;
end
D2 = D2(:,1:K);
idx2 = idx2(:,1:K);
t =size (D2, 1);
for f=1:t
Destination2_class2(f,1)= mean (D2(f,:));
end
 Destination2_class2;
%--------------------------- Final decision -------------------------------
r1=1;
rr=1;
tt= size(noise_array,1);
noisefree_y1(1,1)=1;
noisefree_y2(1,1)=-1;
for i=1:tt
    if yn (i,1) == noisefree_y1(1,1) && Destination_class1(i)> Destination2_class2(i)
        noisedis (rr,:) = [ xn(i,:), yn(i,:)];
        inoisedis(rr,:)=inoise(i);
        rr= rr+1;
   else if  yn (i,1) ==  noisefree_y2(1,1)  && Destination2_class2 (i) > Destination_class1 (i)
        noisedis (rr,:) = [ xn(i,:), yn(i,:)];
         inoisedis(rr,:)=inoise(i);
        rr= rr+1;
         else
        nf_class (r1,:)=[ xn(i,:), yn(i,:)];
        r1=r1+1;
         end
     end 
end
x_noisefinal = noisedis(:,1:end-1);
y_noisefinal= noisedis(:,end);
noise_size= size (noisedis,1);
u = num_noise_inject;
w=1;
 kk=1;
 for k=1:noise_size
    rr=0; g=1;
    while g<=u && rr==0
        if x_inject(g,:)== x_noisefinal(k,:) 
            if y_inject(g,1)== y_noisefinal(k,1)
                noisefinal (w,:)= [x_noisefinal(k,:), y_noisefinal(k,1)];
                w=w+1;
                kk =kk+1;
                rr=1;
            end
        end
        g=g+1;
    end 
end
number_correctly_noise= kk-1;
number_noise= noise_size;
end












 








        
