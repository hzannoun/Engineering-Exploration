clc
clear
photo_pin = 'A0';            
LED_pins = ['D5';'D6';'D7']; 
tests_per_LED = 10;          
test_sessions = 3;           
sample_delay = 0.1;           

a = arduino('com6','uno');
b = arduino('com7','uno');
s1 = servo(a, 'D9');
s2 = servo(b, 'D10');


while 1==1
    writePosition(s2, 1);
    pause(.33);
    writePosition(s2, 0);
end

for i=1:length(LED_pins)
    a.configurePin(LED_pins(i,:),'DigitalOutput');
end

a.configurePin(photo_pin,'AnalogInput');
loop = 1;
while loop == 1
    AveValue1 = 0;
    redAvg = 0;
    blueAvg = 0;
    greenAvg = 0;
    for LED_number = 1:length(LED_pins)
        voltage_samples = zeros(1,tests_per_LED);
        AllValues = 0;
       
        for i = 1:length(LED_pins)
            if i == LED_number
                a.writeDigitalPin(LED_pins(i,:),1);
            else
                a.writeDigitalPin(LED_pins(i,:),0);
            end
        end
        
       for index = 1:tests_per_LED 
           voltage_samples(index) = a.readVoltage(photo_pin); 
           AllValues = voltage_samples(index) + AllValues;
           pause(.33);
           plot(voltage_samples); 
           ylim([-1 6]); 
           ylabel('Voltage'); 
           if LED_number ==1
               blueAvg = AllValues;
               blueAvg = blueAvg/tests_per_LED;
           elseif LED_number ==2
              greenAvg = AllValues;
              greenAvg = greenAvg/tests_per_LED;
           else
               redAvg = AllValues;
               redAvg = redAvg/tests_per_LED;
           end 
       end
       AveValue = AllValues/tests_per_LED; 
       AveValue1 = AveValue1 + AveValue;
       fprintf ('Test, LED pin %s: %.4f V\n', LED_pins(LED_number,:), AveValue);
    end
    AveValue1 = AveValue1 / 3;
    fprintf ('Test, Average: %.4f V\n', AveValue1);

  
if AveValue > 2.75
    loop = 1;
    disp('Test Complete')
else
    if AveValue1 >1.5
        if redAvg > 1.75
            disp('Wood')
            writePosition(s1, 0)
        else
            disp('Paper')
            writePosition(s1, 0.25)
        end
    else
        if greenAvg > 2.0 
            disp('Metal')
            writePosition(s1, 0.5)
        else
            if greenAvg > 1.75 && greenAvg < 2.0
                disp('Carbon Fiber')
                writePosition(s1, 0.75)
            else
                disp('Fabric')
                writePosition(s1, 1)
            end
        end
    end
end
end
