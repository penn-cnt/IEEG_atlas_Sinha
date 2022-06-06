function [dRS,dRSCI] = discriminateStats(roiHUP)

patient = unique(roiHUP.patientNum);

for p = 1:numel(patient)
    
    idx = roiHUP.patientNum==patient(p);
    idxR = (idx & roiHUP.isResected);
    idxS = (idx & ~roiHUP.isResected);
    
    stats = mes(roiHUP.maxAbnormality(idxR),roiHUP.maxAbnormality(idxS),'auroc','nboot',5000);
    dRS(p,:) = stats.auroc;
    dRSCI(p,:) = stats.aurocCi;
       
end

end