function [ weak_noise, strong_noise ] = final_noise( number_noise, noisedis, SD, WD)
c=0; c1=0; rr=1; tt=1; f1=0;f2=0;
weak_noise=[];strong_noise=[];
    for jj=1:number_noise
        k = (noisedis(jj,:));
        if ~isempty(SD)
        f1=ismember(k,SD(:,:),'rows');
        end
        if ~isempty(WD)
        f2=ismember(k,WD(:,:),'rows');
        end
        if f1 >0 
            c=c+1;
            strong_noise (rr,:)=noisedis(jj,:);
            rr=rr+1;
        end
        if f2>0
            c1=c1+1;
            weak_noise(tt,:)=noisedis(jj,:);
            tt=tt+1;
        end
    end 
end

