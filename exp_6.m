clc;
clear all;
close all;
p0=1.0;
alpha=0.5;
EL_dB=0.2;
EL_lin=10^(-EL_dB/10);
p2=alpha*p0*EL_lin;
p3=(1-alpha)*p0*EL_lin;

fprintf('Input power p0      =%.3f\n',p0);
fprintf('Splitting Ratio alpha    =%.3f\n',alpha);
fprintf('Excess Loss     =%.2f dB\n',EL_dB);
fprintf('Upper arm power p2   =%.4f\n',p2);
fprintf('Lower arm Power p3   =%.4f\n',p3);
fprintf('Total Output Power  =%.4f\n', p2+p3);

a=linspace(0,1,300);
p2_var=a*p0*EL_lin;
p3_var=(1-a)*p0*EL_lin;

figure(1);
plot(a,p2_var,'b-','LineWidth',2); hold on;
plot(a,p3_var,'r-','LineWidth',2);
xlabel('Power splitting ration alpha');
ylabel('Normalized Optical power');
title('Power splitting in Optical Y coupler');
legend('Upper Arm p2', 'Lower Arm p3');
grid on;
y_limits = ylim;
 plot([0.5, 0.5], y_limits, '--g', 'LineWidth', 1.5);
 text(0.51, mean(y_limits), '3-dB point', 'Color', [0 0.5 0]);

theta=linspace(1,15,200);
EL_theta=0.05+0.015*theta.^1.3;
figure(2);
plot(theta,EL_theta,'m-','LineWidth',2);
xlabel('Branching Half-Angle(degree)');
title('Excess Loss vs Branching Angle(degree)');
ylabel('Excess loss(dB)');
grid on;
