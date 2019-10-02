class Patch {
  String weird[] = {"anger-joy", "anger-love", "joy-anger", "joy-disgust", "love-disgust", "disgust-anger", "disgust-joy", "disgust-sadness", "disgust-fear", "disgust-surprise", "disgust-love", "sadness-joy"};
  String positive[] = {"joy-sadness", "joy-fear", "joy-surprise", "joy-love", "love-anger", "love-joy", "love-sadness", "love-fear", "love-surprise", "fear-love", "surprise-joy", "surprise-love"};
  String negative[] = {"anger-disgust", "anger-sadness", "anger-fear", "anger-surprise", "fear-anger", "fear-joy", "fear-disgust", "fear-sadness", "sadness-anger", "sadness-disgust", "sadness-fear", "sadness-surprise", "sadness-love", "surprise-anger", "surprise-disgust", "surprise-sadness", "surprise-fear", "fear-surprise"};

  void load(boolean valence) {
    String emotion;
     
    // if hash is not used then even emotions turn to random
    if (useHash == false) {
      if (random(1)<0.5) valence = true;
      else valence = false;
    }
    println("VALENCE: " + valence);

    int hash = 0;
    emotion = positive[0];

    if (useHash) {
      // uses hash based on thought so that emotions are random but consistent.
      for (int i = 0; i < thought_name.length()/2; i++) { //not all letters of thought. Stop in the middle otherwise it becomes too big
        hash = hash*2 + int(thought_name.charAt(i));
      }
      println("hash is: " + hash);
      randomSeed(hash);
      if (valence) emotion = positive[abs((hash)%positive.length)];
      else emotion = negative[abs((hash)%negative.length)];
    }
    else {
      //currently random emotions each time it's run. Code above does it with hash function.
      if (valence) emotion = positive[int(random(positive.length))];
      else emotion = negative[int(random(negative.length))];
    }
    String [] emotions = split(emotion, '-');
    emotionslist.add(emotions[0]);
    emotionspercents.add(random(0.5, 0.7));
    emotionslist.add(emotions[1]);
    emotionspercents.add(random(0.15, 0.3));
  }
}
