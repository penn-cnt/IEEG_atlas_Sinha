function HUP_Abr_Atlas = makeSeizureFreeAbr(HUP_atlasAll,metaData,EngelSFThres,spikeThresh)

% Set the strictest criteria
outcomes = nanmax([metaData.Engel_6_mo,metaData.Engel_12_mo],[],2);
SFpatients = find(outcomes<=EngelSFThres);

% Get the index of resected electrodes in SF patients
SFpatientsIEEG = ismember(HUP_atlasAll.patient_no,SFpatients);
resectedSFiEEG = (SFpatientsIEEG & HUP_atlasAll.resected_ch);

% make sure that resected electrodes are soz
SOZsparedSFiEEG = (resectedSFiEEG & HUP_atlasAll.soz_ch);

% make sure that resected electrodes are in the irritative zone
abnormaliEEG = (SOZsparedSFiEEG & HUP_atlasAll.spike_24h>spikeThresh);


HUP_Abr_Atlas.SamplingFrequency = HUP_atlasAll.SamplingFrequency;
HUP_Abr_Atlas.depth_elecs = HUP_atlasAll.depth_elecs(abnormaliEEG,:);
HUP_Abr_Atlas.mni_coords = HUP_atlasAll.mni_coords(abnormaliEEG,:);
HUP_Abr_Atlas.patient_no = HUP_atlasAll.patient_no(abnormaliEEG,:);
HUP_Abr_Atlas.resected_ch = HUP_atlasAll.resected_ch(abnormaliEEG,:);
HUP_Abr_Atlas.soz_ch = HUP_atlasAll.soz_ch(abnormaliEEG,:);
HUP_Abr_Atlas.spike_24h = HUP_atlasAll.spike_24h(abnormaliEEG,:);
HUP_Abr_Atlas.wake_clip = HUP_atlasAll.wake_clip(:,abnormaliEEG);

end