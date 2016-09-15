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

  ControlGroup ctrl = controlP5.addGroup("menu",15,25,35);
  ctrl.setColorLabel(color(255));
  ctrl.close();

  sliders = new Slider[15];

  int left = 0;
  int top = 5;
  int len = 300;

  int si = 0;
  int posY = top;
  
  sliders[si++] = controlP5.addSlider("agentsCount",1,maxAgents,left,posY,len,15);
  
  posY += 30;
  sliders[si++] = controlP5.addSlider("noiseScale",1,1000,left,posY,len,15);
  posY+=20;
  sliders[si++] = controlP5.addSlider("noiseDet",1,15,left,posY,len,15);
  posY+=20;  
  sliders[si++] = controlP5.addSlider("maxAngleSpan",0,360,left,posY,len,15);
  posY+=20;  
  sliders[si++] = controlP5.addSlider("agentTTL",0,50000,left,posY,len,15);
  posY+=20;
  sliders[si++] = controlP5.addSlider("strokeWidth",0,10,left,posY,len,15);
  
  posY += 30;
  sliders[si++] = controlP5.addSlider("interAgentNoiseZRange",0,1,left,posY,len,15);
  posY+=20;
  sliders[si++] = controlP5.addSlider("noiseZStep",0,0.01,left,posY,len,15);
  posY += 20;
  sliders[si++] = controlP5.addSlider("noiseStrength",0,1,left,posY,len,15);
  
  posY += 30;
  sliders[si++] = controlP5.addSlider("agentsAlpha",0,255,left,posY,len,15);
  posY += 20;
  sliders[si++] = controlP5.addSlider("overlayAlpha",0,255,left,posY,len,15);
  
  posY += 30;
  sliders[si++] = controlP5.addSlider("minSpeed",0,20,left,posY,len,15);
  posY += 20;
  sliders[si++] = controlP5.addSlider("maxSpeed",0,20,left,posY,len,15);
  
  posY += 30;
  sliders[si++] = controlP5.addSlider("numCircles",0,100,left,posY,len,15);
  
  posY += 30;
  Toggle stroke = controlP5.addToggle("diminishingAlpha")
     .setPosition(0,posY)
     .setSize(50,20)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
  stroke.setGroup(ctrl);
  
  posY+=40;
  Toggle usePalette = controlP5.addToggle("usePalette")
     .setPosition(0,posY)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
  usePalette.setGroup(ctrl);  
  
  posY+=40;
  Toggle palette = controlP5.addToggle("showPalette")
     .setPosition(0,posY)
     .setSize(50,20)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
  palette.setGroup(ctrl);  
  
  posY+=40;
  Toggle reseterror = controlP5.addToggle("resetWithError")
     .setPosition(0,posY)
     .setSize(50,20)
     .setValue(false)
     .setMode(ControlP5.SWITCH)
     ;
  reseterror.setGroup(ctrl);   
  
  posY+=40;
  Toggle showLive = controlP5.addToggle("showLive")
     .setPosition(0,posY)
     .setSize(50,20)
     .setValue(true)
     .setMode(ControlP5.SWITCH)
     ;
  showLive.setGroup(ctrl);     
  
  for (int i = 0; i < si; i++) {
    sliders[i].setGroup(ctrl);
    sliders[i].setId(i);
    sliders[i].getCaptionLabel().toUpperCase(false);
    sliders[i].getCaptionLabel().getStyle().padding(4,3,3,3);
    sliders[i].getCaptionLabel().getStyle().marginTop = -4;
    sliders[i].getCaptionLabel().getStyle().marginLeft = 0;
    sliders[i].getCaptionLabel().getStyle().marginRight = -14;
    sliders[i].getCaptionLabel().setColorBackground(0x99ffffff);
  }

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