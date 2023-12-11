% Set parameters
sampleRate_s = 10000; % Sampling rate
samplePointFreq_s = 3; % Duration of the time vector
n = sampleRate_s * samplePointFreq_s + 1; % Number of samples
p = 15; % Interpolation poles
noiseAmp_std = 5; % Noise level
fullWidthHalfMax_ms = 2; % Full-Width Half Max for Gaussian window
k = 15; % Half-width for the running mean filter

% Generate time vector and signal
time_s = (0:n-1) / sampleRate_s; % Time vector
ampl = interp1(rand(p,1)*30, linspace(1,p,n)); % Interpolated amplitude
noise = noiseAmp_std * randn(1, n); % Random noise
signal = ampl + noise; % Signal

% Create Gaussian window
gTime = 1000 * (-k:k) / sampleRate_s; % Time vector for Gaussian window
gausWin = exp(-(4*log(2)*gTime.^2) / fullWidthHalfMax_ms^2) / sum(exp(-(4*log(2)*gTime.^2) / fullWidthHalfMax_ms^2)); % Gaussian window

% Apply Gaussian smoothing filter
filteredSignal = conv(signal, gausWin, 'same'); % Convolution with Gaussian window

% Running mean filter
filtSigMean = zeros(size(signal));
k = 50; % Half-width for the running mean filter
for i=k+1:n-k-1
    filtSigMean(i) = mean(signal(i-k:i+k)); % Average of surrounding k points
end

% Plot the original, filtered, and running mean signals
figure(1), clf, hold on
plot(time_s, signal, 'b', 'linew', 2);
plot(time_s, filteredSignal, 'r', 'linew', 2);
plot(time_s, filtSigMean, 'black', 'linew', 2);
xlabel('Time (seconds)');
ylabel('Amplitude');
legend('Original Signal', 'Filtered Signal', 'Running Mean');
title('Gaussian Smoothing Filter');
hold off