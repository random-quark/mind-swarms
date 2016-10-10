import java.util.Calendar;

class Recorder {
  Table data;

  Recorder() {
    data = new Table();
    data.addColumn("id");
    data.addColumn("valence");
    data.addColumn("activation");
    data.addColumn("accX");
    data.addColumn("accY");
    data.addColumn("accZ");
    data.addColumn("electrode0");
    data.addColumn("electrode1");
    data.addColumn("electrode2");   
    data.addColumn("electrode3");
  }

  void addData(int time, float arousal, float valence) {
    TableRow row = data.addRow();
    row.setInt("id", time);
    row.setFloat("valence", valence);
    row.setFloat("activation", activation);
    row.setFloat("accX", accX);
    row.setFloat("accY", accY);
    row.setFloat("accZ", accZ);
    row.setFloat("electrode0", electrodes[0]);
    row.setFloat("electrode1", electrodes[1]);
    row.setFloat("electrode2", electrodes[2]);
    row.setFloat("electrode3", electrodes[3]);
  }

  void saveData() {
    saveTable(data, "data/" + timestamp() + ".csv");
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}