class Emotions {
  OscP5 oscP5;

  Emotions() {
    oscP5 = new OscP5(this, 7000);
  }

  void oscEvent(OscMessage msg) {
    if (msg.checkAddrPattern("/valence")) {
      emotions.put("valence", msg.get(0).floatValue());
    }
    if (msg.checkAddrPattern("/arousal")) {
      emotions.put("arousal", msg.get(0).floatValue());
    }
  }
}