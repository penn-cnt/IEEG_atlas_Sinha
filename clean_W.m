function clean_data = clean_W(Data_W)
for i = 1:size(Data_W,2)
    W=Data_W(:,i);
    new_W=W(find(~isnan(W) & W~=0));
    clean_data(:,i)=new_W;
end