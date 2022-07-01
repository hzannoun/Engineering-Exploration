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

Connect_Arduino('a');

% Configure digital pin 5 as an output and set to 5 volts
configurePin(a,'D5','DigitalOutput');
writeDigitalPin(a,'D5', 1); 

analog = zeros(1,100); %holds voltage reads
test = 0; %sets initial test number

while 10 >= test % Run for 10 tests
   test =test +1; %defines test number    
   AllValues = 0; % set initial average of this test to 0
   
    for index = 1:100 %run values 2 through 99
       analog(index) = readVoltage(a,'A0'); %read from arduino
       AllValues = analog(index)+ AllValues; %adds all values for test
       pause (.1); %slows down read speed
       plot (analog); %plots values 
       ylim([-1 6]); %set y limits of plot
       ylabel('Voltage'); %label Y axis
    end %end for loop

   AveValue = AllValues/100; %sets the average from the test
   fprintf ('test %d = %.4f \n', test, AveValue) %prints values
   
end %end while loop 

% Set digital pin 5 to 0 volts
writeDigitalPin(a,'D5', 0); 
disp('Test Ended');
