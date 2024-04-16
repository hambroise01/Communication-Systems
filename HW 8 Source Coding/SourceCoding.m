%% Source Coding
%% Hendrick Ambroise


clear; close all; clc;
%% Create a Huffman encoder for a source with an alphabet
symbols = 0:6;
p = [0.1 0.2 0.1 0.4 0.05 0.05 0.1];
encoder = huffmandict(symbols, p);
% What is the minimum number of bits needed to represent the symbols?
num_bits = ceil(log2(max(symbols)+1)); % Adding 1 to include the maximum symbol itself
fprintf('2. It requires %d bits to represent the symbols without source coding.\n', num_bits);
% Create a source that emits the following symbols
source_symbols = [1 3 2 3 5 3 5 1 6 3 1 0 3 6 2 3 4 0 1 3];
% How many bits does it take to transmit these symbols without source coding?
fprintf('4. It takes %d bits to send the symbols without source encoding.\n', num_bits*length(source_symbols));
% How many bits does it take to transmit the encoded symbols?
coded = huffmanenco(source_symbols, encoder);
fprintf('6. It takes %d bits to send the encoded source symbols.\n', length(coded));
% Decode the encoded symbols
decoded = huffmandeco(coded, encoder);
% Compare decoded symbols with original symbols
if isequal(source_symbols, decoded)
  result = 'the same as';
else
  result = 'different from';
end
fprintf('The decoded results are %s the source symbols.\n', result);
N = 10000;
large_signal = randsrc(N, 1, [symbols; p])';
fprintf('4b. It requires %d bits to send the large signal without source coding.\n', num_bits*length(large_signal));
% How many bits does it take to transmit the encoded large signal?
coded_large_signal = huffmanenco(large_signal, encoder);
fprintf('6b. It requires %d bits to send the encoded large signal.\n', length(coded_large_signal));
% Decode the encoded large signal
decoded_large_signal = huffmandeco(coded_large_signal, encoder);
% Compare decoded large signal with original large signal
if isequal(decoded_large_signal, large_signal)
  result = 'the same as';
else
  result = 'different from';
end
fprintf('8b. The decoded version of the large signal is %s the source signal.\n', result);
% What is the entropy of the source?
H = -sum(p.*log2(p));
fprintf('10. The entropy of the source is %f.\n', H);
% What is the average rate?
avg_length = 0;
for i = 1:length(encoder)
  codeword = encoder{i, 2}; % Extract the codeword from the encoder
  avg_length = avg_length + p(i)*length(codeword);
end
fprintf('11. The weighted average length of the encoded source symbol is %f.\n', avg_length);
