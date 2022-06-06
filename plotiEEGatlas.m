function normAtlas = plotiEEGatlas(iEEGnormal,atlas,plt)

normAtlas.roi = atlas.tbl.Sno;
normAtlas.name = atlas.tbl.Regions;
% normAtlas.lobe = atlas.tbl.Lobes;
normAtlas.isSideLeft = atlas.tbl.isSideLeft;
normAtlas.x = atlas.tbl.x;
normAtlas.y = atlas.tbl.y;
normAtlas.z = atlas.tbl.z;

for roi = 1:numel(atlas.tbl.Sno)
    
    idx = iEEGnormal.roiNum == roi;
    
    % how many electrodes are in each region
    normAtlas.nElecs(roi,:) = sum(idx);
    
    % mean delta power
    normAtlas.delta{roi,:} = iEEGnormal.delta(idx);
    normAtlas.deltaMean(roi,:) = mean(iEEGnormal.delta(idx));
    normAtlas.deltaStd(roi,:) = std(iEEGnormal.delta(idx));
    
    % mean theta power
    normAtlas.theta{roi,:} = iEEGnormal.theta(idx);
    normAtlas.thetaMean(roi,:) = mean(iEEGnormal.theta(idx));
    normAtlas.thetaStd(roi,:) = std(iEEGnormal.theta(idx));
    
    % mean alpha power
    normAtlas.alpha{roi,:} = iEEGnormal.alpha(idx);
    normAtlas.alphaMean(roi,:) = mean(iEEGnormal.alpha(idx));
    normAtlas.alphaStd(roi,:) = std(iEEGnormal.alpha(idx));
    
    % mean beta power
    normAtlas.beta{roi,:} = iEEGnormal.beta(idx);
    normAtlas.betaMean(roi,:) = mean(iEEGnormal.beta(idx));
    normAtlas.betaStd(roi,:) = std(iEEGnormal.beta(idx));
    
    % mean gamma power
    normAtlas.gamma{roi,:} = iEEGnormal.gamma(idx);
    normAtlas.gammaMean(roi,:) = mean(iEEGnormal.gamma(idx));
    normAtlas.gammaStd(roi,:) = std(iEEGnormal.gamma(idx));
    
    % mean broadband power
    normAtlas.broad{roi,:} = iEEGnormal.broad(idx);
    normAtlas.broadMean(roi,:) = mean(iEEGnormal.broad(idx));
    normAtlas.broadStd(roi,:) = std(iEEGnormal.broad(idx));
    
end

normAtlas = struct2table(normAtlas);

% remove regions with no electrodes
normAtlas(normAtlas.nElecs==0,:) = [];

% plot figures
if strcmp(plt,'plot')
    
    band = normAtlas.Properties.VariableNames([8,10:3:end]);
    
    for i = 1:numel(band)
        
        nodeVal = [normAtlas.x,normAtlas.y,normAtlas.z,...
            minMaxFeature(normAtlas.(band{i})),minMaxFeature(normAtlas.(band{i}))];
        dlmwrite('nodeVal.node', nodeVal, 'delimiter','\t');
        if i<6
            BrainNet_MapCfg('BrainMesh_ICBM152_smoothed.nv','nodeVal.node',...
                'configBrainNet.mat',[band{i} '.png']);
        else
            BrainNet_MapCfg('BrainMesh_ICBM152_smoothed.nv','nodeVal.node',...
                'configBrainNetHF.mat',[band{i} '.png']);
        end
    end
    
end