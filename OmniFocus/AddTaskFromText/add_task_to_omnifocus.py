# Script designed to add multiple tasks to OmniFocus from text file.
# Copyright © 2020 Zhang Dong
# Licensed under MIT License

from urllib.request import quote
import webbrowser

with open("/Users/xummer/Desktop/Tasks.taskpaper") as f:
    files = f.readlines()

i = 0

def get_content(cur):
    j = len(cur) - 1
    while cur[j] != " ":
        j -= 1
    time = cur[j+1:-1] # ignore '\n'
    task = cur[:j]
    return task + " @estimate(" + time + ")\n"

while i < len(files):
    if files[i] == '\n':
        i += 1
    # find one project line starting from
    projectName = files[i][:-2] # need to remove the ':\n' at the end of project line
    i += 1
    content = "- " + projectName + "\n"
    insertSpace = "    " # 4 spaces
    while i < len(files) and not (files[i] == '\n' or files[i][0].isalpha()):
        cur = files[i]
        if cur[-2] == "h": # task
            content += insertSpace + get_content(cur)
        else: # subproject
            content += insertSpace + cur

        i += 1
    print(projectName)
    print(content)
    url = "omnifocus:///paste?target=projects&content=" + quote(content)
    print(url)
    webbrowser.open(url)


