from github import Github
import sys
import socket
import netifaces as ni

#arguments: 1->githubrepo 2-> GitHubAccessToken

ni.ifaddresses('eth0')
ip = ni.ifaddresses('eth0')[ni.AF_INET][0]['addr']
splitOfURL =  sys.argv[1].split("/")
repoName = f"{splitOfURL[3]}/{splitOfURL[4]}".split(".")[0]

g = Github(sys.argv[2])
EVENTS = ["push"]
config = {
        "url": "http://{host}/{endpoint}".format(host=f"{ip}:8080", endpoint="github-webhook/"),
        "content_type": "json"
    }

repo = g.get_repo(repoName)
repo.create_hook("web", config, EVENTS, active=True)

print("Successfully create webhook")
