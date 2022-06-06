function norm_Connection = makeEdgeList(iEEGhup,data_HUP,cord_HUP,...
    iEEGmni,data_MNI,cord_MNI,SamplingFrequency)
% get sampling frequency, time domain data, window length, and NFFT
Fs = SamplingFrequency;
window = Fs*2;
NFFT = window;

sub.MNI = unique(iEEGmni.patientNum);
sub.HUP = unique(iEEGhup.patientNum);

norm_Connection = [];

%% norm_Connection in MNI

for s = 1:numel(sub.MNI)
    tic;
    data = data_MNI(1:Fs*60,(iEEGmni.patientNum==sub.MNI(s)));
    roi1 = iEEGmni.roiNum(iEEGmni.patientNum==sub.MNI(s));
    roi1cord = cord_MNI(iEEGmni.patientNum==sub.MNI(s),:);
    
    for elec = 1:size(data,2)
        
        roi2 = repmat(roi1(elec),size(roi1));
        roi2cord = repmat(roi1cord(elec,:),size(roi1));
        patientNum = repmat(sub.MNI(s),size(roi1));
        
        [coh,f] = mscohere(data(:,elec),data,hamming(window),[],NFFT,Fs);
        
        % FilterOut noise frequency 57.7Hz to 62.5Hz
        coh(find(f==57.5):find(f==62.5),:) = [];
        f(find(f==57.5):find(f==62.5),:) = [];
        
        % Compute band average coherence
        deltaCoh(:,elec) = mean(coh(find(f==1)          :  find(f==4),:));
        thetaCoh(:,elec) = mean(coh(find(f>4,1,'first') :  find(f==8),:));
        alphaCoh(:,elec) = mean(coh(find(f>8,1,'first') :  find(f==13),:));
        betaCoh(:,elec)  = mean(coh(find(f>13,1,'first'):  find(f==30),:));
        gammaCoh(:,elec) = mean(coh(find(f>30,1,'first'):  find(f==80),:));
        broadCoh(:,elec) = mean(coh(find(f==1,1)        :  find(f==80),:));
        
        connect(:,1) = roi2;
        connect(:,2) = roi1;
        connect(:,3) = patientNum;
        connect(:,4) = deltaCoh(:,elec);
        connect(:,5) = thetaCoh(:,elec);
        connect(:,6) = alphaCoh(:,elec);
        connect(:,7) = betaCoh(:,elec);
        connect(:,8) = gammaCoh(:,elec);
        connect(:,9) = broadCoh(:,elec);
        
        roi2toroi1 = [roi2cord, roi1cord];
        norm_Connection = [norm_Connection; [connect, roi2toroi1]];
        
        
    end
    
    clear deltaCoh thetaCoh alphaCoh betaCoh gammaCoh broadCoh connect roi2toroi1
    elapsedTime = toc;
    disp(['MNI Subject ' num2str(s) ' took ' num2str(elapsedTime) 's']);
    
end

%% norm_Connection in HUP

for s = 1:numel(sub.HUP)
    tic;
    data = data_HUP(1:Fs*60,(iEEGhup.patientNum==sub.HUP(s)));
    roi1 = iEEGhup.roiNum(iEEGhup.patientNum==sub.HUP(s));
    roi1cord = cord_HUP(iEEGhup.patientNum==sub.HUP(s),:);
    
    for elec = 1:size(data,2)
        
        roi2 = repmat(roi1(elec),size(roi1));
        roi2cord = repmat(roi1cord(elec,:),size(roi1));
        patientNum = repmat(sub.HUP(s),size(roi1));
        
        [coh,f] = mscohere(data(:,elec),data,hamming(window),[],NFFT,Fs);
        
        % FilterOut noise frequency 57.7Hz to 62.5Hz
        coh(find(f==57.5):find(f==62.5),:) = [];
        f(find(f==57.5):find(f==62.5),:) = [];
        
        % Compute band average coherence
        deltaCoh(:,elec) = mean(coh(find(f==1)          :  find(f==4),:));
        thetaCoh(:,elec) = mean(coh(find(f>4,1,'first') :  find(f==8),:));
        alphaCoh(:,elec) = mean(coh(find(f>8,1,'first') :  find(f==13),:));
        betaCoh(:,elec)  = mean(coh(find(f>13,1,'first'):  find(f==30),:));
        gammaCoh(:,elec) = mean(coh(find(f>30,1,'first'):  find(f==80),:));
        broadCoh(:,elec) = mean(coh(find(f==1,1)        :  find(f==80),:));
        
        connect(:,1) = roi2;
        connect(:,2) = roi1;
        connect(:,3) = patientNum+110;
        connect(:,4) = deltaCoh(:,elec);
        connect(:,5) = thetaCoh(:,elec);
        connect(:,6) = alphaCoh(:,elec);
        connect(:,7) = betaCoh(:,elec);
        connect(:,8) = gammaCoh(:,elec);
        connect(:,9) = broadCoh(:,elec);
        
        roi2toroi1 = [roi2cord, roi1cord];
       
        norm_Connection = [norm_Connection; [connect, roi2toroi1]];
        
    end
    
    clear deltaCoh thetaCoh alphaCoh betaCoh gammaCoh broadCoh connect roi2toroi1
    elapsedTime = toc;
    disp(['HUP Subject ' num2str(s) ' took ' num2str(elapsedTime) 's']);
end

norm_Connection = array2table(norm_Connection);
norm_Connection.Properties.VariableNames = {'roi2','roi1','patientNum',...
    'delta','theta','alpha','beta','gamma','broad',...
    'roi2x','roi2y','roi2z','roi1x','roi1y','roi1z'};

end