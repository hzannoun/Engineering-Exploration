clear
clc
photo_pin = 'A0';            % The pin wired to the photoresistor voltage divider.
LED_pins = ['D5';'D6';'D7']; % A semicolon-separated list of pin numbers.
tests_per_LED = 10;          % Number of samples per test per LED.
test_sessions = 3;           % Number of sweeps across all LEDs.
sample_delay = 0.1;          % Delay between each voltage sample. 
%%%%%%%%%%%%%%%%%%%%%%%
Connect_Arduino('a');
s = servo(a, 'D4');
s1 = servo(a, 'D9');
% Configure all pins in LED_pins to be DigitalOutput.
for i=1:length(LED_pins)
    a.configurePin(LED_pins(i,:),'DigitalOutput');
end
% Configure photo_pin to be AnalogInput.
a.configurePin(photo_pin,'AnalogInput');
loop = 1;
% For all testing sweeps
while loop == 1
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
       %fprintf ('Test %d, LED pin %s: %.4f V\n', test, LED_pins(LED_number,:), AveValue);
    end
    AveValue1 = AveValue1 / 3;
    %fprintf ('Test %d, Average: %.4f V\n', test, AveValue1);
    
if AveValue1 <= 0.28
    disp('Fabric');
    writePosition(s1, 0);
elseif AveValue1 > 0.28
    if AveValue1 <= 0.32
        disp('Metal');
        writePosition(s1, .2);
    elseif AveValue1 > 0.32 && AveValue1 <= 0.8
        disp('Carbon Fiber');
        writePosition(s1, .4);
    elseif AveValue1 > 0.8 && AveValue1 <= 1.2
        disp('Paper');
        writePosition(s1, .6);
    elseif AveValue1 > 1.2 && AveValue1 <= 1.4
        disp('Wood');
        writePosition(s1, .8);
    elseif AveValue1 > 2 && AveValue1 <2.5
        disp('Metal')
        writePosition(s1, 1);
    elseif AveValue1 >= 3.0
        loop = 0;
        disp('Tests Complete!');
    end
end
end %end while loop 

% Set all digital pins in the list to 0 volts
% [Turns all LEDs off.]
