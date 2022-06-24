function iEEGnormal = getNormPSD(iEEGnormal,data_timeS,SamplingFrequency)

% get sampling frequency, time domain data, window length, and NFFT
Fs = SamplingFrequency;
data.seg = data_timeS(1:min(size(data_timeS,1),Fs*60),:);
window = Fs*2;
NFFT = window;

% Compute PSD
[data.psd,f]  = pwelch(data.seg,hamming(window),[],NFFT,Fs,'psd');

% FilterOut noise frequency 57.7Hz to 62.5Hz

data.psd(find(f==57.5):find(f==62.5),:) = [];
f(find(f==57.5):find(f==62.5),:) = [];

% Compute bandpower
data.delta = bandpower(data.psd,f,[1 4],'psd');
data.theta = bandpower(data.psd,f,[4 8],'psd');
data.alpha = bandpower(data.psd,f,[8 13],'psd');
data.beta = bandpower(data.psd,f,[13 30],'psd');
data.gamma = bandpower(data.psd,f,[30 80],'psd');
data.broad = bandpower(data.psd,f,[1 80],'psd');

% Compute log10 transform
data.deltalog = log10(data.delta+1);
data.thetalog = log10(data.theta+1);
data.alphalog = log10(data.alpha+1);
data.betalog = log10(data.beta+1);
data.gammalog = log10(data.gamma+1);
data.broadlog = log10(data.broad+1);

% Total band power
data.tPow = sum([data.deltalog;data.thetalog;data.alphalog;data.betalog;data.gammalog]);

% Relative band power
data.deltaRel = data.deltalog./data.tPow;
data.thetaRel = data.thetalog./data.tPow;
data.alphaRel = data.alphalog./data.tPow;
data.betaRel = data.betalog./data.tPow;
data.gammaRel = data.gammalog./data.tPow;

% 
iEEGnormal = [iEEGnormal, table(data.deltaRel',data.thetaRel',...
    data.alphaRel',data.betaRel',data.gammaRel',data.broadlog','VariableNames',...
    {'delta','theta','alpha','beta','gamma','broad'})];


% iEEGnormal = [iEEGnormal, table(data.deltalog',data.thetalog',...
%     data.alphalog',data.betalog',data.gammalog',data.broadlog','VariableNames',...
%     {'delta','theta','alpha','beta','gamma','broad'})];

end