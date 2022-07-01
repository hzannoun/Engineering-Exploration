clear
clc
photo_pin = 'A0';            % The pin wired to the photoresistor voltage divider.
LED_pins = ['D5';'D6';'D7']; % A semicolon-separated list of pin numbers.
tests_per_LED = 10;          % Number of samples per test per LED.
test_sessions = 3;           % Number of sweeps across all LEDs.
sample_delay = 0.1;          % Delay between each voltage sample. 
%%%%%%%%%%%%%%%%%%%%%%%
a = arduino('com3','uno');
s1=servo('a', 'D9', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
s2=servo('a', 'D10', 'MinPulseDuration', 700*10-6, 'MaxPulseDuration', 2300*10^-6);
% Configure all pins in LED_pins to be DigitalOutput.
while 1==1
for i=1:length(LED_pins)
    a.configurePin(LED_pins(i,:),'DigitalOutput');
end
% Configure photo_pin to be AnalogInput.
a.configurePin(photo_pin,'AnalogInput');

% For all testing sweeps
for test = 1:test_sessions
    % For all LEDs
    AveValue1 = 0;
    for LED_number = 1:length(LED_pins)
        % Clear value accumulator
        % Array holding voltage samples for one LED [used strictly for debugging].
        voltage_samples = zeros(1,tests_per_LED);
        AllValues = 0;
        % Set LEDs off, except for the one in use;
        for i = 1:length(LED_pins)
            if i == LED_number
                a.writeDigitalPin(LED_pins(i,:),1);
            else
                a.writeDigitalPin(LED_pins(i,:),0);
            end
        end
        
       for index = 1:tests_per_LED % Run tests_per_LED times
           voltage_samples(index) = a.readVoltage(photo_pin); % From arduino
           AllValues = voltage_samples(index)+ AllValues; %adds all values for test
           pause(.33); %slows down read speed
           % Plots the values sampled [disabled for performance reasons]
           plot(voltage_samples); %plots values 
           ylim([-1 6]); %set y limits of plot
           ylabel('Voltage'); %label Y axis
       end %end for loop
       AveValue = AllValues/tests_per_LED; %sets the average from the test
       AveValue1 = AveValue1 + AveValue;
       % Displays test data gathered.
       fprintf ('Test %d, LED pin %s: %.4f V\n', test, LED_pins(LED_number,:), AveValue);
    end
    AveValue1 = AveValue1 / 3;
    fprintf ('Test %d, Average: %.4f V\n', test, AveValue1);
    pause(5);
end %end while loop 
writePosition(s1, 1);
% Set all digital pins in the list to 0 volts
% [Turns all LEDs off.]
if AveValue > 3.4
    writePosition(s2,.25)
    disp('Aluminum')
elseif AveValue < 3.1
    if AveValue > 2.1
        writePosition(s2,.5)
        disp('Wood')
    else 
        writePosition(s2,.75)
        disp('Fabric')
    end
end
writePosition(s1, 0);
end
