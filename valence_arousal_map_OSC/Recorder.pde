import java.util.Calendar;

class Recorder {
  Table data;
  
  Recorder() {
    data = new Table();
    data.addColumn("id");
    data.addColumn("valence");
    data.addColumn("activation");    
  }
  
  void addData(int time, float arousal, float valence) {
    TableRow row = data.addRow();
    row.setInt("id", time);
    row.setFloat("valence", valence);
    row.setFloat("activation", activation);    
  }
  
  void saveData() {
    saveTable(data, "data/" + timestamp() + ".csv");
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}