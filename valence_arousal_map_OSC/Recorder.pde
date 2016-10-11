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
    data.addColumn("alpha_relative0");
    data.addColumn("alpha_relative1");
    data.addColumn("alpha_relative2");
    data.addColumn("alpha_relative3");
    data.addColumn("beta_relative0");
    data.addColumn("beta_relative1");
    data.addColumn("beta_relative2");
    data.addColumn("beta_relative3");    
    data.addColumn("gamma_relative0");
    data.addColumn("gamma_relative1");
    data.addColumn("gamma_relative2");
    data.addColumn("gamma_relative3");    
    data.addColumn("delta_relative0");
    data.addColumn("delta_relative1");
    data.addColumn("delta_relative2");
    data.addColumn("delta_relative3");      
    data.addColumn("theta_relative0");
    data.addColumn("theta_relative1");
    data.addColumn("theta_relative2");
    data.addColumn("theta_relative3");

    data.addColumn("alpha_absolute0");
    data.addColumn("alpha_absolute1");
    data.addColumn("alpha_absolute2");
    data.addColumn("alpha_absolute3");
    data.addColumn("beta_absolute0");
    data.addColumn("beta_absolute1");
    data.addColumn("beta_absolute2");
    data.addColumn("beta_absolute3");    
    data.addColumn("gamma_absolute0");
    data.addColumn("gamma_absolute1");
    data.addColumn("gamma_absolute2");
    data.addColumn("gamma_absolute3");    
    data.addColumn("delta_absolute0");
    data.addColumn("delta_absolute1");
    data.addColumn("delta_absolute2");
    data.addColumn("delta_absolute3");
    data.addColumn("theta_absolute0");
    data.addColumn("theta_absolute1");
    data.addColumn("theta_absolute2");
    data.addColumn("theta_absolute3");    
  }

  void addData(int time) {
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

    row.setFloat("alpha_relative0", alpha_relative[0]);
    row.setFloat("alpha_relative1", alpha_relative[1]);
    row.setFloat("alpha_relative2", alpha_relative[2]);
    row.setFloat("alpha_relative3", alpha_relative[3]);
    row.setFloat("beta_relative0", beta_relative[0]);
    row.setFloat("beta_relative1", beta_relative[1]);
    row.setFloat("beta_relative2", beta_relative[2]);
    row.setFloat("beta_relative3", beta_relative[3]);    
    row.setFloat("gamma_relative0", gamma_relative[0]);
    row.setFloat("gamma_relative1", gamma_relative[1]);
    row.setFloat("gamma_relative2", gamma_relative[2]);
    row.setFloat("gamma_relative3", gamma_relative[3]);    
    row.setFloat("delta_relative0", delta_relative[0]);
    row.setFloat("delta_relative1", delta_relative[1]);
    row.setFloat("delta_relative2", delta_relative[2]);
    row.setFloat("delta_relative3", alpha_relative[3]);    
    row.setFloat("theta_relative0", theta_relative[0]);
    row.setFloat("theta_relative1", theta_relative[1]);
    row.setFloat("theta_relative2", theta_relative[2]);
    row.setFloat("theta_relative3", theta_relative[3]);  

    row.setFloat("alpha_absolute0", alpha_absolute[0]);
    row.setFloat("alpha_absolute1", alpha_absolute[1]);
    row.setFloat("alpha_absolute2", alpha_absolute[2]);
    row.setFloat("alpha_absolute3", alpha_absolute[3]);
    row.setFloat("beta_absolute0", beta_absolute[0]);
    row.setFloat("beta_absolute1", beta_absolute[1]);
    row.setFloat("beta_absolute2", beta_absolute[2]);
    row.setFloat("beta_absolute3", beta_absolute[3]);    
    row.setFloat("gamma_absolute0", gamma_absolute[0]);
    row.setFloat("gamma_absolute1", gamma_absolute[1]);
    row.setFloat("gamma_absolute2", gamma_absolute[2]);
    row.setFloat("gamma_absolute3", gamma_absolute[3]);    
    row.setFloat("delta_absolute0", delta_absolute[0]);
    row.setFloat("delta_absolute1", delta_absolute[1]);
    row.setFloat("delta_absolute2", delta_absolute[2]);
    row.setFloat("delta_absolute3", alpha_absolute[3]);    
    row.setFloat("theta_absolute0", theta_absolute[0]);
    row.setFloat("theta_absolute1", theta_absolute[1]);
    row.setFloat("theta_absolute2", theta_absolute[2]);
    row.setFloat("theta_absolute3", theta_absolute[3]);       
  }

  void saveData() {
    saveTable(data, "data/" + timestamp() + "_" + name + ".csv");
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}