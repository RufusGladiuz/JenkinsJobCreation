import sys
import socket
import netifaces as ni
#arguments: 1->domainname

ni.ifaddresses('eth0')
ip = ni.ifaddresses('eth0')[ni.AF_INET][0]['addr']

config = open("monitrc", "r+")
configAsString = config.read()

configAsString = configAsString.replace("#serverIP", ip)
configAsString = configAsString.replace("#domainName", sys.argv[1])

config.seek(0)
config.write(configAsString)
config.truncate()

config.close()



