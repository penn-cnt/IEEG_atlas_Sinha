function patientMap = compAbnormality(patientMap,normativeMap)

band = {'delta','theta','alpha','beta','gamma'};

for i = 1:size(patientMap,1)
    roi = normativeMap.roi == patientMap.roiNum(i);
    for b = 1:numel(band)
        
        if sum(roi)>0
            mu = normativeMap.([band{b} 'Mean'])(roi);
            sigma = normativeMap.([band{b} 'Std'])(roi);
            
            patientMap.([band{b} 'Z'])(i) = abs((patientMap.(band{b})(i) - mu)./sigma);
            
        else
            
            patientMap.([band{b} 'Z'])(i) = nan;
            
        end
        
    end
end

patientMap.maxAbnormality = max([patientMap.deltaZ,patientMap.thetaZ,...
    patientMap.alphaZ,patientMap.betaZ,patientMap.gammaZ],[],2);

patientMap(isnan(patientMap.maxAbnormality),:) = [];
patientMap(isinf(patientMap.maxAbnormality),:) = [];

end