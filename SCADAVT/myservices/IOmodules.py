#
# CORE
# Copyright (c)2010-2011 the Boeing Company.
# See the LICENSE file included in this distribution.
#
''' Sample user-defined service.
'''

import os

from core.service import CoreService, addservice
from core.misc.ipaddr import IPv4Prefix, IPv6Prefix

class IOmodules(CoreService):
    ''' This is a sample user-defined service. 
    '''
    # a unique name is required, without spaces
    _name = "IO_modules"
    # you can create your own group here
    _group = "SCADAVT"
    # list of other services this service depends on
    _depends = ()
    # per-node directories
    _dirs = ()
    # generated files (without a full path this file goes in the node's dir,
    #  e.g. /tmp/pycore.12345/n1.conf/)
    _configs = ('I_Omodules.py', )
    # this controls the starting order vs other enabled services
    _startindex = 1
    # list of startup commands, also may be generated during startup
    _startup = ('python I_Omodules.py',)
    # list of shutdown commands
    _shutdown = ()

    @classmethod
    def generateconfig(cls, node, filename, services):
        cfg=" \n"
        f = open('/home/core/Dropbox/ubuntuWork/plc/I_Omodules.py', 'r')
	nodeNO=node.name
	nodeNO=nodeNO.strip('n')
	ip="172.16.0" + nodeNO
        for line in f:
	    if "172.16.0.1" in line:
		line=line.replace("172.16.0.1",ip)
            cfg+= line
        f.close()
        return cfg
    @staticmethod
    def subnetentry(x):
        ''' Generate a subnet declaration block given an IPv4 prefix string
            for inclusion in the config file.
        '''
        if x.find(":") >= 0:
            # this is an IPv6 address
            return ""
        else:
            net = str(IPv4Prefix(x))
            net = net.split('/')
            return net[0]

# this line is required to add the above class to the list of available services
addservice(IOmodules)

