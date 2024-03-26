%% Hendrick Ambroise
% Received Equalizer

%% M = 16; % Modulation order
% Create square root raised cosine filter objects.
txfilter = comm.RaisedCosineTransmitFilter;
rxfilter = comm.RaisedCosineReceiveFilter;
% Create a memoryless nonlinearity System object™ to introduce nonlinear behavior to the modulated signal. Using name-value pairs, set the Method property to Saleh model to emulate a high power amplifier.
hpa = comm.MemorylessNonlinearity('Method','Saleh model', ...
   'InputScaling',-10,'OutputScaling',0);
% Generate random integers and apply 16-QAM modulation.
x = randi([0 M-1],1000,1);
modSig = qammod(x,M,'UnitAveragePower',true);
% Amplify the modulated signal using hpa.
txSigNoFilt = hpa(modSig);
% Filter the modulated signal using the RRC transmit filter.
filteredSig = txfilter(modSig);
% Release hpa and amplify the filtered signal. The release function is needed because the input signal dimensions change due to filter interpolation.
release(hpa)
txSig = hpa(filteredSig);
% Filter txSig using the RRC matched receive filter.
rxSig = rxfilter(txSig);
% Calculate the delay introduced by the transmit and receive filters
tx_filter_delay = mean(grpdelay(txfilter));
rx_filter_delay = mean(grpdelay(rxfilter));
% Align input and output arrays
aligned_modSig = modSig(tx_filter_delay+1:end-rx_filter_delay);
aligned_rxSig = rxSig(tx_filter_delay+1:end-rx_filter_delay);
% Add a demodulator with appropriate thresholding to compensate for the PA gain
demodSig = qamdemod(aligned_rxSig, M, 'UnitAveragePower', true);
% Adjust size of x to match demodSig
x_adjusted = x(1:length(demodSig));
% Calculate BER without filtering
ber_no_filt = biterr(x_adjusted, demodSig) / length(x_adjusted);
% Calculate BER with filtering
ber_with_filt = biterr(x_adjusted, qamdemod(aligned_modSig, M, 'UnitAveragePower', true)) / length(x_adjusted);
% Display BER results
fprintf('BER without filtering: %f\n', ber_no_filt);
fprintf('BER with filtering: %f\n', ber_with_filt);
