function [roiHUPAblation,roiHUPResection,ablation,resection] = discriminateTherapy(roiHUP,metaData,EngelSFThres)

patient = unique(roiHUP.patientNum);
theraphy = unique(metaData.Therapy);

outcomes = nanmax([metaData.Engel_6_mo,metaData.Engel_12_mo],[],2);
isSF = outcomes <= EngelSFThres;

roiHUPAblation = [];
ablationOutcomeisSF = [];
resectionOutcomeisSF = [];
roiHUPResection = [];
nResecAblation = [];
nSpareAblation = [];
nResecResection = [];
nSpareResection = [];
SFafterAblation = [];
SFafterResection = []; 

for p = 1:numel(patient)
    id = roiHUP.patientNum==patient(p);
    surgType = find(strcmp(metaData.Therapy{patient(p)},theraphy));
    % Check if the patient is ablation or resection
    
    if surgType == 1
        
        roiHUPAblation = [roiHUPAblation; roiHUP(id,:)];
        ablationOutcomeisSF = [ablationOutcomeisSF; repmat(isSF(patient(p)),sum(id),1)];
        nResecAblation = [nResecAblation; sum(id & roiHUP.isResected)];
        nSpareAblation = [nSpareAblation; sum(id & ~roiHUP.isResected)];
        SFafterAblation = [SFafterAblation; isSF(patient(p))];
        
    elseif surgType == 2
        
        roiHUPResection = [roiHUPResection; roiHUP(id,:)];
        resectionOutcomeisSF = [resectionOutcomeisSF; repmat(isSF(patient(p)),sum(id),1)];
        nResecResection = [nResecResection; sum(id & roiHUP.isResected)];
        nSpareResection = [nSpareResection; sum(id & ~roiHUP.isResected)];
        SFafterResection = [SFafterResection; isSF(patient(p))];
        
    end
    
end

roiHUPAblation = [roiHUPAblation(:,1:4),table(ablationOutcomeisSF,'VariableNames',{'isSF'}),roiHUPAblation(:,5:end)];
roiHUPResection = [roiHUPResection(:,1:4),table(resectionOutcomeisSF,'VariableNames',{'isSF'}),roiHUPResection(:,5:end)];


[dRS_Ablation,dRSCI_Ablation] = discriminateStats(roiHUPAblation);
ablation.dRS = dRS_Ablation;
ablation.dRSCI = dRSCI_Ablation;
ablation.dRSCIrange = dRSCI_Ablation(:,2) - dRSCI_Ablation(:,1);
ablation.nResect = nResecAblation;
ablation.nSpared = nSpareAblation;
ablation.isSF = SFafterAblation;
ablation.propResect = ablation.nResect./(ablation.nResect+ablation.nSpared);

ablation = struct2table(ablation);
ablation(isnan(ablation.dRS),:) = [];


[dRS_Resection,dRSCI_Resection] = discriminateStats(roiHUPResection);
resection.dRS = dRS_Resection;
resection.dRSCI = dRSCI_Resection;
resection.dRSCIrange = dRSCI_Resection(:,2) - dRSCI_Resection(:,1);
resection.nResect = nResecResection;
resection.nSpared = nSpareResection;
resection.isSF = SFafterResection;
resection.propResect = resection.nResect./(resection.nResect+resection.nSpared);

resection = struct2table(resection);
resection(isnan(resection.dRS),:) = [];
end