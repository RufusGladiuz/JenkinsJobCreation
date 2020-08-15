import jenkins

config = open("config.xml", "r")
configAsString = config.read()


server = jenkins.Jenkins('http://104.248.16.120:8080', username='devops', password='admin123')
server.create_job("Test2", configAsString)



jobs = server.get_jobs()
print(jobs)

#myconfig = server.get_job_config("Test")

#print(myconfig)