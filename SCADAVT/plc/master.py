import modbus_tk
import modbus_tk.defines as cst
import modbus_tk.modbus_tcp as modbus_tcp
import time
import io
class Master():
        def __init__(self,pullRate=0.1):
                self.pullRate=pullRate;    
        def procedureControl(self):
        #Connect to the slave and execute commands
                try:
                        master = modbus_tcp.TcpMaster('172.16.0.21',502)
                        holding= master.execute(1, cst.READ_HOLDING_REGISTERS, 0, 10) 
                        coils= master.execute(1, cst.READ_COILS , 0, 10)
			#print [holding,coils];
			return [holding,coils];
                except modbus_tk.modbus.ModbusError, e:
                        print "Modbus error ", e.get_exception_code()
                except Exception, e2:
                        print "Error ", str(e2)        
        def start(self):
                conter=0;
		filename=str(time.ctime());
		filename=filename.replace(":","_") ;       
		file=open("data/" + filename +".csv",'w');                
                while(conter<12000):
			[holding, coils] =self.procedureControl();
			#print str(conter);
			line="";
			line=str(conter) + "," + str(float(holding[0])/100) +  "," + str(float(holding[1])/100) +  "," + str(float(holding[2])/100)  +  "," +str(holding[3]) +  "," +str(holding[4]) +  "," + str(holding[5]) +  "," +str(holding[6]) +  "," +str(holding[7]) +  ",";
			line=line+ str(coils[0]) +  "," +str(coils[1]) +  "," +str(coils[2]) +  "," +str(coils[3]) +  "," +str(coils[4]) +"\n";
			print line;
			file.write(line);
                        conter+=1;
                        time.sleep(self.pullRate);    
		file.close();
if __name__ == "__main__":
    s= Master();
    s.start();   


#-----------------------------------------------------------------------------------------------------------------
##        print master.execute(1, cst.READ_HOLDING_REGISTERS, 0, 10)
##        print master.execute(1, cst.READ_COILS , 10, 10)
##        print master.execute(1, cst.READ_DISCRETE_INPUTS, 20, 10)
##        print master.execute(1, cst.READ_INPUT_REGISTERS, 30, 10)
#-----------------------------------------------------------------------------------------------------------------
##        master.execute(1, cst.WRITE_MULTIPLE_REGISTERS, 0, output_value=range(300,310))
##        master.execute(1, cst.WRITE_SINGLE_REGISTER, 0, output_value=[3434])
##        master.execute(1, cst.WRITE_MULTIPLE_COILS, 10,output_value= [1,1,1,1,1])
##        master.execute(1, cst.WRITE_SINGLE_COIL, 10,output_value= [55])