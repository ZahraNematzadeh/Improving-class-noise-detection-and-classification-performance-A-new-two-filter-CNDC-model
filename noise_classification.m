function [pure_data_REM_REL, pure_data_relabeling, pure_data_removing]=noise_classification(strong_noise,weak_noise, data2)
if isempty(strong_noise) && isempty(weak_noise)
    pure_data_REM_REL=data2;
    pure_data_relabeling= data2;
    pure_data_removing= data2;
else
data_no_weak=setdiff(data2,weak_noise,'rows');
if ~isempty(strong_noise)
    data_no_noise=setdiff(data_no_weak,strong_noise,'rows');
else
    data_no_noise=data_no_weak;
end
%------------------------ Applying REM-REL --------------------------------
%relabeling strong noise
if ~isempty(strong_noise)
    n=size(strong_noise,1);
    for i=1:n
        if strong_noise(i,end)==1
            strong_noise(i,end)=-1;
        else
            strong_noise(i,end)=1;
        end
    end
%combining new strong noise and noise free
pure_data_REM_REL=[strong_noise ; data_no_noise];
else
  pure_data_REM_REL=  data_no_noise;
end
%------------------------- Applying Relabeling-----------------------------
%relabeling weak noise and strong noise
m=size(weak_noise,1);
for i=1:m
    if weak_noise(i,end)==1
        weak_noise(i,end)=-1;
    else
        weak_noise(i,end)=1;
    end
end
if ~isempty(strong_noise)
    pure_data_relabeling= [weak_noise; strong_noise; data_no_noise];
else
    pure_data_relabeling= [weak_noise; data_no_noise];
end
%------------------------ Applying removing -------------------------------
pure_data_removing = data_no_noise;
end
end





