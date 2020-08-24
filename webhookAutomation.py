from github import Github
import sys

#arguments: 1->githubrepo 2-> GitHubAccessToken
splitOfURL =  "https://github.com/RufusGladiuz/lecture-devops-app.git".split("/")
repoName = f"{splitOfURL[3]}/{splitOfURL[4]}".split(".")[0]


g = Github(sys.argv[2])
EVENTS = ["push"]
config = {
        "url": "http://{host}/{endpoint}".format(host="134.209.229.61:8080", endpoint="github-webhook/"),
        "content_type": "json"
    }

repo = g.get_repo(repoName)
repo.create_hook("web", config, EVENTS, active=True)

print("Successfully create webhook")
