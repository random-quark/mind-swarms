void setupGUI() {
  color activeColor = color(0,130,164);
  controlP5 = new ControlP5(this);
  controlP5.setColorActive(activeColor);
  controlP5.setColorBackground(color(170));
  controlP5.setColorForeground(color(50));
  controlP5.setColorCaptionLabel(color(50));
  controlP5.setColorValueLabel(color(255));  
  
  ControlGroup ctrl = controlP5.addGroup("options",15,25,55);
  ctrl.setColorLabel(color(255));
  ctrl.close();
  
  sliders = new Slider[10];
  
  int left = 0;
  int top = 5;
  int len = 300;

  int si = 0;
  int posY = 0;
  sliders[si++] = controlP5.addSlider("numParticles",1,maxParticles,left,top+posY+0,len,15);
  posY += 30;

  sliders[si++] = controlP5.addSlider("numAttractors",1,maxAttractors,left,top+posY+0,len,15);
  posY += 30;

  for (int i = 0; i < si; i++) {
    sliders[i].setGroup(ctrl);
    sliders[i].setId(i);
    sliders[i].getCaptionLabel().toUpperCase(true);
    sliders[i].getCaptionLabel().getStyle().padding(4,3,3,3);
    sliders[i].getCaptionLabel().getStyle().marginTop = -4;
    sliders[i].getCaptionLabel().getStyle().marginLeft = 0;
    sliders[i].getCaptionLabel().getStyle().marginRight = -14;
    sliders[i].getCaptionLabel().setColorBackground(0x99ffffff);
  }  
}

void drawGUI() {
  controlP5.show();
  controlP5.draw();
}

// called on every change of the gui
void controlEvent(ControlEvent theEvent) {
  ////println("got a control event from controller with id "+theEvent.getController().getId());
  //// noiseSticking changed -> set new values
  //if(theEvent.isController()) {
  //  if (theEvent.getController().getId() == 3) {
  //    for(int i=0; i<numParticles; i++) agents[i].setNoiseZRange(noiseZRange);  
  //  }
  //}
}