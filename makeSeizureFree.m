function HUP_atlas = makeSeizureFree(HUP_atlasAll,metaData,EngelSFThres,spikeThresh)

% Set the strictest criteria
outcomes = nanmax([metaData.Engel_6_mo,metaData.Engel_12_mo],[],2);
SFpatients = find(outcomes<=EngelSFThres);

% Get the index of spared electrodes in SF patients
SFpatientsIEEG = ismember(HUP_atlasAll.patient_no,SFpatients);
sparedSFiEEG = (SFpatientsIEEG & ~HUP_atlasAll.resected_ch);

% make sure that spared electrodes are not soz
notSOZsparedSFiEEG = (sparedSFiEEG & ~HUP_atlasAll.soz_ch);

% make sure that spared electrodes are not in the irritative zone
healthyiEEG = (notSOZsparedSFiEEG & HUP_atlasAll.spike_24h<spikeThresh);


HUP_atlas.SamplingFrequency = HUP_atlasAll.SamplingFrequency;
HUP_atlas.depth_elecs = HUP_atlasAll.depth_elecs(healthyiEEG,:);
HUP_atlas.mni_coords = HUP_atlasAll.mni_coords(healthyiEEG,:);
HUP_atlas.patient_no = HUP_atlasAll.patient_no(healthyiEEG,:);
HUP_atlas.resected_ch = HUP_atlasAll.resected_ch(healthyiEEG,:);
HUP_atlas.soz_ch = HUP_atlasAll.soz_ch(healthyiEEG,:);
HUP_atlas.spike_24h = HUP_atlasAll.spike_24h(healthyiEEG,:);
HUP_atlas.wake_clip = HUP_atlasAll.wake_clip(:,healthyiEEG);


end