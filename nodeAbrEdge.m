function iEEGhupAll = nodeAbrEdge(abrConn,iEEGhupAll,percentile_thres)

fbands = abrConn.Properties.VariableNames;
fbands = fbands(endsWith(fbands,'_z'));
iEEGabr = [];

for s = 1:size(abrConn,1)
    
    nodeAbr = [];
    for f = 1:numel(fbands)
        adj = abrConn.(fbands{f}){s,:};
        nodeAbr(:,f) = prctile(adj,percentile_thres,2);
    end
    iEEGabr = [iEEGabr; nodeAbr];
    
end

iEEGhupAll = [iEEGhupAll, array2table(iEEGabr,'VariableNames',append(fbands,'_coh'))];

end