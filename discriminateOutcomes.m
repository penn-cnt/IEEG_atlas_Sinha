function [g,auc,p,sf,nsf] = discriminateOutcomes(dRS,metaData,EngelSFThres,plt)

% Remove NaNs
remPatient = isnan(dRS);
dRS(remPatient) = [];
metaData(remPatient,:) = [];

% therapy = [];
% Keep only resection therapy
therapy = [];%~strcmp(metaData.Therapy,'Resection');
if isempty(therapy)   
    outcomes = nanmax([metaData.Engel_6_mo,metaData.Engel_12_mo],[],2);
    isSF = outcomes <= EngelSFThres;
    sf = sum(isSF);
    nsf = sum(~isSF);
else
    outcomes = nanmax([metaData.Engel_6_mo,metaData.Engel_12_mo],[],2);
    outcomes(therapy) = [];
    isSF = outcomes <= EngelSFThres;
    sf = sum(isSF);
    nsf = sum(~isSF);
    dRS(therapy) = [];
end

stats = mes(dRS(~isSF),dRS(isSF),{'auroc','hedgesg'},'isdep',0);
g = stats.hedgesg;
auc = stats.auroc;
[~,p] = ttest2(dRS(isSF),dRS(~isSF),'tail','left');

% plot figures
if strcmp(plt,'plot')
    figure;
    UnivarScatter(padcat(dRS(isSF),dRS(~isSF)));
    title(['g = ' num2str(g), ', auc = ' num2str(auc), ', p = ' num2str(p)]);
end

end