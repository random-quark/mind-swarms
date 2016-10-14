import csv, subprocess

people = {}

with open('thoughts.csv', "r") as data_file:
    reader = csv.reader(data_file)
    counter = 0
    for line in reader:
        if (line[0] not in people):
            people[line[0]] = []
        people[line[0]].append((line[1], line[2], line[3]))

for k, v in people.iteritems():
    for e in v:
        dataFile = open("viz.app/Contents/Java/data/data.csv", "w")
        writer = csv.writer(dataFile)
        writer.writerow([e[1], 0.5])
        writer.writerow([e[2], 0.5])
        writer.writerow(['0.5'])
        dataFile.flush()
        print "data", [e[1], 0.5], [e[2], 0.5]
        subprocess.call(["open", "-W", "viz.app"])
