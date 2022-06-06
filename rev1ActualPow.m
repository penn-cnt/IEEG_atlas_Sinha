function [pGrp,d] = rev1ActualPow(HUP_Abr_atlas,iEEGhupAbr,HUP_atlas,MNI_atlas,iEEGhup,iEEGmni)
%%
epileptogenic.hdr = HUP_Abr_atlas;
epileptogenic.data = iEEGhupAbr;

normative.hdrHUP = HUP_atlas;
normative.hdrMNI = MNI_atlas;
normative.dataHUP = iEEGhup;
normative.dataMNI = iEEGmni;

%% group level
% data = padcat([normative.dataHUP.delta;normative.dataMNI.delta],epileptogenic.data.delta,...
%     [normative.dataHUP.theta;normative.dataMNI.theta],epileptogenic.data.theta,...
%     [normative.dataHUP.alpha;normative.dataMNI.alpha],epileptogenic.data.alpha,...
%     [normative.dataHUP.beta;normative.dataMNI.beta],epileptogenic.data.beta,...
%     [normative.dataHUP.gamma;normative.dataMNI.gamma],epileptogenic.data.gamma,...
%     [normative.dataHUP.broad;normative.dataMNI.broad],epileptogenic.data.broad);


data = padcat([normative.dataHUP.delta],epileptogenic.data.delta,...
    [normative.dataHUP.theta],epileptogenic.data.theta,...
    [normative.dataHUP.alpha],epileptogenic.data.alpha,...
    [normative.dataHUP.beta],epileptogenic.data.beta,...
    [normative.dataHUP.gamma],epileptogenic.data.gamma,...
    [normative.dataHUP.broad],epileptogenic.data.broad);

boxplot(data)

pGrp(:,1) = ranksum(data(:,1),data(:,2));
pGrp(:,2)  = ranksum(data(:,3),data(:,4));
pGrp(:,3)  = ranksum(data(:,5),data(:,6));
pGrp(:,4)  = ranksum(data(:,7),data(:,8));
pGrp(:,5)  = ranksum(data(:,9),data(:,10));
pGrp(:,6)  = ranksum(data(:,11),data(:,12));

pFDRGrp = mafdr(pGrp,'BHFDR',true);

%% patient specific level
sub = unique(epileptogenic.data.patientNum);

for s = 1:numel(sub)-1
    
    epileptogenicIDX = epileptogenic.data.patientNum == sub(s);
    normalIDX = normative.dataHUP.patientNum == sub(s);
    
    d(s,1) = cohensD(epileptogenic.data.delta(epileptogenicIDX),...
        normative.dataHUP.delta(normalIDX));
    d(s,2) = cohensD(epileptogenic.data.theta(epileptogenicIDX),...
        normative.dataHUP.theta(normalIDX));
    d(s,3) = cohensD(epileptogenic.data.alpha(epileptogenicIDX),...
        normative.dataHUP.alpha(normalIDX));
    d(s,4) = cohensD(epileptogenic.data.beta(epileptogenicIDX),...
        normative.dataHUP.beta(normalIDX));
    d(s,5) = cohensD(epileptogenic.data.gamma(epileptogenicIDX),...
        normative.dataHUP.gamma(normalIDX));
    d(s,6) = cohensD(epileptogenic.data.broad(epileptogenicIDX),...
        normative.dataHUP.broad(normalIDX));
    
    
    p(s,1) = ranksum(epileptogenic.data.delta(epileptogenicIDX),...
        normative.dataHUP.delta(normalIDX));
    p(s,2) = ranksum(epileptogenic.data.theta(epileptogenicIDX),...
        normative.dataHUP.theta(normalIDX));
    p(s,3) = ranksum(epileptogenic.data.alpha(epileptogenicIDX),...
        normative.dataHUP.alpha(normalIDX));
    p(s,4) = ranksum(epileptogenic.data.beta(epileptogenicIDX),...
        normative.dataHUP.beta(normalIDX));
    p(s,5) = ranksum(epileptogenic.data.gamma(epileptogenicIDX),...
        normative.dataHUP.gamma(normalIDX));
    p(s,6) = ranksum(epileptogenic.data.broad(epileptogenicIDX),...
        normative.dataHUP.broad(normalIDX));
    
    
    pFDR(s,:) = mafdr(p(s,:),'BHFDR',true);
    
end


data1 = [2.92910884264864,2.55476977549027,3.18177888444041,3.41597581603703;2.76253336817841,2.49286392435654,3.10313626748138,3.39798839347884;2.72240663244786,2.66159381213825,3.48515941789651,3.65383206362446;NaN,1.44939523558157,3.21444789662286,2.81993639700518;NaN,1.63428679048126,2.85257069190797,2.73783451159079;NaN,1.86289766031633,3.01094435646109,3.06818992790767;NaN,2.06343050035799,3.00599491432117,2.99417881840291;NaN,1.88813114303281,2.77619592988214,NaN;NaN,1.30102839179637,2.84468888712657,NaN;NaN,1.28214307454995,3.03146129326744,NaN;NaN,1.47602671510148,3.12040384170678,NaN;NaN,2.15112685974370,3.04274299510914,NaN;NaN,1.91978770330359,2.71911963913687,NaN;NaN,1.44268192976213,NaN,NaN;NaN,1.36594088832364,NaN,NaN;NaN,1.41477574402013,NaN,NaN;NaN,1.38669795107077,NaN,NaN;NaN,1.45480138492235,NaN,NaN;NaN,1.96967430952138,NaN,NaN;NaN,1.61812502719626,NaN,NaN;NaN,1.52428132130348,NaN,NaN;NaN,1.51662396167816,NaN,NaN;NaN,1.61555278120697,NaN,NaN;NaN,1.76996151265919,NaN,NaN;NaN,1.76645062136272,NaN,NaN;NaN,1.95304486424269,NaN,NaN;NaN,1.96462119917877,NaN,NaN;NaN,2.25111281459788,NaN,NaN;NaN,2.35551597738843,NaN,NaN];


Colors = [hex2rgb('DAE152');hex2rgb('CBE234')];
Colors = repmat(Colors,2,1);
labels = {'elileptogenic','normal'};
labels = repmat(labels,1,2);

figure
UnivarScatter(data1,'Label',labels,'MarkerFaceColor',Colors,...
    'MarkerEdgeColor','k','SEMColor',Colors/0.9,'StdColor',Colors,...
    'Whiskers','box');
%pbaspect([10,6,1]);
set(gca,'FontSize',12);
ylabel('Absolute power')
box off

end