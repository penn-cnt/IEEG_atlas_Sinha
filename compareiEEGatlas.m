function normMNIAtlas = compareiEEGatlas(normMNIAtlas,normHUPAtlas,plt)

MNI = normMNIAtlas(ismember(normMNIAtlas.roi,normHUPAtlas.roi),:);
HUP = normHUPAtlas(ismember(normHUPAtlas.roi,normMNIAtlas.roi),:);

% plot figures
if strcmp(plt,'plot')
    %% Compare the number of electrodes between atlases
    figure,
    barh([MNI.nElecs,HUP.nElecs])
    xlabel('Number of electrodes')
    yticks(1:1:size(MNI,1))
    yticklabels(MNI.name);
    set(gca, 'TickLabelInterpreter', 'none');
    fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [9 16]*1.5);
    print(gcf, '-dpdf', '-r300', 'Figure/nElec.pdf');
    
    %% get the effect size across regions
    
    figure;
    name = {'deltaMNI','deltaHUP','thetaMNI','thetaHUP','alphaMNI','alphaHUP',...
        'betaMNI','betaHUP','gammaMNI','gammaHUP','broadMNI','broadHUP'};
    data = [padcat(MNI.deltaMean,HUP.deltaMean), padcat(MNI.thetaMean,HUP.thetaMean),...
        padcat(MNI.alphaMean,HUP.alphaMean), padcat(MNI.betaMean,HUP.betaMean),...
        padcat(MNI.gammaMean,HUP.gammaMean), padcat(MNI.broadMean,HUP.broadMean)];
    
    UnivarScatter(data(:,1:10),'Label',name(1:10),'PointSize',10,'Compression',10,...
        'MarkerFaceColor',repmat([hex2rgb('888CCA');hex2rgb('75C4EB')],5,1),...
        'MeanColor',repmat([hex2rgb('888CCA');hex2rgb('75C4EB')],5,1),...
        'StdColor',repmat([hex2rgb('888CCA');hex2rgb('75C4EB')],5,1)./1.5,...
        'SEMColor',repmat([hex2rgb('888CCA');hex2rgb('75C4EB')],5,1));
    
%     d1 = computeCohen_d(data(:,1),data(:,2),'paired');
%     d2 = computeCohen_d(data(:,3),data(:,4),'paired');
%     d3 = computeCohen_d(data(:,5),data(:,6),'paired');
%     d4 = computeCohen_d(data(:,7),data(:,8),'paired');
%     d5 = computeCohen_d(data(:,9),data(:,10),'paired');
%     d6 = computeCohen_d(data(:,11),data(:,12),'paired');
    
    %legend off
    %xtickangle(45);
    %ylabel('Normalised relative bandpower')
    
%     title({['Paired d score: ' num2str(d1), ', ', num2str(d2), ', ', num2str(d3), ', '...
%         num2str(d4), ', ', num2str(d5), ', ', num2str(d6)]});
    
    %hold on
    pbaspect([12,6,1]);
    xlim([0 11]);
    fillPage(gcf, 'margins', [0 0 0 0], 'papersize', [16 10]*1.2);
    print(gcf, '-dpdf', '-r300', 'Figure/bandPow.pdf');
end
%% Combine HUP with MNI
% If a ROI is present in HUP but absent in MNI, add it to MNI
newROIhup = normHUPAtlas(~ismember(normHUPAtlas.roi,normMNIAtlas.roi),:);
normMNIAtlas = [normMNIAtlas;newROIhup];

% For ROIs common in HUP and MNI, add data from HUP to MNI
commonROIhup = normHUPAtlas(ismember(normHUPAtlas.roi,normMNIAtlas.roi),:);

lbl = {'delta','theta','alpha','beta','gamma','broad'};

for roi = 1:size(commonROIhup,1)
    
    id = find(normMNIAtlas.roi==commonROIhup.roi(roi));
    
    normMNIAtlas.nElecs(id) = normMNIAtlas.nElecs(id) + commonROIhup.nElecs(roi);
    
    for band = 1:numel(lbl)
        normMNIAtlas.(lbl{band}){id} = [normMNIAtlas.(lbl{band}){id}; commonROIhup.(lbl{band}){roi}];
        normMNIAtlas.([lbl{band} 'Mean'])(id) = mean(normMNIAtlas.(lbl{band}){id});
        normMNIAtlas.([lbl{band} 'Std'])(id) = std(normMNIAtlas.(lbl{band}){id});
    end
    
end

normMNIAtlas = sortrows(normMNIAtlas,'roi','ascend');

end