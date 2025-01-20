% Sample data (this should be in a CSV file for real use)
time = [0.00, 1.70, 2.94, 4.18, 5.41, 6.65, 7.89, 9.12, 10.36, 11.60, ...
        12.83, 14.07, 15.31, 16.54, 17.78, 19.02, 20.26, 21.50, 22.73];
distance = [40.00, 40.00, 40.00, 40.00, 28.95, 28.70, 28.68, 28.97, 29.15, ...
            29.17, 29.17, 29.17, 29.10, 29.00, 29.22, 29.22, 29.22, 28.99, 29.21];

% Plot the data
figure;
plot(time, distance, '-o', 'LineWidth', 2);  % Plot with circle markers
xlabel('Time (s)');       % Label x-axis
ylabel('Distance (cm)');  % Label y-axis
title('Step Response of the Ball and Beam System');
grid on;                 % Enable grid for better visualization

% --- Analyzing the Open-Loop Response ---
% 1. Rise Time
% Find the index of the time when the response reaches 10% and 90% of its final value
final_value = distance(end);          % Steady-state value (SSV)
ten_percent = final_value * 0.1;
ninety_percent = final_value * 0.9;

% Find the indices where the response crosses these values
rise_time_start_idx = find(distance >= ten_percent, 1);
rise_time_end_idx = find(distance >= ninety_percent, 1);

rise_time = time(rise_time_end_idx) - time(rise_time_start_idx);  % Rise time

% 2. Settling Time
% Find when the response settles within a certain percentage of the final value (e.g., within 2%)
settling_threshold = final_value * 0.02;
settling_time_idx = find(abs(distance - final_value) <= settling_threshold, 1, 'last');
settling_time = time(settling_time_idx);  % Settling time

% 3. Overshoot
% Calculate the peak value and overshoot percentage
peak_value = max(distance);  % Peak value
overshoot = (peak_value - final_value) / final_value * 100;  % Overshoot in percentage

% 4. Steady-State Value (SSV)
% This is simply the last value of the response, already defined as final_value

% Display results
fprintf('Rise Time: %.2f s\n', rise_time);
fprintf('Settling Time: %.2f s\n', settling_time);
fprintf('Overshoot: %.2f %%\n', overshoot);
fprintf('Steady-State Value (SSV): %.2f cm\n', final_value);
