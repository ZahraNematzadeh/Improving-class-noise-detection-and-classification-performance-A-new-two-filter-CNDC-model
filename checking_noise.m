function [number_correctly_noise]= checking_noise(inoise_ens,noise_ens,num_noise_inject,x_inject, y_inject)
noise_size= size (noise_ens,1);
 u = num_noise_inject;
 kk=1;
 w=1;
 for k=1:noise_size  
    rr=0; g=1;
    while g<=u && rr==0
        if x_inject(g,:)== noise_ens(k,1:end-1) 
            if y_inject(g,1)== noise_ens(k,end)
                noisefinal (w,:)= noise_ens(k,:);
                inoise_final(w)=inoise_ens(k);
                w=w+1;
                kk =kk+1;
                rr=1;
            end
        end
        g=g+1;
    end 
end
number_correctly_noise= kk-1;
end