clc;
clear all;
close all;
w=5.0;
lambda=1.55;
n=1.45;
N=200;
% ---------------1.Lateral Misalignment------------------
dx=linspace(0,10,N);
eta_lat=exp(-(dx/w).^2);
loss_lat=-10*log10(eta_lat);
figure(1);
plot(dx,loss_lat,'b--','LineWidth',2);
xlabel('Lateral Offset');
ylabel('Coupling loss(dB)');
title('Coupling loss vs Lateral Misallignment');
grid on;
xlim([0 10]);

%----------angular misallignment----------
dth_deg=linspace(0,5,N);
dth_rad=dth_deg*pi/180;
eta_ang=exp(-(pi*dth_rad*w*n/lambda).^2);
Loss_ang=-10*log10(max(eta_ang,1e-12));

figure(2);
plot(dth_deg,Loss_ang,'r--', 'LineWidth',2);
xlabel('Angular Misallignment\Delta\theta(degree)');
ylabel('Coupling loss');
title('Coupling loss vs angular misallignment');
grid on; xlim([0 5]);


%----------Longitudinal misallignment----------
z=linspace(0,50,N);
eta_long=1./(1+(z*lambda./(2*pi*n*w^2)).^2);
Loss_long=-10*log10(max(eta_long,1e-12));

figure(3);
plot(z,Loss_long,'g-','LineWidth',2);
xlabel('Longitudinal separation z(\mum)');
ylabel('Coupling loss (dB)');
title('Coupling loss vs longitudinal separation');
grid on; xlim([0 50]);

figure(4);
hold on;
plot(dx,loss_lat,'b-','LineWidth',2.5,'DisplayName','Lateral(\Delta x in \mum)');
plot(dth_deg*2,Loss_ang,'r--','LineWidth',2.5,'DisplayName','Angular(\Delta\theta in \times 2)');
plot(z/5,Loss_long,'g-.','LineWidth',2.5,'DisplayName','Longitudinal(z in \mum/5)');
xlabel('scaled misallignment parameter');
ylabel('Coupling Loss(dB)');
title('Comperison of coupling losses due to Different Misallignments');
legend('Location','northwest');
grid on;
xlim([0 10]);
ylim([0 15]);
hold off;
