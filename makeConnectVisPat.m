function makeConnectVisPat(iEEGhup,cord_HUP,resec_HUP,hupSub)
%% norm_Connection in HUP

for s = hupSub
    
    idxROI1 = and(iEEGhup.patientNum==s,iEEGhup.roiNum==1);
    idxROI2 = and(iEEGhup.patientNum==s,iEEGhup.roiNum==85);
    
    idxROIrem = and(iEEGhup.patientNum==s, and(iEEGhup.roiNum~=1,iEEGhup.roiNum~=85));
    
    % make nodes
    roi1cord = cord_HUP(idxROI1,:);
    roi2cord = cord_HUP(idxROI2,:);
    roicordRem = cord_HUP(idxROIrem,:);
    
    roicord = [roi1cord;roi2cord;roicordRem];
    clr = [resec_HUP(idxROI1,:);resec_HUP(idxROI2,:);resec_HUP(idxROIrem,:)];
    
    cord = [roicord, clr, ones(size(roicord,1),1)];
    dlmwrite(['con1to85_HUP' num2str(s) '.node'], cord, 'delimiter','\t');
    
    % make edges
    edges = ones(size(cord,1)); % connect everything
    edges(1:size(roi1cord,1),1:size(roi1cord,1)) = 0;
    edges(size(roi1cord,1)+1:size(roi1cord,1)+size(roi2cord,1),...
        size(roi1cord,1)+1:size(roi1cord,1)+size(roi2cord,1)) = 0;
    edges(size(roi1cord,1)+size(roi2cord,1)+1:end,:) = 0;
    edges(:,size(roi1cord,1)+size(roi2cord,1)+1:end) = 0;
    dlmwrite(['edges1to85_HUP' num2str(s) '.edge'], edges, 'delimiter','\t');
end

end