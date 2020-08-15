import jenkins
import sys

#arguments: 1->Loginname 2->password 3->jobname 4->repoadress

config = open("config.xml", "r")
configAsString = config.read()

server = jenkins.Jenkins('http://104.248.16.120:8080', username=sys.argv[1], password=sys.argv[2])
server.create_job(sys.argv[3], configAsString)
