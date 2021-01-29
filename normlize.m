function [data]= normlize (data,col)
for i=1:col
  minVal = min(data(:,i));% Min of column
  maxVal = max(data(:,i));% Max of column
  norm_data_input(:,i) = (data(:,i) - minVal) / ( maxVal - minVal );

end
data= norm_data_input;