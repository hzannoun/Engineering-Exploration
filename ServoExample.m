%{
FoodLineMonitoringWithServo - Week 7 Day 2 Experiment
Authors:    Neil Moore and Julie Whitney
Assignment: EGR 102 Week 7 Example
History:    07 October 2017 - Initial version.
Purpose:
  Provide template for beginning the assignment
Notes:  
   Completes the Food Line Monitoring Assignment  
%}
noCan=4; 

Connect_Arduino('a'); % Connect to the Arduino

% This controls the micro-servo (0 to 180 degrees rotation)
Connect_Servo('s1','a','D9'); 

count =0; % this variable will be used as an ACCUMULATOR to count the cans

% start with Gate down
writePosition(s1,0.5);
%*******************************************************************
%*******************************************************************
%
%      This command asks if the sensor is blocked (can present)

canState = readVoltage(a,'A0');
% *****************************************************************
%******************************************************************
%
%   Add this command 2 places in the code below to make this 
%   program function correctly
%
%*******************************************************************
%*******************************************************************

while 1==1  %to run continuously
    while canState >= noCan %continually run
       % no can in the way, gate stays down
       writePosition(s1, 0.5);
       pause(1); % wait a second
       canState = readVoltage(a,'A0');
    end %end while loop 
    count = count+1;
    while canState < noCan %sensor is blocked
        writePosition(s1, 1); % raise the gate
        % wait for the can to move out of the way
        pause (3);
        canState = readVoltage(a,'A0');
    end
    writePosition(s1, 0.5);
    disp(count);
end


