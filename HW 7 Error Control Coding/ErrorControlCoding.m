%%Digital Modulation & Demodulation
%% Hendrick Ambroise

%Use 100000 random data bits as a source
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
fprintf('Number of errors without ECC: %d\nbit Error Rate: %f\n', num_errors_no_ECC, num_errors_no_ECC/N);

%% ECC
[h, g, n, k] = hammgen(3);
t = syndtable(h);
input_blocks = reshape(input_bits,N/k,k);
cws = rem(input_blocks*g, 2);
tx_symbols = pskmod(cws, M);
rx_symbols = awgn(tx_symbols, snr, 'measured');
rx_cws = pskdemod(rx_symbols, M);
rx_syndromes = rem(rx_cws*h', 2);
rx_syndromes_dec = bi2de(rx_syndromes,'left-msb');
num_errors_ECC = length(rx_syndromes (rx_syndromes_dec~=0));
fprintf('Number of errors extra bits with ECC: %d\nbit Error Rate: %f\n', num_errors_ECC, num_errors_ECC/N);

error_vectors = t(1+rx_syndromes_dec, 1);
corrected_cws = bitxor(rx_cws, error_vectors);
rx_blocks = corrected_cws(1, 4:n);
num_errors_after_corrections = sum(input_bits~= rx_blocks(1));
fprintf('Code rate for Hamming code is %f\n', k/n);
fprintf('Number of errors with Hamming linear block ECC: %d\nBER: %f\n',num_errors_after_corrections,num_errors_ECC/num_errors_after_corrections)

%% Convolution Coding
trellis = poly2trellis(3, [6, 7]);
code = convenc(input_bits, trellis);

tx_conv_symbols = pskmod(code, M);
rx_conv_symbols = awgn(tx_conv_symbols, snr, 'measured');
rx_code = pskdemod(rx_conv_symbols, M);
tbdepth = 34;
rx_bits = vitdec(rx_code, trellis, tbdepth, 'trunc','hard');
num_conv_errors = sum(input_bits ~= rx_bits);
fprintf('Code rate for convolotion coding is 1/2\n');
fprintf('Number of errors with convolutional ECC: %d\nBER: %f\n', num_conv_errors, num_conv_errors/N)
