# EN_PRESSURE = 11
# EN_DEMAND = 9
# EN_HEAD = 10
##link data type
# EN_FLOW = 8
# EN_STATUS = 11
# EN_SETTING = 12
#----------------------------------------------------------------------------
import socket
import sys
import os
import struct
import time 
from ConfigParser import SafeConfigParser
from IOModulesGateway import IOModulesGateway
class WDS_Server:
    def __init__(self,WSDServerIP='10.130.150.119',WSDServerPort =9009):
        self.WSDServerIP=WSDServerIP;
        self.WSDServerPort = WSDServerPort;
        self.process_parameters=[];
        pro1=['P1',2,11,'process1','i'];
        pro2=['P2',2,11,'process2','i'];
        pro3=['P3',2,11,'process3','i'];
        pro4=['P1',2,11,'process4','o'];
        pro5=['P2',2,11,'process5','o'];
        pro6=['P3',2,11,'process6','o'];
        pro7=['P4',2,11,'p4_i','i'];
        pro8=['P5',2,11,'p5_i','i'];
        pro9=['P4',2,11,'p4_o','o'];
        pro10=['P5',2,11,'p5_o','o'];  
        pro11=['T1',1,11,'t1_i','i']; 
        pro12=['T2',1,11,'t2_i','i']; 
        pro13=['T3',1,11,'t3_i','i']; 
        pro14=['V1',2,12,'v1_i','i'];  
        pro15=['V1',2,12,'v1_o','o']; 
        pro16=['V2',2,12,'v2_i','i']; 
        pro17=['V2',2,12,'v2_o','o']; 
        pro18=['J3',2,11,'j3_i','i'];
        pro19=['Pi16',2,8,'pi16_i','i'];
        pro20=['Pi9',2,8,'pi9_i','i'];
        pro21=['Pi8',2,8,'pi8_i','i'];
        self.process_parameters=[pro1,pro2,pro3,pro4,pro5,pro6,pro7,pro8,pro9,pro10,pro11,pro12,pro13,pro14,pro15,pro16,pro17,pro18,pro19,pro20,pro21]; 
        print "writting data to PLC " + str(23);       
#=========================================
    def WDSRquestMessage(self,action,compID,compType,dataType,dataValue):
        message = struct.pack(">b10sbb10s",action,compID,compType,dataType,str(dataValue));
        return message;
    def WDSResponseMessage(self,message):
        tempData =message.split(':');
        [action,paraID,compType,dataType,dataValue] = [int(float(tempData[0])),tempData[1],int(float(tempData[2])),int(float(tempData[3])),float(tempData[4])];
        return  [action,paraID,compType,dataType,dataValue];
    def getParaByProcessID(self,ProcessID):
        for para in  self.process_parameters:
            if para[3]==ProcessID and para[4]=='o':
                return para;
    def read_values_from_WDS(self,WDSSock):
        measurementData={};
        for para in self.process_parameters: 
            if para[4]=='i':
                requestMessage=self.WDSRquestMessage(1,para[0],para[1],para[2],0);
                WDSSock.sendall(requestMessage)
                responseMessage=WDSSock.recv(1024)
                splitResponseMessage=self.WDSResponseMessage(responseMessage);
                measurementData[para[3]]=splitResponseMessage[4];
            else:
                measurementData[para[3]]=0;
        message = struct.pack(">b10sbb10s",0,'read',0,0,'00');
        WDSSock.sendall(message)
        responseMessage=WDSSock.recv(1024);
        return measurementData
 #=========================================
    def write_values_into_WDS(self,measurementData,WDSSock):
        for processID, value in measurementData.iteritems(): 
            para=self.getParaByProcessID(processID);
            [comID,compType,dataType,devicetype]=[para[0],para[1],para[2],para[4]];
            if devicetype=='o':
                requestMessage=self.WDSRquestMessage(2,comID,compType,dataType,value);
                WDSSock.sendall(requestMessage);
                responseMessage=WDSSock.recv(1024);
        message = struct.pack(">b10sbb10s",0,'write',0,0,'00');
        WDSSock.sendall(message)
        responseMessage=WDSSock.recv(1024);
    def start(self,pollRate=0.01):
	print "writting data to PLC " + str(54);
        plcModule =IOModulesGateway(pollRate);
        counter=1;
        readCounter=0;
        writeCounter=0;
        operationState=1; # reading is 1 /writing is 2
        WDSSock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        WDSSock.connect((self.WSDServerIP, self.WSDServerPort))   
        while (counter<=150000):
            if operationState==1:
                readCounter+=1;
                measurementData =self.read_values_from_WDS(WDSSock);
                plcModule.write_data_to_InputModules(measurementData,readCounter);
                operationState=2;
                print "writting data to PLC " + str(readCounter);                
            elif operationState==2:
                writeCounter+=1;
                measurementData=plcModule.read_data_from_outputModules(writeCounter);
                self.write_values_into_WDS(measurementData,WDSSock);
                operationState=1;
                print "reading data from PLC " + str(writeCounter);
            time.sleep(pollRate);
            counter+=1;   
        WDSSock.close();
#=========================================
if __name__ == '__main__':
    ip='10.130.150.119';
    s= WDS_Server(ip,9009)	
    s.start(1)
