import csv
from collections import Counter
from operator import itemgetter

ranges = {
    'disgust': [[0,0.25],[0,0.5]],
    'sad': [[0, 0.5],[0.5, 1]],
    'anger': [[0.25, 0.5],[0.25, 0.5]],
    'fear': [[0.25, 0.5],[0, 0.25]],
    'surprise': [[0.5, 0.75],[0, 0.25]],
    'love': [[0.75, 1],[0, 0.25]],
    'joy': [[0.5, 1],[0.25, 0.5]],
    'calm': [[0.5, 1],[0.5, 1]],
}

emotions = []
emotions_len = 0
activations = []

with open("data_raw/data.csv", "r") as data_file:
    reader = csv.reader(data_file)
    next(reader, None)
    for line in reader:
        emotions_len += 1
        valence = float(line[1])
        activation = float(line[2])
        activations.append(activation)
        found = False
        for emotion, parts in ranges.iteritems():
            if parts[0][0] <= valence <= parts[0][1] and parts[1][0] <= activation <= parts[1][1]:
                emotions.append(emotion)
                found = emotion

activation_avg = reduce(lambda x, y: x + y, activations) / len(activations)


emotion_frequency = Counter(emotions)
emotions_frequency_list = [(k,v) for k,v in emotion_frequency.iteritems()]
emotions_list_sorted = sorted(emotions_frequency_list, key=itemgetter(1), reverse=True)
print emotions_list_sorted

writer = csv.writer(open("data_processed/data.csv", "w"))
for e in emotions_list_sorted:
    percent = float(e[1])/emotions_len
    writer.writerow([e[0], percent])
writer.writerow([activation_avg])
