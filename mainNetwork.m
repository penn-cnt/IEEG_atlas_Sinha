function [norm_Connection,norm_ConnectionCount,pat_Connection,pat_ConnectionCount] = ...
    mainNetwork(metaData,atlas,MNI_atlas,HUP_atlasAll,EngelSFThres,spikeThresh)
%% MNI atlas electrode to ROI
%MNI_atlas = load('../Data/MNI_atlas.mat');
electrodeCord = MNI_atlas.ChannelPosition;
patientNum = MNI_atlas.Patient;
iEEGmni = implant2ROI(atlas,electrodeCord,patientNum);

%% MNI atlas normalised bandpower
data_MNI = MNI_atlas.Data_W;
SamplingFrequency = MNI_atlas.SamplingFrequency;
iEEGmni = getNormPSD(iEEGmni,data_MNI,SamplingFrequency);

%% Seizure free HUP atlas electrode to ROI
%load('../Data/metaData.mat');
% HUP_atlasAll = load('../Data/HUP_atlas.mat');
% EngelSFThres = 1.4;
% spikeThresh = 24; % this is empirical, 1 spike/hour
HUP_atlas = makeSeizureFree(HUP_atlasAll,metaData,EngelSFThres,spikeThresh);
electrodeCord = HUP_atlas.mni_coords;
patientNum = HUP_atlas.patient_no;
iEEGhup = implant2ROI(atlas,electrodeCord,patientNum);

%% HUP atlas normalised bandpower
data_HUP = HUP_atlas.wake_clip;
SamplingFrequency = HUP_atlas.SamplingFrequency;
iEEGhup = getNormPSD(iEEGhup,data_HUP,SamplingFrequency);

%% Make an edge list of normal edges
cord_HUP = HUP_atlas.mni_coords;
cord_MNI = MNI_atlas.ChannelPosition;

try
    load('nom_ConnectionRedAAL.mat');
catch
    norm_Connection = makeEdgeList(iEEGhup,data_HUP,cord_HUP,...
        iEEGmni,data_MNI,cord_MNI,SamplingFrequency);
end

%% visualisation for normative iEEG
norm_ConnectionCount = checkSparsity(norm_Connection,atlas);
%hupSub = [11,28,22];
%mniSub = [44, 47];
%makeConnectVis(iEEGhup,cord_HUP,hupSub,iEEGmni,cord_MNI,mniSub);

%% analysis of an all HUP patients

electrodeCord = HUP_atlasAll.mni_coords;
patientNum = HUP_atlasAll.patient_no;
iEEGhupAll = implant2ROI(atlas,electrodeCord,patientNum);

data_HUPAll = HUP_atlasAll.wake_clip;
SamplingFrequency = HUP_atlasAll.SamplingFrequency;
iEEGhupAll = getNormPSD(iEEGhupAll,data_HUPAll,SamplingFrequency);
cord_HUPAll = HUP_atlasAll.mni_coords;

try
    load('pat_ConnectionRedAAL.mat');
catch
    pat_Connection = makeEdgeListPat(iEEGhupAll,data_HUPAll,cord_HUPAll,SamplingFrequency);
end

%% visualisation of example patient
pat_ConnectionCount = checkSparsity(pat_Connection,atlas);

% HUP_atlasExPat.SamplingFrequency = HUP_atlasAll.SamplingFrequency;
% HUP_atlasExPat.depth_elecs = HUP_atlasAll.depth_elecs(examplePatient,:);
% HUP_atlasExPat.mni_coords = HUP_atlasAll.mni_coords(examplePatient,:);
% HUP_atlasExPat.patient_no = HUP_atlasAll.patient_no(examplePatient,:);
% HUP_atlasExPat.resected_ch = HUP_atlasAll.resected_ch(examplePatient,:);
% HUP_atlasExPat.soz_ch = HUP_atlasAll.soz_ch(examplePatient,:);
% HUP_atlasExPat.spike_24h = HUP_atlasAll.spike_24h(examplePatient,:);
% HUP_atlasExPat.wake_clip = HUP_atlasAll.wake_clip(:,examplePatient);
% electrodeCord = HUP_atlasExPat.mni_coords;
% patientNum = HUP_atlasExPat.patient_no;
%
% iEEGhupExPat = implant2ROI(atlas,electrodeCord,patientNum);
% data_HUPExPat = HUP_atlasExPat.wake_clip;
% SamplingFrequency = HUP_atlasExPat.SamplingFrequency;
% iEEGhupExPat = getNormPSD(iEEGhupExPat,data_HUPExPat,SamplingFrequency);
% cord_HUP = HUP_atlasExPat.mni_coords;
%
% exPat_Connection = makeEdgeListPat(iEEGhupExPat,data_HUPExPat,cord_HUP,SamplingFrequency);
% exPat_ConnectionCount = checkSparsity(exPat_Connection,atlas);
% resec_HUP = HUP_atlasExPat.resected_ch;
% hupSub = 5;
% makeConnectVisPat(iEEGhupExPat,cord_HUP,resec_HUP,hupSub);

