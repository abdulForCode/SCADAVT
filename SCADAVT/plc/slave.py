import modbus_tk
import modbus_tk.modbus_tcp as modbus_tcp
import threading
import modbus_tk.defines as mdef
from ConfigParser import SafeConfigParser
import os
import time 
class Slave():
    def __init__(self,ip,port):
        self.server = modbus_tcp.TcpServer(port,ip,1,None)
        self.slave=self.server.add_slave(1) 
        self.regMap=[];
        self.writeCounter=1;
        self.readCounter=1;
        self.operationState=1;
    def getData(self,block,position,length):
        tempvalue=self.slave.get_values(block, position, length)
        return tempvalue[0];    
    def readFromInputModul(self):
        parser = SafeConfigParser()
        if os.path.exists('IO_modules/outputIsReady.txt'):
            if os.path.exists('IO_modules/output' + (str(int(self.readCounter))+'.ini').strip(' ')):
                parser.read('IO_modules/output' + (str(int(self.readCounter))+'.ini').strip(' '));
                for section in parser.sections():
                    for reg in  self.regMap:
                        if reg[0]==section and reg[3]=='i':
                            block=reg[1];  
                            position=reg[2]; 
                            value =float(parser.get(section, 'value')); 
                            self.slave.set_values(block, position, value)
                self.readCounter+=1;
                self.operationState=2;
                os.remove('IO_modules/outputIsReady.txt');                
    def writeToOutputModul(self): 
        parser = SafeConfigParser()
        file=open('IO_modules/input' + str(int(self.writeCounter))+'.ini','w')
        parser.read('IO_modules/input'+ (str(int(self.writeCounter))+'.ini').strip(' '));  
        for reg in  self.regMap:
            if reg[3]=='o':
                tempvalue= self.getData(reg[1], reg[2], 1);
                parser.add_section(reg[0])
                parser.set(reg[0],'Value',str(tempvalue))
        parser.write(file);
        file.close();  
        file=open('IO_modules/inputIsReady.txt','w');
        file.write("ready");
        file.close()  
        self.writeCounter+=1;
        self.operationState=1;  
    def PLCConfiguration(self):           
        logger = modbus_tk.utils.create_logger(name="console", record_format="%(message)s")
        #add blocks of  registers
        self.slave.add_block("H", mdef.HOLDING_REGISTERS, 0, 100)    #address 0, length 100
        self.slave.add_block("C", mdef.COILS, 0, 100)                     #address 0, length 100
        self.slave.add_block("D", mdef.DISCRETE_INPUTS, 0, 100)       #address 0, length 100
        self.slave.add_block("A", mdef.ANALOG_INPUTS, 0, 100)         #address 0, length 100
    def start(self,pollRate=0.5):
        self.RegMap_Config();
        self.PLCConfiguration();
        self.server.start()
        print "Slave is running..."
        counter=0;
        while(counter<500000):
            if self.operationState==1:    
                #To read data from sensors and actutors"
                self.readFromInputModul();
                self.procedureControl(); # This procedure uses  input information to make decisions
            elif self.operationState==2:
                #To write data onto sensors and actutors"
                self.writeToOutputModul();    
            time.sleep(pollRate)
            counter+=1;
            # To remove old measurement data
            if os.path.exists('IO_modules/output' + (str(int(self.readCounter-4))+'.ini').strip(' ')):
                os.remove('IO_modules/output' + (str(int(self.readCounter-4))+'.ini').strip(' '));  
            if os.path.exists('IO_modules/input' + (str(int(self.writeCounter-4))+'.ini').strip(' ')):
                os.remove('IO_modules/input' + (str(int(self.writeCounter-4))+'.ini').strip(' '));  
#+++++++++++++++++++++++++++++++++++++++++++++++++++
#+++++++++++++++++++++++++++++++++++++++++++++++++++
    def procedureControl(self):
        #self.slave.set_values("D", 3, self.getData('C',0,1));
        #self.slave.set_values("D", 4, self.getData('C',2,1));
        #self.slave.set_values("D", 5, self.getData('C',3,1));
        # control code will be written here    
        t=0;
        # To load registers configuration of PLC
    def RegMap_Config(self):
        reg1=['process1','D',0,'i'];
        #reg2=['process2','D',1,'i'];
        #reg3=['process3','D',2,'i'];
        #reg4=['process4','D',3,'o'];
        #reg5=['process5','D',4,'o'];
        #reg6=['process6','D',5,'o'];  
        #self.regMap=[reg1,reg2,reg3,reg4,reg5,reg6];     
if __name__ == '__main__':
    s= Slave('192.168.16.133',502);
    s.start(0.01)