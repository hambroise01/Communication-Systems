%% Q function to calculate the error probability equipprobable binary antipodal modulation
x = -4:0.1:4;
y = qfunc(x);
plot(x,y)
grid
ebnodB = 7;
ebno = 10^(ebnodB/10);
Pb = qfunc(sqrt(2*ebno));
fprintf('Error probability of Qfunction: %f\n', Pb);
saveas(gcf, 'Qfunction.fig');
%% Calculate the error probability using 10000 input data points
k = 1;
M = 2^k;
N = [10000, 1];
i_data = randi(0:M-1,N);
%Modulate and demodulate 
tx_sig = pammod(i_data, M);
SNR = 10;
rx_sig = awgn(tx_sig, SNR);
o_data = pamdemod(rx_sig, M);
errors = sum(i_data ~= o_data);
fprintf('Number of errors with Qfunction: %i\n', errors);
figure;
scatterplot(rx_sig);
title("PAM Constellation (PAM M=2)")
saveas(gcf, 'pamconstellationforqfunction.fig');