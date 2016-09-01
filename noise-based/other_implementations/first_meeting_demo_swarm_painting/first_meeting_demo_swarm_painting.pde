
/**
 BASED ON ORIGINAL FROM GENERATIVE BOOK: M_1_5_03_TOOL
 * noise values (noise 3d) are used to animate a bunch of agents.
 * 
 * KEYS
 * m                   : toogle menu open/close
 * 1-2                 : switch noise mode
 * space               : new noise seed
 * backspace           : clear screen
 * s                   : save png
 */

import controlP5.*;
import java.util.Calendar;


// ------ agents ------
PImage imagePalette;
Agent[] agents = new Agent[10000]; // create more ... to fit max slider agentsCount
int agentsCount = 10000;
float noiseScale = 100, noiseStrength = 10, noiseZRange = 0.4;
float overlayAlpha = 0, agentsAlpha = 0, strokeWidth = 0.6;
int drawMode = 1;
int maxAgentsAlpha = 25;

// ------ ControlP5 ------
ControlP5 controlP5;
boolean showGUI = false;
Slider[] sliders;

void setup(){
  size(displayWidth,displayHeight,P2D);
  smooth();
  imagePalette = loadImage("wrangler.jpg");
  background(0);
  
  for(int i=0; i<agents.length; i++) agents[i] = new Agent();

  setupGUI();
}

void draw(){
  fill(255, overlayAlpha);
  noStroke();
  rect(0,0,width,height);

  //stroke(0, agentsAlpha);
  //draw agents
  if (drawMode == 1) {
    for(int i=0; i<agentsCount; i++) agents[i].update1();
  } 
  else {
    for(int i=0; i<agentsCount; i++) agents[i].update2();
  }
  //agentsCount+=1;
  //agentsCount = constrain(agentsCount, 0, 10000);
  agentsAlpha+=0.05;
  agentsAlpha = constrain(agentsAlpha, 0, maxAgentsAlpha);
  
  drawGUI();
}

void keyReleased(){
  if (key=='m' || key=='M') {
    showGUI = controlP5.getGroup("menu").isOpen();
    showGUI = !showGUI;
  }
  if (showGUI) controlP5.getGroup("menu").open();
  else controlP5.getGroup("menu").close();

  if (key == '1') drawMode = 1;
  if (key == '2') drawMode = 2;
  if (key=='s' || key=='S') saveFrame(timestamp()+".png");
  if (key == DELETE || key == BACKSPACE) {background(0); agentsAlpha=0;}
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}