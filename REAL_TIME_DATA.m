% Example: MATLAB Script to Analyze Real-Time Data from Arduino

% Define the serial port and baud rate (update the COM port as per your system)
serialPort = 'COM3'; % Replace with your Arduino's COM port

% Initialize serial connection using serialport instead of serial
try
    arduino = serialport(serialPort, 9600);  % Open serial port with baud rate
catch
    disp('Error opening serial port. Please check the port and try again.');
    return;
end

% Prepare storage variables
time = [];
position = [];

% Set duration for data collection (in seconds)
collectionDuration = 30; % Adjust as needed
startTime = datetime('now');

% Collect data
disp('Collecting data...');
while seconds(datetime('now') - startTime) < collectionDuration
    try
        % Read a line from the serial port
        dataLine = readline(arduino);
        disp(['Raw data: ', dataLine]); % Debug: Display raw serial data

        % Parse the line for time and distance
        tokens = regexp(dataLine, 'Time: (\d+\.\d+) s, Distance: (\d+)', 'tokens');
        
        if ~isempty(tokens)
            % Extract and store time and distance
            parsedTime = str2double(tokens{1}{1});
            parsedDistance = str2double(tokens{1}{2});
            
            % Append to arrays
            time(end+1) = parsedTime; %#ok<SAGROW>
            position(end+1) = parsedDistance; %#ok<SAGROW>
        else
            disp('Data did not match the expected format.'); % Debug
        end
    catch
        disp('Error reading data. Skipping this iteration.'); % Debug
    end
end

% Close the serial connection
clear arduino;

% Check if data was collected
if isempty(position)
    disp('No data collected. Ensure the Arduino is sending data correctly.');
    return;
end

% Apply smoothing using moving average
windowSize = 5; % Adjust for smoother data
smoothPosition = movmean(position, windowSize);

% Plot the real-time data (step response)
figure;
plot(time, smoothPosition, '-o');
xlabel('Time (s)');
ylabel('Ball Position (cm)');
title('Ball Position vs Time (Step Response)');
grid on;

% Perform the analysis on the step response
steadyStateValue = smoothPosition(end);
overshoot = max(smoothPosition) - steadyStateValue;
tolerance = 0.02 * steadyStateValue;

% Ensure we find the settling time index safely
settlingTimeIndex = find(abs(smoothPosition - steadyStateValue) <= tolerance, 1, 'first');
if isempty(settlingTimeIndex)
    settlingTime = NaN; % No settling time found
else
    settlingTime = time(settlingTimeIndex);
end

desiredSetpoint = 15;  % Replace with your setpoint (e.g., 15 cm)
steadyStateError = abs(desiredSetpoint - steadyStateValue);

% Display analysis results
disp('Step Response Analysis:');
disp(['Overshoot: ', num2str(overshoot), ' cm']);
disp(['Settling Time: ', num2str(settlingTime), ' seconds']);
disp(['Steady-State Error: ', num2str(steadyStateError), ' cm']);
