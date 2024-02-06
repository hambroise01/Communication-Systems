%% Transmitter 
%% Hendrick Ambroise
%%Clear everything 
clear; close all; clc
%% Set parameters
Oversampling = 20;
freq = 1010e3;
amplitude = 10.0;
T = 0.001;
bb_freq = 5000.0;
bb_amp = 10;
ka = 1;

%% Create timebase
fs = Oversampling*max(freq);
t = 0:1/fs:T - 1/fs;
N = length(t);
%% Create Carrier
sig = cos(2.0*pi*freq*t);
%% Create Baseband Signal
bb_sig = bb_amp*cos(2.0*pi*bb_freq*t);
%% Amplitude Modulation 
modulated = (amplitude + bb_sig).*sig;


%% Amplitude Modulation using ammod function
modulated_ammod = ammod(bb_sig, freq, fs, 0, amplitude);
%% Plot Results
figure, subplot(3,1,1)
plot(t, bb_sig)
xlabel("Time(seconds)")
ylabel("Amplitude")
title("Baseband Signal Time Domain")

subplot(3,1,2)
plot(t, modulated)
title("Amplitude Modulation Time Domain")
xlabel("Time(seconds)")
ylabel("Amplitude")

subplot(3,1,3);
plot(t, modulated_ammod);
xlabel("Time(seconds)")
ylabel("Amplitude")
title("Amplitude Modulation Signal (Using ammod")




