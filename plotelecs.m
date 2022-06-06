function pat = plotelecs(HUP_atlasAll,metaData,hupID,outname,sideLeft)

idx = find(strcmp(metaData.Patient,hupID));
pat.mni_coords = HUP_atlasAll.mni_coords(HUP_atlasAll.patient_no==idx,:);
pat.resected_ch = HUP_atlasAll.resected_ch(HUP_atlasAll.patient_no==idx,:);
pat.soz_ch = HUP_atlasAll.soz_ch(HUP_atlasAll.patient_no==idx,:);
pat.spike_24h = HUP_atlasAll.spike_24h(HUP_atlasAll.patient_no==idx,:);
pat.spike_24h = pat.spike_24h>24;
pat.nodeVals = [pat.mni_coords,pat.soz_ch*1,pat.spike_24h+0.5];
%dlmwrite('nodeVal_sf.node', sf.nodeVals, 'delimiter','\t');
if sideLeft == 1
    BrainNet_MapCfg('BrainMesh_ICBM152_smoothed.nv','configSurf.mat')
elseif sideLeft == 0
    BrainNet_MapCfg('BrainMesh_ICBM152_smoothed.nv','configSurfR.mat')
end
    
hold on
scatter3(pat.nodeVals(:,1),pat.nodeVals(:,2),pat.nodeVals(:,3),'ok');
scatter3(pat.nodeVals(pat.soz_ch==1,1),pat.nodeVals(pat.soz_ch==1,2),pat.nodeVals(pat.soz_ch==1,3),'r','filled')
scatter3(pat.nodeVals(pat.spike_24h==1,1),pat.nodeVals(pat.spike_24h==1,2),pat.nodeVals(pat.spike_24h==1,3),'or')
fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [12 8]);
print(gcf, '-dpdf', '-r300', ['Figure/' outname '.pdf']);
end