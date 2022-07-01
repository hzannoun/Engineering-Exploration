Connect_Arduino()
%a = arduino('com3','uno') %only needed if arduino not connected
analog = zeros(1,5); %holds voltage reads
test = 0; %sets initial test number
for test=1:10 %NESTED for loop - a loop within a loop  
   % for each data point taken we want to use a set of 5 samples
   
   for index = 1:5 %run values 1 to 5
       analog(index) = readVoltage(a,'A0'); %read from arduino
       pause (.1); %slows down read speed
   end %end inside loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%  This section loads values into an array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Highest=max(analog);
        lowest=min(analog);
        AveValue=mean(analog); %sets the average from the test
        data(test,1)=Highest;
        data(test,2)=lowest;
        data(test,3)=AveValue;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   count=10-test;  % this is to give you a count down on your screen
   disp(count);
end %end outside loop 