function [output] = eegFilter(EEG, cutoff, sample_rate, high_or_low, order)
%simple filter
  ny=sample_rate/2;

  [b,a] = butter(order, cutoff/ny, high_or_low);

  output = filtfilt(b,a,EEG);

end