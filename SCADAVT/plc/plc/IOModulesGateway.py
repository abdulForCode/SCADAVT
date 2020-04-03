import socket
import sys
import os
import struct
import time 
import binascii
from ConfigParser import SafeConfigParser
class IOModulesGateway:
    def __init__(self,pollRate):
        self.plcs=[];
        self.pollRate=pollRate;
        self.registersMap={};
        parser = SafeConfigParser();
        if os.path.exists('/home/core/PLCsConf.ini'):
            parser.read('/home/core/PLCsConf.ini');
            for section in parser.sections():
                plc=[];
                plc.append(parser.get(section, 'ip'));
                plc.append(parser.getint(section, 'port'));
                plc.append(section);
                self.plcs.append(plc);
        else:
            print "the PLCsConf.ini file is not found";
        parser = SafeConfigParser();
        if os.path.exists('/home/core/registersMap.ini'):
            parser.read('/home/core/registersMap.ini');
            for section in parser.sections():
                tempReg=[];
                tempReg.append(parser.get(section, 'controller'));
                tempReg.append(parser.get(section, 'dataType'));
                self.registersMap[section]= tempReg;     
        else:
            print "the registersMap.ini file is not found";
    #=========================================
    def InputModuleMessage(self,counter,action,paraID,data):
        message = struct.pack("!fB20sf",counter,action,paraID,data);
        return message;
    def outputModuleMessage(self,message):
        [counter,action,paraID,data] = struct.unpack(">fB20sf",message);
        message=[counter,action,paraID,data];
        return message;
    #----------------------------------------------------------------------
    def write_data_to_InputModules(self,measurementData,readCounter):
        for plc in self.plcs:
            HOST, PORT = plc[0], plc[1];
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.connect((HOST, PORT))
            for processID, value in measurementData.iteritems():
                tempReg=self.registersMap[processID];
                if tempReg[0]==plc[2] and tempReg[1]=='i':
                    requestMessage= self.InputModuleMessage(readCounter,1,processID,value);
                    sock.sendall(requestMessage) 
            message = struct.pack("!fB20sf",0,1,' ',0);
            sock.sendall(message)
            sock.close();   
       #----------------------------------------------------------------------    
    def read_data_from_outputModules(self,writeCounter):
        measurementData={};
        for plc in self.plcs:
            HOST, PORT = plc[0], plc[1];
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.connect((HOST, PORT))
            for processID, value in self.registersMap.iteritems():  
                if value[0]==plc[2] and value[1]=='o':
                    fileExists=0;
                    while(fileExists==0):  
                        requestMessage= self.InputModuleMessage(writeCounter,2,processID,0);
                        sock.sendall(requestMessage)
                        splitResponseMessage=self.outputModuleMessage(sock.recv(29));
                        fileExists=splitResponseMessage[0];
                        if fileExists>0:
                            measurementData[processID]=splitResponseMessage[3];
                            break;
                        time.sleep(self.pollRate);
            message = struct.pack("!fB20sf",0,2,' ',0);
            sock.sendall(message)
            sock.close();
        return measurementData;          
    #----------------------------------------------------------------------