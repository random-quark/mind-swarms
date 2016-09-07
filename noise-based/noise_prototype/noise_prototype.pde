// M_1_5_03_TOOL.pde, Agent.pde, GUI.pde
/**
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
Palette palette;
Agent[] agents;
int agentsCount = 30000;
int maxAgents = 30000;
float noiseScale = 150, noiseZMax = 0.03, noiseZStep = 0;
int noiseDet = 4;
float overlayAlpha = 0, agentsAlpha = 10, agentAlphaDecrement = 1, strokeWidth = 1, maxAngleSpan = 150;
float randomSeed; //every time program starts it looks different
float randomStepOnReset=0; // when agent is reborn is gets moved slightly - this says how much
int agentTTL=7; // agent TTL to live in seconds
PImage imagePalette;
float minSpeed = 1, maxSpeed = 5;
float separationPercentage = 0.;

boolean showPalette, diminishStroke;

// ------ ControlP5 ------
ControlP5 controlP5;
boolean showGUI = false;
Slider[] sliders;

void setup() {
  frameRate(20);
  //fullScreen(P2D);
  size(1500, 800, P2D);
  background(255);
  imagePalette = loadImage("sky4.jpg");
  palette = new Palette(250);
  initSwarm();
  setupGUI();
}

void draw() {
  fill(255, overlayAlpha);
  noStroke();
  rect(0, 0, width, height);

  pushStyle();
  //draw agents
  for (int i=0; i<agentsCount; i++) agents[i].update1();
  popStyle();
  noiseDetail(noiseDet);
  //println(frameRate);
  drawGUI();

  // prints and exits at spec frame - good for comparing algorithms
  //if (frameCount==400) {
  //  saveFrame(timestamp()+".png");
  //  exit();
  //}
  
  if (showPalette) {
    palette.draw();
  }
}

void initSwarm() {
  pushStyle();
  randomSeed = random(10000);
  agents = new Agent[maxAgents]; // create more ... to fit max slider agentsCount
  for (int i=0; i<agents.length; i++) agents[i] = new Agent();
  popStyle();
}

void keyReleased() {
  if (key=='m' || key=='M') {
    showGUI = controlP5.getGroup("menu").isOpen();
    showGUI = !showGUI;
  }
  if (key=='R' || key=='r') {
    background(255);
    palette = new Palette(250);
    initSwarm();
  }
  if (key == 't' || key == 't') {
    for (int i=0; i<agents.length; i++) agents[i].resetAgent();
  }
  if (showGUI) controlP5.getGroup("menu").open();
  else controlP5.getGroup("menu").close();

  if (key=='s' || key=='S') saveFrame(timestamp()+".png");
  if (key == DELETE || key == BACKSPACE) background(255);
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}