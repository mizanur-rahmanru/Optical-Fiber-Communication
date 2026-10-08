% Experiment 4: Design & Simulation of a Low-Loss Optical Fiber Coupler

clear; clc; close all;

% ---- Design / Simulation Parameters ----
P0     = 1.0;          % input power (mW)
kappa  = 150;          % coupling coefficient (1/m)
Lmax   = 0.030;        % maximum interaction length (m) = 30 mm
Npts   = 500;          % number of points along z
z = linspace(0, Lmax, Npts);   % distance vector (m)

% ---- Coupled-mode power transfer (ideal lossless) ----
P1 = P0 * cos(kappa * z).^2;   % power remaining in fiber 1
P2 = P0 * sin(kappa * z).^2;   % power transferred to fiber 2

% ---- Find 50:50 coupling length ----
[~, idx50] = min(abs(P1 - P2));
L50 = z(idx50);
P1_50 = P1(idx50);
P2_50 = P2(idx50);

% ---- Loss calculations at 50:50 point ----
IL1 = -10*log10(P1_50 / P0);
IL2 = -10*log10(P2_50 / P0);
EL  = -10*log10((P1_50 + P2_50)/P0);

% ---- Display results ----
fprintf('=== Low-Loss Optical Fiber Coupler Design ===\n');
fprintf('Coupling coefficient kappa = %.1f m^-1\n', kappa);
fprintf('50:50 coupling length L50  = %.2f mm\n', L50*1000);
fprintf('Power at L50: P1 = %.4f mW,  P2 = %.4f mW\n', P1_50, P2_50);
fprintf('Insertion Loss IL1 = %.2f dB,  IL2 = %.2f dB\n', IL1, IL2);
fprintf('Excess Loss EL     = %.3f dB\n\n', EL);

% ---- Observation table (selected points) ----
fprintf('Observation Table (selected lengths):\n');
fprintf(' Length(mm) |   P1(mW)  |   P2(mW)  | CR(%%) | IL(dB) \n'); % Added table headers for clarity
sel = round(linspace(1, Npts, 8));
for i = sel
    CR = 100 * P2(i) / (P1(i)+P2(i));
    IL = -10*log10(P1(i)/P0);
    fprintf('%8.2f    | %8.4f   | %8.4f   | %6.1f | %7.2f\n', ...
            z(i)*1000, P1(i), P2(i), CR, IL);
end

% ---- Graph 1: Power evolution vs length ----
figure(1);
plot(z*1000, P1, 'b-', 'LineWidth', 2);
hold on;
plot(z*1000, P2, 'r-', 'LineWidth', 2);
plot(L50*1000, P1_50, 'ko', 'MarkerSize', 20, 'MarkerFaceColor', 'g');
grid on;
xlabel('Interaction Length z (mm)');
ylabel('Optical Power (mW)');
title('Power Transfer in a Directional Fiber Coupler');
legend('P_1 (through)', 'P_2 (coupled)', '50:50 point');

% ---- Graph 2: Coupling Ratio vs length ----
CR_all = 100 * P2 ./ (P1 + P2);
figure(2);
plot(z*1000, CR_all, 'm-', 'LineWidth', 2);
hold on;
grid on;
xlabel('Interaction Length z (mm)');
ylabel('Coupling Ratio (%)');
title('Coupling Ratio versus Length');

% ---- Graph 3: Insertion Loss of both ports ----
figure(3);
plot(z*1000, -10*log10(P1/P0), 'b-', 'LineWidth', 2);
hold on;
plot(z*1000, -10*log10(P2/P0), 'r-', 'LineWidth', 2);
grid on;
xlabel('Interaction Length z (mm)');
ylabel('Insertion Loss (dB)');
title('Insertion Loss of the Two Output Ports');
legend('IL_1', 'IL_2');