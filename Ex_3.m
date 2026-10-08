clc;
clear;
close all;

% Refractive indices
n1 = 1.48;
n2 = 1.46;

% Theoretical Numerical Aperture
NA_th = sqrt(n1^2 - n2^2);

% Theoretical Acceptance Angle
theta_a_rad = asin(NA_th);
theta_a_deg = theta_a_rad * 180 / pi;

% Display theoretical results
fprintf('Theoretical NA = %.4f\n', NA_th);
fprintf('Acceptance Angle (deg) = %.2f\n', theta_a_deg);

% Screen distances in mm
L = [10 15 20 25 30];

N = length(L);

% Initialize arrays
r = zeros(1, N);
NA_exp = zeros(1, N);
theta_exp = zeros(1, N);

% Set random seed
rng(1);

% Experimental calculation
for i = 1:N

    % Ideal spot radius
    r_ideal = L(i) * tan(theta_a_rad);

    % Add small measurement noise
    noise = 1 + 0.02 * (2 * rand - 1);

    % Experimental radius
    r(i) = r_ideal * noise;

    % Experimental Numerical Aperture
    NA_exp(i) = r(i) / sqrt(r(i)^2 + L(i)^2);

    % Experimental Acceptance Angle
    theta_exp(i) = asin(NA_exp(i)) * 180 / pi;

end

% Display observation table
fprintf('\n----- Observation Table -----\n');

fprintf('L(mm)\t r(mm)\t NA_exp\t theta(deg)\n');

for i = 1:N

    fprintf('%5.1f\t%6.2f\t%6.4f\t%8.2f\n', ...
        L(i), r(i), NA_exp(i), theta_exp(i));

end

% Average experimental NA
NA_avg = mean(NA_exp);

% Percentage error
percentage_error = abs(NA_avg - NA_th) / NA_th * 100;

% Display final results
fprintf('\nAverage Experimental NA = %.4f\n', NA_avg);

fprintf('Percentage Error = %.2f%%\n', percentage_error);

% Plot Experimental NA
figure;

plot(L, NA_exp, 'bo-', ...
    'LineWidth', 1.5, ...
    'MarkerSize', 8);

hold on;

% Plot theoretical NA
yline(NA_th, 'r--', ...
    'LineWidth', 1.5);

% Graph labels
xlabel('Distance L (mm)');
ylabel('Numerical Aperture');

title('Simulated NA vs Screen Distance');

legend('Experimental NA', ...
       'Theoretical NA', ...
       'Location', 'best');

grid on;  