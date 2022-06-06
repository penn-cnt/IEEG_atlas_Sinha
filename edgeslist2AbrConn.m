function abrConn = edgeslist2AbrConn(pat_Connection,HUP_atlasAll)

nSub = unique(pat_Connection.patientNum);
fbands = pat_Connection.Properties.VariableNames;
fbands = fbands(endsWith(fbands,'_z'));

for s = 1:numel(nSub)
    abrConn.patientNum(s,:) = nSub(s);
    
    nElec = sum(HUP_atlasAll.patient_no == nSub(s));
    
    for f = 1:numel(fbands)
        edges = pat_Connection.(fbands{f})(pat_Connection.patientNum==nSub(s));
        adj = reshape(edges,[nElec,nElec]);
        adj(isnan(adj)) = 0;
        abrConn.([fbands{f}]){s,:} = abs(adj); % take absolute value of z
    end
    
end

abrConn = struct2table(abrConn);

end