function xyz = getCoord(atlas)

nROI = unique(atlas.data);
nROI = nROI(nROI~=0);

xyzCRS = [];
xyzRAS = [];

for roi = 1:numel(nROI)
    
    [CRS(:,1),CRS(:,2),CRS(:,3)]=ind2sub(size(atlas.data),find(atlas.data==nROI(roi)));    
    CRS(:,4) = repmat(nROI(roi),size(CRS,1),1);        
    
    xyzCRS = [xyzCRS; mean(CRS,1)];
    
    RAScord = atlas.hdr.Transform.T' * [CRS(:,1:3), ones(size(CRS,1),1)]';
    RAScord = transpose(RAScord);
    
    xyzRAS = [xyzRAS; mean(RAScord,1)];
    
    
    clear CRS RAScord
end

xyzRAS(:,4) = [];

xyz = ceil(xyzRAS);
end