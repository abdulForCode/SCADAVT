import modbus_tk
import modbus_tk.modbus_tcp as modbus_tcp
import threading
import modbus_tk.defines as mdef
from ConfigParser import SafeConfigParser
import os
import time 
class Slave():
    logger = modbus_tk.utils.create_logger(name="console", record_format="%(message)s")
    server = modbus_tcp.TcpServer(502,'192.168.32.137',1,None)
    slave1 = server.add_slave(1)
    #add 2 blocks of holding registers
    slave1.add_block("H", mdef.HOLDING_REGISTERS, 0, 1000) #address 0, length 10
    slave1.add_block("C", mdef.COILS, 0, 1000)  #address 20, length 20
    print "Slave is running..."
    server.start()
    