clear
clc
Connect_Arduino('a')
s = servo(a, 'D10');
while 1==1
    writePosition(s, 0)
    pause(3)
    writePosition(s, 1)
end