function [x_inject,y_inject,x_process,y_process,num_noise_inject]= noise_injection(x_initial, y_initial)
d=1;
nn=1;
num = size (x_initial,1);
ni = floor (0.1 * num) ;% change the interval to 0.1,0.2,0.3,0.4,0.5 manually
     for b=1:ni
        if y_initial(b,1) ==1 
         y_inject(d,1) = -1;
         x_inject(nn,:)= x_initial(b,:);
         d=d+1;
         nn=nn+1;
        else
         y_inject(d,1) = 1;
         x_inject(nn,:)= x_initial(b,:);
         d = d+1;
         nn=nn+1;
        end   
     end 
     cc=1;
     for c=(ni+1):num
          ytrain_raw (cc,1)= y_initial (c,1);
          xtrain_raw(cc,:)= x_initial(c,:);
          cc=cc+1;
     end
     x_process = [x_inject; xtrain_raw];
     y_process = [y_inject; ytrain_raw];
     num_noise_inject = size (x_inject,1);
end