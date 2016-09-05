void mouseReleased() {
  if (holdShift) spawnSource();
  else spawn();
}

void keyPressed() {
  if (keyCode == 16) holdShift = true;  //"shift" key
}

void keyReleased() {
  println(keyCode);

  if (keyCode == 32) {  //spacebar
    background(255);
    initializeSwarm(); //initializes particles around canvas
    //beginRecord(PDF, "line.pdf"); 
    for (int i = 0; i < circArray.size(); i++) { // stop all circles growing
      Circ c = (Circ) circArray.get(i);
      Circ cp = (Circ) proxyArray.get(i);
      c.terminate();
      c.startDraw();  // turn a circle into anchor - theo
      cp.terminate();
    }
  }
  //"s" key
  if (keyCode == 83) {
    saveFrame("sketch##.png");
    //endRecord();
    //exit();
  }
  //"shift" key
  if (keyCode == 16) {
    holdShift = false;
  }
}