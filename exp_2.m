 clear; clc; close all;

P_in = 1.0;
wavelength = 1550;
N_turns = 5;
bend_radii = linspace(5, 30, 50);
R_reference = 12.0;
R_sensitive = 5;

bending_loss_dB = 1.5 * N_turns * exp(-(bend_radii - R_reference) / R_sensitive) .* (bend_radii <= 25);

bending_loss_dB(bend_radii > 25) = 0.05;

rng(20);

P_out_theoretical = P_in * 10.^(-bending_loss_dB / 10);

noise = 0.01 * randn(size(bend_radii));

P_measured = max(0, P_out_theoretical + noise);

calculated_loss_dB = 10 * log10(P_in ./ P_measured);

fprintf('-----------------------------------------------------\n');
fprintf('        OPTICAL FIBER BENDING LOSS ANALYSIS\n');
fprintf('-----------------------------------------------------\n');

fprintf('Operating Wavelength : %d nm\n', wavelength);
fprintf('Number of Turns (N) : %d\n', N_turns);
fprintf('Reference Radius     : %.1f mm\n', R_reference);
fprintf('Sensitive Radius     : %.1f mm\n\n', R_sensitive);

figure('Name', 'Optical Fiber Bending Loss Analysis', ...
       'Color', 'white', 'Position', [100, 100, 950, 450]);

subplot(1, 2, 1);

plot(bend_radii, bending_loss_dB, 'b-', 'LineWidth', 2);
hold on;

plot(bend_radii, calculated_loss_dB, 'ro', 'MarkerSize', 4);

grid on;

xlabel('Bend Radius (mm)');
ylabel('Bending Loss (dB)');
title('Bending Loss vs. Bend Radius');

legend('Theoretical Loss', 'Simulated Data', ...
       'Location', 'northeast');

subplot(1, 2, 2);

plot(bend_radii, P_measured, 'g-', 'LineWidth', 2);

grid on;

xlabel('Bend Radius (mm)');
ylabel('Output Optical Power (mW)');
title('Received Power vs. Bend Radius');

legend('Output Power', 'Location', 'southeast');