// M_1_5_03_TOOL.pde
// Agent.pde, GUI.pde

void setupGUI(){
  color activeColor = color(0,130,164);
  controlP5 = new ControlP5(this);
  //controlP5.setAutoDraw(false);
  controlP5.setColorActive(activeColor);
  controlP5.setColorBackground(color(170));
  controlP5.setColorForeground(color(50));
  controlP5.setColorCaptionLabel(color(50));
  controlP5.setColorValueLabel(color(255));
  
  int posY = 5;
  int posX = 10;
    
  controlP5.addToggle("calibrate")
     .setPosition(posX,posY)
     .setSize(50,20)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;     
  posX += 60;
  
  controlP5.addToggle("adjustData")
     .setPosition(posX,posY)
     .setSize(50,20)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
  posX += 60;
     
  controlP5.addToggle("record")
     .setPosition(posX,posY)
     .setSize(50,20)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;   
  posX += 60;     
     
  controlP5.addButton("saveData")
     .setValue(0)
     .setPosition(posX,posY)
     .setSize(75,20)
     ;
    
}

void saveData() {
  saveData = true;
}

void drawGUI(){
  controlP5.show();
  controlP5.draw();
}

// called on every change of the gui
void controlEvent(ControlEvent theEvent) {
  //println("got a control event from controller with id "+theEvent.getController().getId());
  // noiseSticking changed -> set new values
  if(theEvent.isController()) {
    if (theEvent.getController().getId() == 3) {
  
    }
  }
}