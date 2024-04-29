%% CDMA
%% Hendrick Ambroise


close all; clear; clc

Ldata = 20000;      % data length in simulation; Must be divisible by 8
Lc = 11;            % spreading factor vs data rate.

% Generate QPSK modulation symbols
data_sym = 2*round(rand(Ldata, 1)) - 1 + 1j*(2*round(rand(Ldata, 1)) - 1);
jam_data = 2*round(rand(Ldata, 1)) - 1 + 1j*(2*round(rand(Ldata, 1)) - 1);

% Generating a spreading code
pcode = [1 1 1 -1 -1 -1 1 -1 -1 1 -1]';

% Now spread
x_in = kron(data_sym, pcode);

% Calculate and plot spectrum for CDMA signal without jamming
[P, x] = pwelch(x_in, [], [], 4096, Lc, 'twosided');
figure(1);
semilogy(x - Lc/2, fftshift(P));
axis([-Lc/2 Lc/2 1.e-2 1.e2]);
grid;
xfont = xlabel('frequency (in unit of 1/T_s)');
yfont = ylabel('CDMA signal PSD');
set(xfont, 'FontSize', 11); set(yfont, 'FontSize', 11);

% Iterate through different SIR values
SIR_values = [5, 8, 10, 20];
for s = 1:length(SIR_values)
   SIR = SIR_values(s);  % Signal to Interference Ratio is in dB
   Pj = 2*Lc / (10^(SIR/10)); % Calculate jamming power
  
   % Generate noise (AWGN)
   noiseq = randn(Ldata*Lc, 1) + 1j*randn(Ldata*Lc, 1); % Power is 2
   noiseq2 = rand(Ldata, 1) + 1j*rand(Ldata, 1);
  
   %% Add jamming sinusoid sampling frequency is fc = Lc
   jam_mod = kron(jam_data, ones(Lc, 1));
   jammer = sqrt(Pj/2)*jam_mod.*exp(1i*2*pi*0.12*(1:Ldata*Lc)).'; % fj/fc=0.12.
   jammer2 = sqrt(Pj/2)*jam_data.*exp(1i*2*pi*0.12*(1:Ldata)).';
  
   % Calculate and plot spectrum for CDMA signal with narrowband jamming
   [P, x] = pwelch(jammer+x_in, [], [], 4096, Lc, 'twosided');
   figure(1 + s);
   semilogy(x - Lc/2, fftshift(P));
   axis([-Lc/2 Lc/2 1.e-2 1.e2]);
   grid;
   xfont = xlabel('frequency (in unit of 1/T_s)');
   yfont = ylabel('CDMA signal + narrowband jammer PSD');
   title(sprintf('SIR = %d dB', SIR));
   set(xfont, 'FontSize', 11); set(yfont, 'FontSize', 11);
  
   % Calculate and plot BER
   BER = [];
   BER_az = [];
   BER_nss = [];
   BER_nss_jam = [];
   for i=1:10
       Eb2N(i) = (i-1);                      %(Eb/N in dB)
       Eb2N_num = 10^(Eb2N(i)/10);         % Eb/N in numeral
       Var_n = Lc/(2*Eb2N_num);            % 1/SNR is the noise variance
       signois = sqrt(Var_n);              % standard deviation
       awgnois = signois*noiseq;           % AWGN
       awgnois2 = signois*noiseq2;
       % Add noise to signals at the channel output
       y_out = x_in + awgnois + jammer;
       y_out2 = data_sym + awgnois2;
       y_out3 = data_sym + awgnois2 + jammer2;
       Y_out = reshape(y_out, Lc, Ldata).';
       % Despread first
       z_out = Y_out*pcode;
       z_out2 = y_out2;
       z_out3 = y_out3;
      
       % Decision based on the sign of the samples
       dec1 = sign(real(z_out)) + 1j*sign(imag(z_out));
       dec2 = sign(real(z_out2)) + 1j*sign(imag(z_out2));
       dec3 = sign(real(z_out3)) + 1j*sign(imag(z_out3));
       
       % Now compare against the original data to compute BER
       BER = [BER; sum([real(data_sym) ~= real(dec1); imag(data_sym) ~= imag(dec1)])/(2*Ldata)];
       BER_az = [BER_az; 0.5*erfc(sqrt(Eb2N_num))];          %analytical
       BER_nss = [BER_nss; sum([real(data_sym) ~= real(dec2); imag(data_sym) ~= imag(dec2)])/(2*Ldata)];
       BER_nss_jam = [BER_nss_jam; sum([real(data_sym) ~= real(dec3); imag(data_sym) ~= imag(dec3)])/(2*Ldata)];
   end
 
   % Plot BER
   figure(5 + s);
   figber = semilogy(Eb2N, BER_az, 'k-', Eb2N, BER, 'k-o', Eb2N, BER_nss, 'b-', Eb2N, BER_nss_jam, 'r-');
   hold on;
   title(sprintf('BER for SIR = %d dB', SIR));
   xlabel('E_b/N (dB)');
   ylabel('Bit error rate');
end

% Plotting configuration for BER
legend('No jamming', 'Narrowband jamming', 'No spreading', 'No spreading jammed', 'location', 'southwest');
set(figber, 'LineWidth', 2);

% Calculate and plot spectrum for non-spread QPSK signal
[P_qpsk, x_qpsk] = pwelch(data_sym, [], [], [4096], 1, 'twosided');
figure(10);
semilogy(x_qpsk - 0.5, fftshift(P_qpsk));
axis([-0.5 0.5 1.e-2 1.e2]);
grid;
xfont = xlabel('frequency (in unit of 1/T_s)');
yfont = ylabel('QPSK signal PSD');
title('Non-Spread QPSK Signal Spectrum');
set(xfont, 'FontSize', 11); set(yfont, 'FontSize', 11);

