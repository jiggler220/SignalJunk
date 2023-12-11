% NOTE:, ensure  sampling rate exceeds sampling window * samplingPoint
% Frequency exceeds sampling window if the sampling window is larger it
% will look to far out and see nothing, representing a line across the
% x-axis (i.e) sample_rate = 13, samplePointFreq_s = 3, k = 20. 39 < 41,
% meaning bad line)
sampleRate_s = 500; % samples per sec
samplePointFreq_s = 3; % time vector will span for this long
time_s = 0:1/sampleRate_s:samplePointFreq_s; % time vector from 0 to the sampling interval
n = length(time_s); % number of samples
p = 15; % poles for interpolation

% noise level, measured in std
noiseAmp_std = 5;

% amplitude
ampl = interp1(rand(p,1)*30, linspace(1,p,n)); % interpolate across p timepoints
noise = noiseAmp_std * randn(size(time_s)); % add random noise
signal = ampl + noise; % amp + noise = sig

% filtered signal vector
filtSig = zeros(size(signal));

% running mean filter
k = 20; % how far out do you want to look?
sampleWindow_ms = 1000 * (k*2+1) / sampleRate_s; % look this many ms forward and backward to calculate your running mean

% each point is the average of k surrounding points
for i=k+1:n-k-1 % from signal start to signal end
    filtSig(i) = mean(signal(i-k:i+k)); %  filtered signal is between x-1 and x + 1 points sort of like a moving "line of regression"
end

figure(1), clf, hold on % clear figure, keep the axes
plot(time_s, signal, time_s, filtSig, 'linew', 2); % plot signal vs time and time vs filtered signal