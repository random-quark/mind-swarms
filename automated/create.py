import csv, subprocess

people = {}

with open('thoughts.csv', "r") as data_file:
    reader = csv.reader(data_file)
    counter = 0
    for line in reader:
        if (line[0] not in people):
            people[line[0]] = []
        people[line[0]].append((line[1], line[2], line[3]))

for person, thoughts in people.iteritems():
    for thought in thoughts:
        dataFile = open("viz.app/Contents/Java/data/data.csv", "w")
        writer = csv.writer(dataFile)
        thought_name = thought[0]
        emotion1 = thought[1]
        emotion2 = thought[2]
        writer.writerow([emotion1, 0.5])
        writer.writerow([emotion2, 0.5])
        writer.writerow(['0.5'])
        writer.writerow([thought_name])
        writer.writerow([person])
        dataFile.flush()
        subprocess.call(["open", "-W", "viz.app"])
