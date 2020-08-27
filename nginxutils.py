import sys

with open("./terraform/default","r+") as f:
    text = f.read()
    finalText = text.replace("my_server",sys.argv[1])
    f.seek(0)
    f.write(finalText)
    f.truncate()


