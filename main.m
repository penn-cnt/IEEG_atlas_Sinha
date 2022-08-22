clc
clear
close all

%% Load a parcellation scheme and metaData
atlas.data = niftiread('../Data/AAL.nii.gz');
atlas.data(atlas.data>9000)=0;
atlas.hdr = niftiinfo('../Data/AAL.nii.gz');
load('../Data/roiAAL.mat','roiAAL');
roiAAL = roiAAL(1:90,:);
customAAL = readtable('../Data/custom_atlas.xlsx');
[atlasCustom,roiAALcustom] = mergeROIs(customAAL,roiAAL,atlas);
atlas.tbl = roiAAL;
atlasCustom.tbl = roiAALcustom;
atlas = atlasCustom;
clear roiAAL roiAALcustom atlasCustom customAAL


%% Load data
MNI_atlas = load('../Data/MNI_atlas_orig.mat');
load('../Data/metaData.mat');
HUP_atlasAll = load('../Data/HUP_atlas.mat');
EngelSFThres = 1.4;
spikeThresh = 24; % this is empirical, 1 spike/hour

%% univariate normaltive modelling of HUP-MNI
[norm_MNI_HUP_Atlas,iEEGhupAll,abrnormHUPAtlas] = ...
    mainUnivar(metaData,atlas,MNI_atlas,HUP_atlasAll,EngelSFThres,spikeThresh);

iEEGhupAll_z = univariateAbr(norm_MNI_HUP_Atlas,iEEGhupAll);

%% save univariate
save("../data/norm_MNI_HUP_Atlas.mat", "norm_MNI_HUP_Atlas")
save("../data/custom_atlas_normative.mat", "atlas")

%% multivariate normaltive modelling of HUP-MNI
[norm_Connection,norm_ConnectionCount,pat_Connection,pat_ConnectionCount] = ...
    mainNetwork(metaData,atlas,MNI_atlas,HUP_atlasAll,EngelSFThres,spikeThresh);
%% calc multi var ab
load('multivar_atlas_run.mat')
try
    load('pat_ConnectionRedAAL_z.mat');
catch
    pat_Connection = netowkrAbr_par(norm_Connection,pat_Connection);
end

%%
load('pat_conn_z.mat')
%%
abrConn = edgeslist2AbrConn(pat_Connection,HUP_atlasAll); % converts edge list to connectivity matrix
percentile_thres = 75;
iEEGhupAll_z = nodeAbrEdge(abrConn,iEEGhupAll_z,percentile_thres);
%% 
