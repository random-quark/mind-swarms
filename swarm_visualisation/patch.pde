class Patch {
  String weird[] = {"anger-joy", "anger-love", "joy-anger", "joy-disgust", "love-disgust", "disgust-anger", "disgust-joy", "disgust-sadness", "disgust-fear", "disgust-surprise", "disgust-love", "sadness-joy"};
  String positive[] = {"joy-sadness", "joy-fear", "joy-surprise", "joy-love", "love-anger", "love-joy", "love-sadness", "love-fear", "love-surprise", "fear-love", "surprise-joy", "surprise-love"};
  String negative[] = {"anger-disgust", "anger-sadness", "anger-fear", "anger-surprise", "fear-anger", "fear-joy", "fear-disgust", "fear-sadness", "sadness-anger", "sadness-disgust", "sadness-fear", "sadness-surprise", "sadness-love", "surprise-anger", "surprise-disgust", "surprise-sadness", "surprise-fear", "fear-surprise"};

  void load(boolean valence) {
    String emotion;

    // uses hash based on thought so that emotions are random but consistent.
    //int hash = 7;
    //for (int i = 0; i < thought_name.length()/2; i++) { //not all letters of thought. Stop in the middle otherwise it becomes too big
    //  hash = hash*3 + int(thought_name.charAt(i));
    //}
    //println("hash is: " + hash);
    //randomSeed(hash);
    //if (valence) emotion = positive[(hash)%positive.length];
    //else emotion = negative[(hash)%negative.length];

    //currently random emotions each time it's run. Code above does it with hash function.
    if (valence) emotion = positive[int(random(positive.length))];
    else emotion = negative[int(random(positive.length))];    

    String [] emotions = split(emotion, '-');
    emotionslist.add(emotions[0]);
    emotionspercents.add(random(0.5, 0.7));
    emotionslist.add(emotions[1]);
    emotionspercents.add(random(0.15, 0.3));
  }
}