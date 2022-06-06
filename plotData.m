function plotData(roiHUPAblation,roiHUPResection,ablation,resection)

figure;
title('Discriminating Surgical Outcomes');
Colors = repmat([0 0.9 0;0.9 0 0],2,1);
UnivarScatter(padcat(ablation.dRS(ablation.isSF==1),...
    resection.dRS(resection.isSF==1),...
    ablation.dRS(ablation.isSF==0),...
    resection.dRS(resection.isSF==0)),'MarkerFaceColor',Colors);

xticklabels({'Ablation-SF','Resection-SF',...
    'Ablation-nSF','Resection-nSF'})
ylabel('D_{RS} Statistics');
fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [16 9]);
print(gcf, '-dpdf', '-r300', ['Figure/DRSOutcome.pdf']);

figure;
title('Proportion of ROIs resected');
Colors = repmat([0 0.9 0;0.9 0 0],2,1);

UnivarScatter(padcat(ablation.propResect(ablation.isSF==1),...
    resection.propResect(resection.isSF==1),...
    ablation.propResect(ablation.isSF==0),...
    resection.propResect(resection.isSF==0)),'MarkerFaceColor',Colors);
xticklabels({'Ablation-SF','Resection-SF',...
    'Ablation-nSF','Resection-nSF'})
ylabel('Proportion of resected ROIs');
fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [16 9]);
print(gcf, '-dpdf', '-r300', ['Figure/propResectOutcome.pdf']);


figure;
hold on
plot(resection.dRS(resection.isSF==1),resection.propResect(resection.isSF==1),'+','color',[0.9 0 0]);
plot(resection.dRS(resection.isSF==0),resection.propResect(resection.isSF==0),'o','color',[0.9 0 0]);
plot(ablation.dRS(ablation.isSF==1),ablation.propResect(ablation.isSF==1),'+','color',[0 0.9 0]);
plot(ablation.dRS(ablation.isSF==0),ablation.propResect(ablation.isSF==0),'o','color',[0 0.9 0]);
rSF = corr(resection.dRS(resection.isSF==1),resection.propResect(resection.isSF==1),'type','Spearman');
rNSF = corr(resection.dRS(resection.isSF==0),resection.propResect(resection.isSF==0),'type','Spearman');
aSF = corr(ablation.dRS(ablation.isSF==1),ablation.propResect(ablation.isSF==1),'type','Spearman');
aNSF = corr(ablation.dRS(ablation.isSF==0),ablation.propResect(ablation.isSF==0),'type','Spearman');
title(['resectSF = ' num2str(rSF), ', resectNSF = '  num2str(rNSF) ...
    ', ablSF = ' num2str(aSF), ', ablNSF = '  num2str(aNSF)]);
ylabel('Proportion of resected ROIs');
xlabel('D_{RS} Statistics');
fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [16 9]);
print(gcf, '-dpdf', '-r300', ['Figure/DRSpropResect.pdf']);

%% Box plot ablation
rSF = roiHUPAblation.isResected==1 & roiHUPAblation.isSF==1;
sSF = roiHUPAblation.isResected==0 & roiHUPAblation.isSF==1;
rNSF = roiHUPAblation.isResected==1 & roiHUPAblation.isSF==0;
sNSF = roiHUPAblation.isResected==0 & roiHUPAblation.isSF==0;

data = padcat(roiHUPAblation.maxAbnormality(rSF),...
    roiHUPAblation.maxAbnormality(sSF),...
    roiHUPAblation.maxAbnormality(rNSF),...
    roiHUPAblation.maxAbnormality(sNSF));

figure;
boxplot(data,'Notch','on');
xticklabels({'removed-SF','spared-SF','removed-NSF','spared-NSF'});
title('Ablation');
ylabel('Abnormality')
fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [16 9]);
print(gcf, '-dpdf', '-r300', ['Figure/abnormAblate.pdf']);

figure;
UnivarScatter(padcat(ablation.dRS(ablation.isSF==1),...
    ablation.dRS(ablation.isSF==0)));
ylabel('D_{RS} Statistics');
xticklabels({'SF','NSF'});
title('Ablation');

%% Box plot resection

rSF = roiHUPResection.isResected==1 & roiHUPResection.isSF==1;
sSF = roiHUPResection.isResected==0 & roiHUPResection.isSF==1;
rNSF = roiHUPResection.isResected==1 & roiHUPResection.isSF==0;
sNSF = roiHUPResection.isResected==0 & roiHUPResection.isSF==0;

data = padcat(roiHUPResection.maxAbnormality(rSF),...
    roiHUPResection.maxAbnormality(sSF),...
    roiHUPResection.maxAbnormality(rNSF),...
    roiHUPResection.maxAbnormality(sNSF));

figure;
boxplot(data,'Notch','on');
xticklabels({'removed-SF','spared-SF','removed-NSF','spared-NSF'});
ylabel('Abnormality')
title('Resection');
fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [16 9]);
print(gcf, '-dpdf', '-r300', ['Figure/abnormResection.pdf']);

figure;
UnivarScatter(padcat(resection.dRS(resection.isSF==1),...
    resection.dRS(resection.isSF==0)));
xticklabels({'SF','NSF'});
ylabel('D_{RS} Statistics');
title('Resection');
end