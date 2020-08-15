import jenkins

config = open("config.xml", "r")
configAsString = config.read()


server = jenkins.Jenkins('http://104.248.16.120:8080', username='devops', password='admin123')
server.create_job("devops_SoSe2020", configAsString)