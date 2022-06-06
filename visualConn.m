function c = visualConn(norm_Connection)


c = norm_Connection(and(norm_Connection.roi1 == 1,...
           norm_Connection.roi2 == 85),:);
       
sub = unique(c.patientNum);
cord = [];

for s = 1:numel(sub)
    
    temp = c(c.patientNum==sub(s),:);    
    roi2 = [temp.roi2x,temp.roi2y,temp.roi2z];
    roi1 = [temp.roi1x,temp.roi1x,temp.roi1x];
    roi = [roi2;roi1];
    nodeC = s*ones(size(roi,1),1);
    nodes = ones(size(roi,1),1);
    
    cord = [cord;[roi,nodeC,nodes]];
    
    clear temp roi2 roi1 roi nodeC nodes
end



end