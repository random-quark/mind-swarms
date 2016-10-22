class Data {
  Table data;
  Data() {
  }
  
  void load() {
    data = loadTable("data.csv", "csv");
    for (TableRow row : data.rows()) {
      println(row);
      emotionslist.add(row.getString(0));
      String percentCol = row.getString(1);
      if (percentCol != null && !percentCol.isEmpty()) {
        float percent = Float.valueOf(percentCol);
        emotionspercents.add(percent);
      }
    }
    participant_name = emotionslist.pollLast();
    thought_name = emotionslist.pollLast();
    activationAverage = Float.valueOf(emotionslist.pollLast());
  }
  
  void setNoiseScale() {
    noiseScale = map(activationAverage, 0, 1, noiseScaleMax, noiseScaleMin);
  }
}