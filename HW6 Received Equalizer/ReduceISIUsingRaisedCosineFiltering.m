%% Received Equalization
%% Hendrick Ambroise

% Modulation Order
M = 16;
% Create square root raised cosine filter objects
txfilter = comm.RaisedCosineTransmitFilter;
rxfilter = comm.RaisedCosineReceiveFilter;
% Create a memoryless nonlinearity System object to introduce nonlinear behavior to the modulated signal
hpa = comm.MemorylessNonlinearity('Method','Saleh model','InputScaling',-10,'OutputScaling',0);
% Generate random integers and apply 16-QAM modulation
x = randi([0 M-1],1000,1);
modSig = qammod(x,M,'UnitAveragePower',true);
% Plot the eye diagram of the modulated signal
eyediagram(modSig,2)
%Amplify the modulated signal using hpa
txSigNoFilt = hpa(modSig);
% Plot the eye diagram of the amplified signal without RRC filtering
eyediagram(txSigNoFilt,2)
% Find the modulated signal using RRC transmit filter
filteredSig = txfilter(modSig);
% Release hpa and amplify the filtered signal
release(hpa)
txSig = hpa(filteredSig);
%Filter txSig using the RRC matched receive filter
rxSig = rxfilter(txSig);
% Plot the eye diagram of the signal after the application of the receive filter
eyediagram(rxSig,2)


