function [norm_MNI_HUP_Atlas,iEEGhupAll,abrnormHUPAtlas] = ...
    mainUnivar(metaData,atlas,MNI_atlas,HUP_atlasAll,EngelSFThres,spikeThresh)
%% MNI atlas electrode to ROI
%MNI_atlas = load('../Data/MNI_atlas.mat');
electrodeCord = MNI_atlas.ChannelPosition;
patientNum = MNI_atlas.Patient;
iEEGmni = implant2ROI(atlas,electrodeCord,patientNum);

%% MNI atlas normalised bandpower
data_MNI = MNI_atlas.Data_W;
SamplingFrequency = MNI_atlas.SamplingFrequency;
iEEGmni = getNormPSD(iEEGmni,data_MNI,SamplingFrequency);
%iEEGmni = getNormEntropy(iEEGmni,data_MNI,SamplingFrequency);

%% Seizure free HUP atlas electrode to ROI
%load('../Data/metaData.mat');
%HUP_atlasAll = load('../Data/HUP_atlas.mat');
%EngelSFThres = 1.4;
%spikeThresh = 24; % this is empirical, 1 spike/hour
HUP_atlas = makeSeizureFree(HUP_atlasAll,metaData,EngelSFThres,spikeThresh);
electrodeCord = HUP_atlas.mni_coords;
patientNum = HUP_atlas.patient_no;
iEEGhup = implant2ROI(atlas,electrodeCord,patientNum);

%% HUP atlas normalised bandpower
data_HUP = HUP_atlas.wake_clip;
SamplingFrequency = HUP_atlas.SamplingFrequency;
iEEGhup = getNormPSD(iEEGhup,data_HUP,SamplingFrequency);
%iEEGhup = getNormEntropy(iEEGhup,data_HUP,SamplingFrequency);

%% Visualise MNI and HUP atlas
normMNIAtlas = plotiEEGatlas(iEEGmni,atlas,'noplot');
normHUPAtlas = plotiEEGatlas(iEEGhup,atlas,'noplot');
norm_MNI_HUP_Atlas = compareiEEGatlas(normMNIAtlas,normHUPAtlas,'plot');

%% 
electrodeCord = HUP_atlasAll.mni_coords;
patientNum = HUP_atlasAll.patient_no;
iEEGhupAll = implant2ROI(atlas,electrodeCord,patientNum);
data_HUPAll = HUP_atlasAll.wake_clip;
SamplingFrequency = HUP_atlasAll.SamplingFrequency;
iEEGhupAll = getNormPSD(iEEGhupAll,data_HUPAll,SamplingFrequency);

%% Abnormal HUP atlas
HUP_Abr_atlas = makeSeizureFreeAbr(HUP_atlasAll,metaData,EngelSFThres,spikeThresh);
electrodeCord = HUP_Abr_atlas.mni_coords;
patientNum = HUP_Abr_atlas.patient_no;
iEEGhupAbr = implant2ROI(atlas,electrodeCord,patientNum);
data_HUPAbr = HUP_Abr_atlas.wake_clip;
SamplingFrequency = HUP_Abr_atlas.SamplingFrequency;
iEEGhupAbr = getNormPSD(iEEGhupAbr,data_HUPAbr,SamplingFrequency);
abrnormHUPAtlas = plotiEEGatlas(iEEGhupAbr,atlas,'noplot');
abrnormHUPAtlas = sortrows(abrnormHUPAtlas,'nElecs','descend');

%% address reviewer 1 comment

% [pGrp,d] = rev1ActualPow(HUP_Abr_atlas,iEEGhupAbr,HUP_atlas,MNI_atlas,iEEGhup,iEEGmni);
% d = rev1SurgOutcome(HUP_atlasAll,iEEGhupAll,metaData);

end

