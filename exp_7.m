%Experiment 7: Performance Analysis of Optical Amplifiers 
% Pre, In-line and Post Amplifiers using MATLAB 
% ===================================================== 
clear all; close all; clc; 

% ---------- Constants ---------- 
h = 6.626e-34;          % Planck constant (J·s) 
c = 3e8;                % Speed of light (m/s) 
lambda = 1550e-9;       % Signal wavelength (m)
nu = c / lambda;        % Optical frequency (Hz) 
B0 = 12.5e9;            % Optical bandwidth (Hz) ? 0.1 nm 

% ---------- Amplifier Parameters ---------- 
Gss_dB = 25;            % Small-signal gain (dB) 
Gss = 10^(Gss_dB/10);   % Linear gain 
nsp = 1.6;              % Spontaneous emission factor 
NF_dB = 10*log10(2*nsp);% Approximate Noise Figure (dB) 
Psat_dBm = 10;          % Saturation power (dBm) 
Psat = 10^((Psat_dBm-30)/10); % Saturation power (W) 

% ---------- Fiber Parameters ---------- 
alpha = 0.2;            % Fiber attenuation (dB/km) 
L = [40 60 80 100 120 140 160]; % Fiber lengths (km) 

% ===================================================== 
% Part 1: Gain Saturation Curve 
% ===================================================== 
Pin_dBm = -40:1:10; 
Pin = 10.^((Pin_dBm-30)/10);   % Convert to Watt 
G_sat = Gss ./ (1 + Pin/Psat); % Saturated gain (linear) 
G_sat_dB = 10*log10(G_sat); 

figure(1); 
plot(Pin_dBm, G_sat_dB, 'b-', 'LineWidth', 2); 
grid on; xlabel('Input Power (dBm)'); 
ylabel('Gain (dB)'); 
title('Gain Saturation Characteristic'); 
legend('Saturated Gain', 'Location', 'best'); 

% ===================================================== 
% Part 2: Performance of Pre / In-line / Post Amplifiers 
% ===================================================== 
Ptx_dBm = 0;            % Transmitter launch power (dBm) 
Ptx = 10^((Ptx_dBm-30)/10); 

Q_pre = zeros(size(L)); Q_inl = zeros(size(L)); Q_post = zeros(size(L)); 
OSNR_pre = zeros(size(L)); OSNR_inl = zeros(size(L)); OSNR_post = zeros(size(L)); 

for i = 1:length(L) 
    Loss_dB = alpha * L(i); 
    Loss = 10^(-Loss_dB/10); 

    % ----- Pre-Amplifier (placed just before receiver) ----- 
    Pin_pre = Ptx * Loss; 
    G_pre = Gss / (1 + Pin_pre/Psat); 
    PASE_pre = 2*nsp*(G_pre-1)*h*nu*B0; 
    Pout_pre = G_pre * Pin_pre; 
    OSNR_pre(i) = 10*log10(Pout_pre / PASE_pre); 
    Q_pre(i) = sqrt(10^(OSNR_pre(i)/10)/2); 

    % ----- In-line Amplifier (placed at mid-point) ----- 
    L1 = L(i)/2; 
    Loss1 = 10^(-alpha*L1/10); 
    Pin_inl = Ptx * Loss1; 
    G_inl = Gss / (1 + Pin_inl/Psat); 
    PASE_inl = 2*nsp*(G_inl-1)*h*nu*B0; 
    Pmid = G_inl * Pin_inl; 
    Loss2 = Loss1; 
    Pout_inl = Pmid * Loss2; 
    OSNR_inl(i) = 10*log10(Pout_inl / (PASE_inl * Loss2)); 
    Q_inl(i) = sqrt(10^(OSNR_inl(i)/10)/2); 

    % ----- Post-Amplifier (booster after transmitter) ----- 
    Pin_post = Ptx; 
    G_post = Gss / (1 + Pin_post/Psat); 
    PASE_post = 2*nsp*(G_post-1)*h*nu*B0; 
    Plaunch = G_post * Pin_post; 
    Pout_post = Plaunch * Loss; 
    OSNR_post(i) = 10*log10(Pout_post / (PASE_post * Loss)); 
    Q_post(i) = sqrt(10^(OSNR_post(i)/10)/2); 
end 

% ---------- Plot Q-factor vs Length ---------- 
figure(2); 
plot(L, Q_pre, 'g-o', 'LineWidth', 2, 'MarkerSize', 7); hold on; 
plot(L, Q_inl, 'b-s', 'LineWidth', 2, 'MarkerSize', 7); 
plot(L, Q_post, 'r-^', 'LineWidth', 2, 'MarkerSize', 7); 
yline(6, 'k--', 'Q=6 (BER ? 10^{-9})'); 
grid on; xlabel('Fiber Length (km)'); 
ylabel('Q-Factor'); 
title('Q-Factor vs Fiber Length'); 
legend('Pre-Amplifier', 'In-line Amplifier', 'Post-Amplifier', 'Location', 'best'); 

% ---------- Display Results at 100 km ---------- 
idx = find(L==100); 
fprintf('\n===== Results at 100 km =====\n'); 
fprintf('Pre-Amp   : OSNR = %.2f dB,  Q = %.2f\n', OSNR_pre(idx), Q_pre(idx)); 
fprintf('In-line   : OSNR = %.2f dB,  Q = %.2f\n', OSNR_inl(idx), Q_inl(idx)); 
fprintf('Post-Amp  : OSNR = %.2f dB,  Q = %.2f\n', OSNR_post(idx), Q_post(idx)); 

% ---------- Bar comparison at 80 km ---------- 
idx80 = find(L==80); 
figure(3); 
subplot(1,2,1); 
bar([Q_pre(idx80) Q_inl(idx80) Q_post(idx80)]); 
set(gca, 'XTickLabel', {'Pre', 'In-line', 'Post'}); 
ylabel('Q-Factor'); title('Q-Factor at 80 km'); grid on; 

subplot(1,2,2); 
bar([OSNR_pre(idx80) OSNR_inl(idx80) OSNR_post(idx80)]); 
set(gca, 'XTickLabel', {'Pre', 'In-line', 'Post'}); 
ylabel('OSNR (dB)'); title('OSNR at 80 km'); grid on; 

disp('Simulation completed successfully.');