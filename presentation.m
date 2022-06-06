clc
clear
close all
%% Plot electrodes for a patient
% HUP070 and HUP080
load('../Data/metaData.mat');
HUP_atlasAll = load('../Data/HUP_atlas.mat');

%%
sf = plotelecs(HUP_atlasAll,metaData,'HUP070','sfP',1);
nsf = plotelecs(HUP_atlasAll,metaData,'HUP080','nsfP',1);

%% plot some more surface brains
ecog = metaData.Patient([2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;22;25;26;36]);

for i = 1:numel(ecog)
   
    plotelecs(HUP_atlasAll,metaData,ecog{i},['ecogP' num2str(i) '_' ecog{i}],1);
    
end

%% Replot a few interesting brain
ex1 = plotelecs(HUP_atlasAll,metaData,'HUP065','HUP065',0);

%%

mni = MNI_atlas.Data_W(1:12000,(iEEGmni.roiNum == 1));
hup = HUP_atlas.wake_clip(:,(iEEGhup.roiNum == 1));
Precentral_L = [mni, hup];
ploteeg(Precentral_L(:,[1:2,32,33]),[],300)

peeg = HUP_atlasAll.wake_clip(:,(and(HUP_atlasAll.patient_no == 5, HUP_atlasAll.resected_ch == 1)));

%%
bp = [iEEGmni{(iEEGmni.roiNum == 1),4:8};iEEGhup{(iEEGhup.roiNum == 1),4:8}];
bp = [bp, bp];
imagesc(bp');

peeg = iEEGhup{(and(iEEGhup.patientNum == 5, HUP_atlasAll.resected_ch == 1))}
