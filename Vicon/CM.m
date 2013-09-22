function [] = CM(serialPort,carID,speed,turn)
% Pass speed (-127,127) and turn (-30 to 300) to serial object 'serialPort'
idList = [49 50 51 52];
fwrite(serialPort,idList(carID),'int8');       % 49 is PW to start AVR
fwrite(serialPort,speed,'int8');
fwrite(serialPort,turn,'int8');