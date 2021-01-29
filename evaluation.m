function [ pre, rec,fm]= evaluation(number_noise, number_correctly_noise,num_noise_inject)
dd=0.5;
pre= number_correctly_noise / number_noise;
rec= number_correctly_noise / num_noise_inject;
fm = ((1+ (dd^2))* ((pre* rec)/ ((dd^2*pre)+ rec)));
end