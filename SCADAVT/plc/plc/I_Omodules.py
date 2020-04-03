import SocketServer
import struct
import io
from ConfigParser import SafeConfigParser
import os.path
import sys
class MyTCPHandler(SocketServer.BaseRequestHandler):
    def handle(self):
        # self.request is the TCP socket connected to the client
        parser = SafeConfigParser()
        RWCounter=1;
        processNum=0;
        connection=0;
#=======================
        while(RWCounter<>0):
            self.data = self.request.recv(29)
            [RWCounter,action,paraID,data]= struct.unpack("!fB20sf",self.data);
            paraID=paraID.strip('\x00');
            if action==1:
                print "writing into PLC " + str(RWCounter)
            elif action==2:
                print "reading from PLC " + str(RWCounter)
                # when actiom =1 the data stored into plc input modul
            if action==1: 
                # when action =1 input module of PLC  is fed with measurement data 
                if connection==0:
                    file=open('IO_modules/output' + str(int(RWCounter))+'.ini','w')
                    parser.read('IO_modules/output' + str(int(RWCounter))+'.ini');
                    connection=1;
                if RWCounter==0:   
                    parser.write(file);           
                    file.close(); 
                    file=open('IO_modules/outputIsReady.txt','w')
                    file.write("ready");
                else:
                    parser.add_section(paraID)
                    parser.set(paraID,'Value',str(data)) 
            elif action==2: 
                # when action =2 measurement data of  output module of PLC  is read
                if RWCounter ==0:
                    #self.request.sendall(struct.pack("!B20s10sffffs",action,'','',0,0,0,0,''));  
                    self.request.sendall(struct.pack("!fB20sf",0,action,'',0)); 
                    break;
                if connection==0:
                    if os.path.exists('IO_modules/inputIsReady.txt'):
                        if os.path.exists('IO_modules/input' + (str(int(RWCounter))+'.ini').strip(' ')):
                            parser.read('IO_modules/input' + (str(int(RWCounter))+'.ini').strip(' ')); 
                            connection=1;
                            os.remove('IO_modules/inputIsReady.txt');  
                        else:
                            self.request.sendall(struct.pack("!fB20sf",0,action,'',0));       
                    else:
                        self.request.sendall(struct.pack("!fB20sf",0,action,'',0));      
                if  connection==1: 
                    if parser.has_section(paraID):
                        data=parser.getfloat(paraID, 'value');
                        self.request.sendall(struct.pack("!fB20sf",RWCounter,action,paraID,data));            
if __name__ == "__main__":
    if os.path.exists('IO_modules'):
        os.system('rm -rf IO_modules')
        os.mkdir("IO_modules") 
    else:
        os.mkdir("IO_modules") 
    HOST, PORT = '172.16.0.1', 9161
    server = SocketServer.TCPServer((HOST, PORT), MyTCPHandler)
    server.serve_forever()