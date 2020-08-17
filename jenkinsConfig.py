import jenkins
import sys
import socket

#arguments: 1->Loginname 2->password 3->Jobname 4->repoadress

ip_address = socket.gethostbyname(socket.gethostname())
print(f"IP Address: {ip_address}")

for value in sys.argv:
    print(value)

config = open("config.xml", "r")
configAsString = config.read()

configAsString = configAsString.replace("#Repo", sys.argv[4])

server = jenkins.Jenkins(f'http://{ip_address}:8080', username=sys.argv[1], password=sys.argv[2])
server.create_job(sys.argv[3], configAsString)
