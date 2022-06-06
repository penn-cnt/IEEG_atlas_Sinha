function roiHUP = reduceContacts2roi(iEEGhupAll,spike_24h,propContact)

patient = unique(iEEGhupAll.patientNum);
roiHUP.roiNum = [];
roiHUP.atlasROI = [];
roiHUP.patientNum = [];
roiHUP.isResected = [];
roiHUP.delta = [];
roiHUP.theta = [];
roiHUP.alpha = [];
roiHUP.beta = [];
roiHUP.gamma = [];
roiHUP.spikes = [];

for p = 1:numel(patient)
    
    idx = iEEGhupAll.patientNum==patient(p);
    roi = unique(iEEGhupAll.roiNum(idx));
    atlasROI = unique(iEEGhupAll.atlasROI(idx));
    
    roiHUP.roiNum = [roiHUP.roiNum; roi];
    roiHUP.atlasROI = [roiHUP.atlasROI; atlasROI];
    roiHUP.patientNum = [roiHUP.patientNum; patient(p)*ones(numel(roi),1)];
    
    for r = 1:numel(roi)
        
        idxr = (idx & iEEGhupAll.roiNum==roi(r));
        
        percentContactRem = sum(iEEGhupAll.isResected(idxr))/sum(idxr);
        roiHUP.isResected = [roiHUP.isResected; percentContactRem>propContact];
        roiHUP.delta = [roiHUP.delta; mean(iEEGhupAll.delta(idxr))];
        roiHUP.theta = [roiHUP.theta; mean(iEEGhupAll.theta(idxr))];
        roiHUP.alpha = [roiHUP.alpha; mean(iEEGhupAll.alpha(idxr))];
        roiHUP.beta = [roiHUP.beta; mean(iEEGhupAll.beta(idxr))];
        roiHUP.gamma = [roiHUP.gamma; mean(iEEGhupAll.gamma(idxr))];  
        roiHUP.spikes = [roiHUP.spikes; nanmean(spike_24h(idxr))];
    end
    
    
end

roiHUP = struct2table(roiHUP);


end