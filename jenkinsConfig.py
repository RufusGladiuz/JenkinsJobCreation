import jenkins

print("hello world")

config = open("config.xml", "r")
configAsString = config.read()
print(configAsString)

server = jenkins.Jenkins('http://localhost:8080', username='devops', password='admin123')
server.create_job("devops_SoSe2020", configAsString)