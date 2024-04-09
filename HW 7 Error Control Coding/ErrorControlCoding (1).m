%% Error Control Coding
%% Hendrick Ambroise

% Use 100000 random data bits as a source
close all; clear; clc;
N = 100000;
M = 2;
snr = 6;
input_bits = randi([0 1], [N 1]);
%% No ECC
tx_symbols = pskmod(input_bits, M);
rx_symbols = awgn(tx_symbols, snr, 'measured');
rx_bits = pskdemod(rx_symbols, M);
num_errors_no_ECC = sum(input_bits ~= rx_bits);
fprintf('Number of errors without ECC: %d\n', num_errors_no_ECC);
fprintf('Bit Error Rate without ECC: %f\n', num_errors_no_ECC / N);
%% ECC - Hamming Code
[h, g, n, k] = hammgen(3);
t = syndtable(h);
input_blocks = reshape(input_bits, N/k, k);
cws = rem(input_blocks * g, 2);
tx_symbols = pskmod(cws, M);
rx_symbols = awgn(tx_symbols, snr, 'measured');
rx_cws = pskdemod(rx_symbols, M);
rx_syndromes = rem(rx_cws * h', 2);
rx_syndromes_dec = bi2de(rx_syndromes, 'left-msb');
num_errors_ECC = sum(rx_syndromes_dec ~= 0);
fprintf('Number of errors with Hamming ECC: %d\n', num_errors_ECC);
fprintf('Bit Error Rate with Hamming ECC: %f\n', num_errors_ECC / N);
error_vectors = t(1 + rx_syndromes_dec, :);
corrected_cws = bitxor(rx_cws, error_vectors);
rx_blocks = corrected_cws(:, 4:n); % Extracting data bits (excluding parity bits)
rx_bits_hamming = rx_blocks(:);
num_errors_after_corrections = sum(input_bits ~= rx_bits_hamming);
fprintf('Code rate for Hamming code is %f\n', k/n);
fprintf('Number of errors after correction with Hamming ECC: %d\n', num_errors_after_corrections);
fprintf('Bit Error Rate after correction with Hamming ECC: %f\n', num_errors_after_corrections / N);
%% Convolution Coding
trellis = poly2trellis(3, [6, 7]);
code = convenc(input_bits, trellis);
tx_conv_symbols = pskmod(code, M);
rx_conv_symbols = awgn(tx_conv_symbols, snr, 'measured');
rx_code = pskdemod(rx_conv_symbols, M);
tbdepth = 34;
rx_bits_conv = vitdec(rx_code, trellis, tbdepth, 'trunc', 'hard');
num_conv_errors = sum(input_bits ~= rx_bits_conv);
fprintf('Code rate for convolution coding is 1/2\n');
fprintf('Number of errors with Convolutional ECC: %d\n', num_conv_errors);
fprintf('Bit Error Rate with Convolutional ECC: %f\n', num_conv_errors / N);
