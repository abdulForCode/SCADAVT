import modbus_tk
import modbus_tk.modbus_tcp as modbus_tcp
import threading
import modbus_tk.defines as mdef
from ConfigParser import SafeConfigParser
import os
import time 
class HMIServer():
    def __init__(self,pullRate=0.5):
        self.pullRate=pullRate;
        self.server1 = modbus_tcp.TcpServer(506,'172.16.0.254',1,None)
        self.slave1 = self.server1.add_slave(1)  
        self.server2 = modbus_tcp.TcpServer(502,'192.168.16.132',1,None)
        self.slave2 = self.server2.add_slave(1)          
    def dumpData(self,counter):
        tempvalue=self.slave1.get_values('c', 0, 5);
        [p1,p2,p3,p4,p5]=tempvalue;
        tempvalue=self.slave1.get_values('h', 0, 4)
        [t1,t2,t3,v1]=tempvalue;
        st=str([counter,p1, p2, p3, t1, p4, p5, t2 , v1,t3]);
        st=st.strip('[');
        st=st.strip(']');
        return st ;
    #--------------------------------------------------------------------------------
    def start(self):
        logge1 = modbus_tk.utils.create_logger(name="console", record_format="%(message)s")
        #add 2 blocks of holding registers
        self.slave1.add_block("h", mdef.HOLDING_REGISTERS, 0, 1000)#address 0, length 10
        self.slave1.add_block("c", mdef.COILS, 0, 1000)#address 20, length 20
        self.server1.start()
        logger2 = modbus_tk.utils.create_logger(name="console", record_format="%(message)s")
        #add 2 blocks of holding registers
        self.slave2.add_block("h", mdef.HOLDING_REGISTERS, 0, 1000)#address 0, length 10
        self.slave2.add_block("c", mdef.COILS, 0, 1000)#address 20, length 20
        self.server2.start()    
        print "Slave is running..."
        conter=0;
        readReg1=range(0,499,10);
        readReg2=range(500,991,10);
        filename=str(time.ctime())
        filename=filename.replace(":","_")        
        file=open("data/" + filename +".xls",'w')
        while(conter<100000):
            for r in readReg1:
                tempvalue=self.slave1.get_values('c', r, 10)
                self.slave2.set_values("c", r, tempvalue)
                tempvalue=self.slave1.get_values('h', r, 10)
                self.slave2.set_values("h", r, tempvalue)    
            for r in readReg2:
                tempvalue=self.slave2.get_values('c', r, 10)
                self.slave1.set_values("c", r, tempvalue)
                tempvalue=self.slave2.get_values('h', r, 10)
                self.slave1.set_values("h", r, tempvalue)                
            conter+=1;
            if conter<5000:
                file.write( self.dumpData(conter)+"\n");
            else:
                if file.closed==False:
                    file.close()  
            time.sleep(self.pullRate);

if __name__ == '__main__':
    s= HMIServer(0.5);
    s.start();
