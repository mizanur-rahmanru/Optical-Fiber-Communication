clear; clc; close all;
P_in = 1.0;                  
wavelength = 1550;              
alpha_coefficient = 0.22;       
fiber_lengths = linspace(0,100,200); 
P_out_theoretical = P_in .* 10.^(-(alpha_coefficient .* fiber_lengths)./10);

rng(10);                      
noise = 0.015*randn(size(fiber_lengths));
P_measured = P_out_theoretical + noise;
P_measured(P_measured<=0) = 1e-6;

calculated_loss = 10*log10(P_in./P_measured);
calculated_alpha = NaN(size(fiber_lengths));
idx = fiber_lengths>0;
calculated_alpha(idx) = calculated_loss(idx)./fiber_lengths(idx);
mean_alpha = mean(calculated_alpha(fiber_lengths>=10),'omitnan');

fprintf('\n');
fprintf('=====================================================\n');
fprintf('     OPTICAL FIBER ATTENUATION MEASUREMENT\n');
fprintf('=====================================================\n');
fprintf('Operating Wavelength : %d nm\n',wavelength);
fprintf('Input Optical Power  : %.2f mW\n',P_in);
fprintf('Assumed Alpha        : %.2f dB/km\n',alpha_coefficient);
fprintf('Measured Mean Alpha  : %.3f dB/km\n',mean_alpha);
fprintf('=====================================================\n');

figure('Color','w','Position',[100 100 1000 450],'Name','Optical Fiber Attenuation Analysis');

subplot(1,2,1)
plot(fiber_lengths, alpha_coefficient*fiber_lengths, 'b', 'LineWidth',2)
hold on
plot(fiber_lengths, calculated_loss, 'ro', 'MarkerFaceColor','r', 'MarkerSize',2)
grid on; box on;
xlabel('Fiber Length (km)', 'FontSize',11)
ylabel('Attenuation Loss (dB)', 'FontSize',11)
title('Loss versus Fiber Length', 'FontWeight','bold')
legend('Theoretical Loss', 'Measured Loss', 'Location','northwest')

subplot(1,2,2)
semilogy(fiber_lengths, P_out_theoretical, 'b', 'LineWidth',2)
hold on
semilogy(fiber_lengths, P_measured, 'r.', 'MarkerSize',12)
grid on; box on;
xlabel('Fiber Length (km)', 'FontSize',11)
ylabel('Output Optical Power (mW)', 'FontSize',11)
title('Optical Power Decay', 'FontWeight','bold')
legend('Theoretical Power', 'Measured Power', 'Location','northeast')

