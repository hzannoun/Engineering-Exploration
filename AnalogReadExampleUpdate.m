%{
AnalogReadExample - Demonstrates how to run the Arduino in Matlab
Authors:    Penn, Moore, Klein, and  Letellier
Assignment: Applicable to EGR 103 Assignments
History:    February 9, 2017 - Initial version.
            August 20, 2017 - Added additional commentary
            September 22, 2017 Updated to use Connect_Arduino function
            September 27, 2017 rolled-back to prior connection method
            January 14, 2018 - Updated to use Connect_Arduino
Purpose:
  Demonstrates how read an analog signal from an Arduino
  and display visually as a graph in Matlab.

Notes:
  Every MATLAB file submitted in EGR 102 should start with a header
  comment following this outline.  The "History" and "Notes" sections
  are optional, unless otherwise specified.
%}

% This function is courtesy Mr. Penn and Dr. Moore. It connects 
% the Arduino if not already connected and eliminates the need  
% to use the command line to do this.%}
% It will make sure the Arduino at the port specified above is
% connected. This code will not be on the test.
%%%%%% SETTINGS %%%%%%%
photo_pin = 'A0';            % The pin wired to the photoresistor voltage divider.
LED_pins = ['D5';'D6';'D7']; % A semicolon-separated list of pin numbers.
tests_per_LED = 10;          % Number of samples per test per LED.
test_sessions = 3;           % Number of sweeps across all LEDs.
sample_delay = 0.1;          % Delay between each voltage sample. 
%%%%%%%%%%%%%%%%%%%%%%%
Connect_Arduino('a');
% Configure all pins in LED_pins to be DigitalOutput.
for i=1:length(LED_pins)
    a.configurePin(LED_pins(i,:),'DigitalOutput');
end
% Configure photo_pin to be AnalogInput.
a.configurePin(photo_pin,'AnalogInput');

% For all testing sweeps
for test = 1:test_sessions
    % For all LEDs
    for LED_number = 1:length(LED_pins)
        % Clear value accumulator
        % Array holding voltage samples for one LED [used strictly for debugging].
        voltage_samples = zeros(1,tests_per_LED);
        AllValues = 0;
        % Set LEDs off, except for the one in use.
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
           pause(sample_delay); %slows down read speed
           % Plots the values sampled [disabled for performance reasons]
           % plot (analog); %plots values 
           % ylim([-1 6]); %set y limits of plot
           % ylabel('Voltage'); %label Y axis
       end %end for loop
       AveValue = AllValues/tests_per_LED; %sets the average from the test
       % Displays test data gathered.
       fprintf ('Test %d, LED pin %s: %.4f V\n', test, LED_pins(LED_number,:), AveValue);
    end
end %end while loop 

% Set all digital pins in the list to 0 volts
% [Turns all LEDs off.]
for i = 1:length(LED_pins)
    a.writeDigitalPin(LED_pins(i,:),0);
end
disp('Tests Complete!');
