function patientMap = compAbnormality(patientMap,normativeMap, options)

arguments
    patientMap
    normativeMap
    options.keepNans = false
    options.bands = {'delta','theta','alpha','beta','gamma'};
end

bands = options.bands;

for i = 1:size(patientMap,1)
    roi = normativeMap.roi == patientMap.roiNum(i);
    for b = 1:numel(bands)
        
        if sum(roi)>0
            mu = normativeMap.([bands{b} 'Mean'])(roi);
            sigma = normativeMap.([bands{b} 'Std'])(roi);
            
            patientMap.([bands{b} 'Z'])(i) = abs((patientMap.(bands{b})(i) - mu)./sigma);
            
        else
            
            patientMap.([bands{b} 'Z'])(i) = nan;
            
        end
        
    end
end

allZ = cell2mat(cellfun(@(x)patientMap.([x 'Z']), bands, 'Uni', 0));
patientMap.maxAbnormality = max(allZ,[],2);

if ~options.keepNans
    patientMap(isnan(patientMap.maxAbnormality),:) = [];
    patientMap(isinf(patientMap.maxAbnormality),:) = [];
end

end