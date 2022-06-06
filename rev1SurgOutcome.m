function d = rev1SurgOutcome(HUP_atlasAll,iEEGhupAll,metaData)

sub = unique(iEEGhupAll.patientNum);

for s = 1:numel(sub)
    
    idx = iEEGhupAll.patientNum == sub(s);
    epileptogenicIDX = HUP_atlasAll.resected_ch(idx)==1;
    
    d(s,1) = cohensD(iEEGhupAll.delta(epileptogenicIDX),...
        iEEGhupAll.delta(~epileptogenicIDX));
    d(s,2) = cohensD(iEEGhupAll.theta(epileptogenicIDX),...
        iEEGhupAll.theta(~epileptogenicIDX));
    d(s,3) = cohensD(iEEGhupAll.alpha(epileptogenicIDX),...
        iEEGhupAll.alpha(~epileptogenicIDX));
    d(s,4) = cohensD(iEEGhupAll.beta(epileptogenicIDX),...
        iEEGhupAll.beta(~epileptogenicIDX));
     d(s,5) = cohensD(iEEGhupAll.gamma(epileptogenicIDX),...
        iEEGhupAll.gamma(~epileptogenicIDX));
     d(s,6) = cohensD(iEEGhupAll.broad(epileptogenicIDX),...
        iEEGhupAll.broad(~epileptogenicIDX));   
    
end

outcomes = nanmax([metaData.Engel_6_mo,metaData.Engel_12_mo],[],2);
outcomes = outcomes<=1.4;

data = [];
for f = 1:6
    stats = mes(d(outcomes,f),d(~outcomes,f),'auroc');
    auc(f,:) = stats.auroc;
    
    data = [data, padcat(d(outcomes,f),d(~outcomes,f))];   
    
end

Colors = [hex2rgb('DAE152');hex2rgb('CC6633')];
Colors = repmat(Colors,6,1);
labels = {'Engel 1','Engel 2+'};
labels = repmat(labels,1,6);

figure
UnivarScatter(data,'Label',labels,'MarkerFaceColor',Colors,...
    'MarkerEdgeColor','k','SEMColor',Colors/0.9,'StdColor',Colors,...
    'Whiskers','box');
%pbaspect([10,6,1]);
set(gca,'FontSize',12);
ylabel('Abnormality load')
box off

end