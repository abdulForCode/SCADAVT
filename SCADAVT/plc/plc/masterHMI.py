import modbus_tk
import modbus_tk.defines as cst
import modbus_tk.modbus_tcp as modbus_tcp
import time
if __name__ == "__main__":
    try:
        #Connect to the slave
        master = modbus_tcp.TcpMaster('192.168.32.137',502)
        #master = modbus_tcp.TcpMaster('192.168.16.132',502)
        #master.execute(1, cst.WRITE_MULTIPLE_REGISTERS, 0, output_value=[45])
        cc=1;
        s=[[1,1,1],[0,0,0]];
        turnPump=0;
        while(cc<100):
            master.execute(1, cst.WRITE_MULTIPLE_REGISTERS, 0, output_value=[cc])
            master.execute(1, cst.WRITE_MULTIPLE_COILS, 0, output_value=s[turnPump])
            cc+=1;
            if turnPump==0:
                turnPump=1;
            else:
                turnPump=0;
            time.sleep(2);
        print master.execute(1, cst.READ_COILS, 0, 1)
        print master.execute(1, cst.READ_HOLDING_REGISTERS, 0, 1)
##        print master.execute(1, cst.READ_COILS , 10, 10)
##        print master.execute(1, cst.READ_DISCRETE_INPUTS, 20, 10)
##        print master.execute(1, cst.READ_INPUT_REGISTERS, 30, 10)
#-----------------------------------------------------------------------------------------------------------------
##        master.execute(1, cst.WRITE_MULTIPLE_REGISTERS, 0, output_value=range(300,310))
##        master.execute(1, cst.WRITE_SINGLE_REGISTER, 0, output_value=[3434])
##        master.execute(1, cst.WRITE_MULTIPLE_COILS, 10,output_value= [1,1,1,1,1])
##        master.execute(1, cst.WRITE_SINGLE_COIL, 10,output_value= [55])
    except modbus_tk.modbus.ModbusError, e:
        print "Modbus error ", e.get_exception_code()

    except Exception, e2:
        print "Error ", str(e2)
