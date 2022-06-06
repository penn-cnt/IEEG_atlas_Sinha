function makeConnectVis(iEEGhup,cord_HUP,hupSub,iEEGmni,cord_MNI,mniSub)

sub.MNI = unique(iEEGmni.patientNum);
sub.HUP = unique(iEEGhup.patientNum);

%% norm_Connection in MNI
for s = mniSub
    
    idxROI1 = and(iEEGmni.patientNum==sub.MNI(s),iEEGmni.roiNum==1);
    idxROI2 = and(iEEGmni.patientNum==sub.MNI(s),iEEGmni.roiNum==85);
    
    % make nodes
    roi1cord = cord_MNI(idxROI1,:);
    roi2cord = cord_MNI(idxROI2,:);
    roicord = [roi1cord;roi2cord];
    cord = [roicord, ones(size(roicord,1),1), ones(size(roicord,1),1)];
    dlmwrite(['con1to85_MNI' num2str(sub.MNI(s)) '.node'], cord, 'delimiter','\t');
    
    % make edges
    edges = ones(size(cord,1)); % connect everything
    edges(1:size(roi1cord,1),1:size(roi1cord,1)) = 0;
    edges(size(roi1cord,1)+1:end,size(roi1cord,1)+1:end) = 0;
    dlmwrite(['edges1to85_MNI' num2str(sub.MNI(s)) '.edge'], edges, 'delimiter','\t');
end

%% norm_Connection in HUP

for s = hupSub
    
    idxROI1 = and(iEEGhup.patientNum==sub.HUP(s),iEEGhup.roiNum==1);
    idxROI2 = and(iEEGhup.patientNum==sub.HUP(s),iEEGhup.roiNum==85);
    
    % make nodes
    roi1cord = cord_HUP(idxROI1,:);
    roi2cord = cord_HUP(idxROI2,:);
    roicord = [roi1cord;roi2cord];
    cord = [roicord, ones(size(roicord,1),1), ones(size(roicord,1),1)];
    dlmwrite(['con1to85_HUP' num2str(sub.HUP(s)) '.node'], cord, 'delimiter','\t');
    
    % make edges
    edges = ones(size(cord,1)); % connect everything
    edges(1:size(roi1cord,1),1:size(roi1cord,1)) = 0;
    edges(size(roi1cord,1)+1:end,size(roi1cord,1)+1:end) = 0;
    dlmwrite(['edges1to85_HUP' num2str(sub.HUP(s)) '.edge'], edges, 'delimiter','\t');
end

end