function iEEGnormal = getNormEntropy(iEEGnormal,data_timeS,SamplingFrequency)

% get sampling frequency, time domain data, window length, and NFFT
Fs = SamplingFrequency;
data.seg = data_timeS(1:Fs*60,:);

data.segbb  = eegFilter(double(data.seg),80,Fs,'low',3); 
data.segbb  = eegFilter(double(data.segbb),1,Fs,'high',3); 
data.segbbNotch  = notch_filter(double(data.segbb),60,Fs);

% Compute shannon entropy
for chan = 1:size(data.segbbNotch,2)
    data.entropy(chan,:) = wentropy(data.segbbNotch(chan,:),'shannon');
end

% Compute log10 shannon entropy
data.entropy = log10(-data.entropy+1);

% 
iEEGnormal = [iEEGnormal, table(data.entropy,'VariableNames',{'entropy'})];

end