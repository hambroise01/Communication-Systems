%% Transmitter 
%% Hendrick Ambroise
%%Clear everything 
clear; close all; clc
%% Set parameters
Oversampling = 20;
freq = 100e6;
amplitude = 10;
period = 1e-6;

%% Create timebase
fs = Oversampling*max(freq);
t = 0:1/fs:period - 1/fs;

% Create signal 
sig = amplitude*cos(2.0*pi*freq*t);

%% Plot signal
plot(t, sig)
xlabel("Time(seconds)")
ylabel("Amplitude")
title("Carrier Time Domain")