function y = notch_filter(data,fc,fs)

wo = fc/(fs/2);
bw = wo/35;

[b,a] = iirnotch(wo,bw);
y = filter(b,a,data);

end