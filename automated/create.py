import csv, subprocess

people = {}

dataFileLoc = "linuxapp/data/data.csv"
executableLoc = "linuxapp/noise_prototype"
# extraCommands = ["open", "-W"] # for MAC
extraCommands = [] # for LINUX
# subprocess.call(extraCommands + [executableLoc])

with open('thoughts.csv', "r") as data_file:
    reader = csv.reader(data_file)
    counter = 0
    for line in reader:
        if (line[0] not in people):
            people[line[0]] = []
        people[line[0]].append({
            "title": line[1],
            "emotion1": { "name": line[2], "proportion": line[4] },
            "emotion2": { "name": line[3], "proportion": line[5] },
            "activation_average": line[6]
        })

for person, thoughts in people.iteritems():
    for thought in thoughts:
        dataFile = open(dataFileLoc, "w")
        writer = csv.writer(dataFile)
        writer.writerow([thought["emotion1"]["name"], thought["emotion1"]["proportion"]])
        writer.writerow([thought["emotion2"]["name"], thought["emotion2"]["proportion"]])
        writer.writerow([thought["activation_average"]])
        writer.writerow([thought["title"]])
        writer.writerow([person])
        dataFile.flush()
        subprocess.call(extraCommands + [executableLoc])
#        subprocess.call(["open", "-W", executableLoc])