%% Visualise ROI level connectivity

% ROIinExPat = unique(exPat_Connection.roi1);
% coord = [atlas.tbl.x(ismember(atlas.tbl.Sno,ROIinExPat)),...
%     atlas.tbl.y(ismember(atlas.tbl.Sno,ROIinExPat)),...
%     atlas.tbl.z(ismember(atlas.tbl.Sno,ROIinExPat))];
% exPatROI = [coord, ones(numel(ROIinExPat),1), ones(numel(ROIinExPat),1)];
% dlmwrite('exPatROI.node', exPatROI, 'delimiter','\t');
% exPatEdge1 = [1.01302893665425,0.780583294607432,1.52407022261858,0.172003829642069,1.58183509491665,0.545704418999501,0.699868463743900,1.62330377648352,1.04893439609733,1.18102266371290,1.20000000000000,0.847600000000000,0.675500000000000;0.780583294607432,0,0,0,0,0,0,0,0,0,0,0,0;1.52407022261858,0,0,0,0,0,0,0,0,0,0,0,0;0.172003829642069,0,0,0,0,0,0,0,0,0,0,0,0;1.58183509491665,0,0,0,0,0,0,0,0,0,0,0,0;0.545704418999501,0,0,0,0,0,0,0,0,0,0,0,0;0.699868463743900,0,0,0,0,0,0,0,0,0,0,0,0;1.62330377648352,0,0,0,0,0,0,0,0,0,0,0,0;1.04893439609733,0,0,0,0,0,0,0,0,0,0,0,0;1.18102266371290,0,0,0,0,0,0,0,0,0,0,0,0;1.20000000000000,0,0,0,0,0,0,0,0,0,0,0,0;0.847600000000000,0,0,0,0,0,0,0,0,0,0,0,0;0.675500000000000,0,0,0,0,0,0,0,0,0,0,0,0];
% dlmwrite('exPatEdge1.edge', exPatEdge1, 'delimiter','\t');
%
% exPatEdge85 = [0,0,0,0,0,0,0,0,0,0,1.20000000000000,0,0;0,0,0,0,0,0,0,0,0,0,1.52407022261858,0,0;0,0,0,0,0,0,0,0,0,0,0.172003829642069,0,0;0,0,0,0,0,0,0,0,0,0,1.58183509491665,0,0;0,0,0,0,0,0,0,0,0,0,0.545704418999501,0,0;0,0,0,0,0,0,0,0,0,0,0.699868463743900,0,0;0,0,0,0,0,0,0,0,0,0,1.62330377648352,0,0;0,0,0,0,0,0,0,0,0,0,1.04893439609733,0,0;0,0,0,0,0,0,0,0,0,0,1.18102266371290,0,0;0,0,0,0,0,0,0,0,0,0,1.01302893665425,0,0;1.20000000000000,0.780583294607432,1.52407022261858,0.372003829642069,1.58183509491665,0.545704418999501,0.699868463743900,1.62330377648352,1.04893439609733,1.18102266371290,0.847600000000000,0.847600000000000,0.675500000000000;0,0,0,0,0,0,0,0,0,0,0.675500000000000,0,0;0,0,0,0,0,0,0,0,0,0,0.780583294607432,0,0];
% dlmwrite('exPatEdge85.edge', exPatEdge85, 'delimiter','\t');
end