function electrode2roi = implant2ROI(atlas,electrodeCord,patientNum)

nROI = unique(atlas.data(atlas.data~=0));

% voxel coordinantes coloumn row slice of voxels of an aal regsion

CRScord = [];
for roi = 1:numel(nROI)
    
    [CRS(:,1),CRS(:,2),CRS(:,3)]=ind2sub(size(atlas.data),find(atlas.data==nROI(roi)));    
    CRS(:,4) = repmat(nROI(roi),size(CRS,1),1);        
    CRScord = [CRScord;CRS];
    clear CRS    
end

% voxel coordinantes in mm space right anterior superior
RAScord = atlas.hdr.Transform.T' * [CRScord(:,1:3), ones(size(CRScord,1),1)]';
RAScord = transpose(RAScord);
RAScord = [RAScord(:,1:3), CRScord(:,4)];

% figure
% scatter3(RAScord(:,1),RAScord(:,2),RAScord(:,3),'.','MarkerEdgeAlpha',0.1,'MarkerFaceAlpha',0.1);
% hold on
% scatter3(electrodeCord(:,1),electrodeCord(:,2),electrodeCord(:,3),ones(size(electrodeCord,1),1)*200,'k','filled')


%% Indentify the nearest neighbour of the electrode

idx = knnsearch(RAScord(:,1:3),electrodeCord,'K',1);
atlasROI = RAScord(idx,4);

[~,roiNum]= ismember(atlasROI,atlas.tbl.parcel);

electrode2roi = table(roiNum,atlasROI,patientNum);


end