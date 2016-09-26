import csv
from collections import Counter

ranges = {
    'sad': [[0, 1],[0, 1]],
    'angry': [[0, 0],[0, 0]],
    'fear': [[0, 0],[0, 0]],
    'surprise': [[0, 0],[0, 0]],
    'love': [[0, 0],[0, 0]],
    'joy': [[0, 0],[0, 0]],
    'calm': [[0, 0],[0, 0]],
}

emotions = []
activations = []

with open("data_raw/data.csv", 'r') as data_file:
    reader = csv.reader(data_file)
    next(reader, None)
    for line in reader:
        valence = float(line[1])
        activation = float(line[2])
        activations.append(activation)
        for emotion, parts in ranges.iteritems():
            if parts[0][0] < valence < parts[0][1]:# and parts[1][0] < activation < parts[1][1]:
                emotions.append(emotion)

emotion_frequency = Counter(emotions)

activation_avg = reduce(lambda x, y: x + y, activations) / len(activations)

print emotion_frequency
print activation_avg

emotion_names = emotion_frequency.keys()
print emotion_names

writer = csv.writer(open("data_processed/data.csv", 'w'))
for e in emotion_names:
    writer.writerow([e])
writer.writerow([activation_avg])
