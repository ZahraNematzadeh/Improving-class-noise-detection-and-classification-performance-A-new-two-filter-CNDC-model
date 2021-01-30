# Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model

Run the **main_ensdis.m** (https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/main_ensdis.m) and change the noise level interval manually in **noise_injection.m**(https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/noise_injection.m).

The proposed method includes the main code **main_ensdis.m**  and 11 functions which are described below:
1.	Normalize:  it scales a variable to have a values between 0 and 1. (https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/normlize.m)
2.	Noise_injection: it randomly injects noise at different intervals. Change the interval manually.(https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/noise_injection.m)
3.	Train_test_split: it splits 20% data as a test set and the remaining 80% data as a train set without replacement. (https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/train_test_split.m)
4.	Ensemble_MV: it detects noise using majority voting and it defines strong noise and weak noise.(https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/ensemble_MV.m)
5.	Knnpredict:  K nearest neighbor classifier (https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/knnpredict.m)
6.	Checking_noise: it compares the detected noise using majority voting from injected noise. (https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/checking_noise.m)
7.	Evaluation: it evaluates the noise detection using one-filter (majority voting) and two-filter (majority and distance filtering) in terms of Precision, Recall, F-measure. (https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/evaluation.m)
8.	Distance_filtering: it detects the real noise using distance filtering. (https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/distance_filtering.m)
9.	Final_noise: it determines the final strong noise and weak noise.(https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/final_noise.m)
10.	Noise_classification: it cleans the dataset using three techniques: (https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/noise_classification.m)
  -	removeing (strong noise & weak noise), 
  - relabeling (strong noise and weak noise), 
  - REM-REL (relabel strong noise & remove weak noise).
11.	SVM_ACC: calculate the accuracy of cleaned datasets. (https://github.com/ZahraNematzadeh/Improving-class-noise-detection-and-classification-performance-A-new-two-filter-CNDC-model/blob/main/SVM_ACC.m)
