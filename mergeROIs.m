function [atlasCustom,roiAALcustom] = mergeROIs(customAAL,roiAAL,atlas)

for roi = 1:size(customAAL,1)
    
    customAAL.parcel1(roi) = roiAAL.parcel(customAAL.Roi1(roi));
    
    if isnan(customAAL.Roi2(roi))
        customAAL.parcel2(roi) = nan;
    else
         customAAL.parcel2(roi) = roiAAL.parcel(customAAL.Roi2(roi));        
         atlas.data(atlas.data == customAAL.parcel2(roi)) = customAAL.parcel1(roi);       
    end
    
     if isnan(customAAL.Roi3(roi))
        customAAL.parcel3(roi) = nan;
    else
         customAAL.parcel3(roi) = roiAAL.parcel(customAAL.Roi3(roi));
         atlas.data(atlas.data == customAAL.parcel3(roi)) = customAAL.parcel1(roi);       
    end
    
end

included = [customAAL.Roi1;customAAL.Roi2;customAAL.Roi3];
included(isnan(included)) = [];

excluded = setxor(roiAAL.Sno,included);

atlas.data(ismember(atlas.data,roiAAL.parcel(excluded))) = 0;

atlasCustom = atlas;

roiAALcustom.Sno = transpose(1:size(customAAL,1));
roiAALcustom.Regions = customAAL.Roi_name;
% roiAALcustom.Lobes = customAAL.Lobes;
roiAALcustom.isSideLeft = endsWith(customAAL.Roi_name,'_L');
roiAALcustom.parcel = customAAL.parcel1;

%%


for roi = 1:size(customAAL,1)
    
    [CRS(:,1),CRS(:,2),CRS(:,3)]=ind2sub(size(atlas.data),find(atlas.data==roiAALcustom.parcel(roi)));    
    CRS(:,4) = repmat(roiAALcustom.parcel(roi),size(CRS,1),1);
    
    RAS = atlas.hdr.Transform.T' * [CRS(:,1:3), ones(size(CRS,1),1)]';
    RAS = transpose(RAS);
    RAS = [RAS(:,1:3), CRS(:,4)];
    xyz(roi,:) = mean(RAS,1);
    clear CRS RAS
end

roiAALcustom.x = xyz(:,1);
roiAALcustom.y = xyz(:,2);
roiAALcustom.z = xyz(:,3);

%%
roiAALcustom = struct2table(roiAALcustom);

end