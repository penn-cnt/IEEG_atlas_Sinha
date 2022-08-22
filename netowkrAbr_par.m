function pat_Connection = netowkrAbr(norm_Connection,pat_Connection)

fBands = pat_Connection.Properties.VariableNames;
fBands = string(fBands(4:9));
pat_Connection_z = zeros([size(pat_Connection,1) length(fBands)]);

for con = 1:size(pat_Connection,1)
    idx = and(norm_Connection.roi2 == pat_Connection.roi2(con), ...
        norm_Connection.roi1 == pat_Connection.roi1(con));
    
        
    norm = norm_Connection(idx,fBands).Variables;
    norm(norm==1) = nan; % exclude self connections
    mu = mean(norm,1,'omitnan');
    sigma = std(norm,0,1,'omitnan');
    
    pat = pat_Connection(con,fBands).Variables;
    pat(pat== 1) = nan; % exclude self connections
    pat_Connection_z(con,:) = (pat-mu)./sigma;    
end
pat_Connection_z = array2table(pat_Connection_z, 'VariableNames', fBands);

pat_Connection_z.Properties.VariableNames =...
    cellfun(@(c)[c '_z'],pat_Connection_z.Properties.VariableNames,'uni',false);
pat_Connection = [pat_Connection pat_Connection_z]
end