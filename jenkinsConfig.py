import jenkins
import sys
import socket
import netifaces as ni

#arguments: 1->Loginname 2->password 3->Jobname 4->repoadress 5->jenkins DomainName

ni.ifaddresses('eth0')
ip = ni.ifaddresses('eth0')[ni.AF_INET][0]['addr']
print("adress one")
print(ip)

for value in sys.argv:
    print(value)

config = open("config.xml", "r")
configAsString = config.read()

configAsString = configAsString.replace("#Repo", sys.argv[4])

server = jenkins.Jenkins(f"http://{ip}:8080", username=sys.argv[1], password=sys.argv[2])
server.create_job(sys.argv[3], configAsString)
