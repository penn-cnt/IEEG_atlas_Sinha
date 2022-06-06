function pat_Connection = netowkrAbr(norm_Connection,pat_Connection)

fBands = pat_Connection.Properties.VariableNames;
fBands = fBands(4:9);

for con = 1:size(pat_Connection,1)
    
    idx = and(norm_Connection.roi2 == pat_Connection.roi2(con), ...
        norm_Connection.roi1 == pat_Connection.roi1(con));
    
    for f = 1:numel(fBands)
        
        norm = norm_Connection.(fBands{f});
        norm(norm==1) = nan; % exclude self connections
        mu = mean(norm,'omitnan');
        sigma = std(norm,'omitnan');
        
        pat = pat_Connection.(fBands{f})(con);
        pat(pat == 1) = nan; % exclude self connections
        pat_Connection.([fBands{f} '_z'])(con) = (pat-mu)/sigma;
    end
    
    
end


end