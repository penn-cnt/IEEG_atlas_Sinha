function conn = checkSparsity(norm_Connection,atlas)

for roi1 = 1:numel(atlas.tbl.Sno)
    for roi2 = 1:numel(atlas.tbl.Sno)
        
        c(roi1,roi2) = sum(and(norm_Connection.roi1 == roi1,...
            norm_Connection.roi2 == roi2));
        
    end
end

%% Remove self connections
c  = c - diag(diag(c));
atlas.tbl = sortrows(atlas.tbl,{'isSideLeft','Lobes'},{'ascend','descend'});

conn = c(atlas.tbl.Sno,:);
conn = conn(:,atlas.tbl.Sno);

imagesc(log(conn+1));
colormap(brewermap([],'Greens'));
caxis([0 6]);


%circularGraph(conn,'Label',atlas.tbl.Regions);

%% get connectivities for each frequency bands between roi

% detaExample = norm_Connection.delta(and(norm_Connection.roi1 == 1,...
%     norm_Connection.roi2 == 15));
% 
% thetaExample = norm_Connection.theta(and(norm_Connection.roi1 == 1,...
%     norm_Connection.roi2 == 15));
% 
% alphaExample = norm_Connection.alpha(and(norm_Connection.roi1 == 1,...
%     norm_Connection.roi2 == 15));
% 
% betaExample = norm_Connection.beta(and(norm_Connection.roi1 == 1,...
%     norm_Connection.roi2 == 15));
% 
% gammaExample = norm_Connection.gamma(and(norm_Connection.roi1 == 1,...
%     norm_Connection.roi2 == 15));
% 
% data = [detaExample,thetaExample,alphaExample,betaExample,gammaExample];
% figure;
% hold on;
% violin(data);
% UnivarScatter(data,'PointStyle','.','Compression',20,'Whiskers','none');
% legend off

end