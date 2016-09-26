class Data {
  Table data;
  Data() {
  }
  
  void load() {
    data = loadTable("data.csv", "csv");
    for (TableRow row : data.rows()) {
      emotionslist.add(row.getString(0));
    }
    activationAverage = Float.valueOf(emotionslist.pollLast());
    println(activationAverage);
    println(emotionslist);
  }
}