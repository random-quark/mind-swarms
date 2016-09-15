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
import toxi.math.*;
import toxi.color.*;
import toxi.color.theory.*;
import toxi.util.datatypes.*;
import java.util.Iterator;

// ------ agents ------
Palette palette;
Agent[] agents;
int agentsCount = 100000;
int maxAgents = 100000;
float noiseScale = 150, interAgentNoiseZRange = 0.0, noiseZStep = 0.001;
int noiseDet = 4;
float overlayAlpha = 0, agentsAlpha = 5, strokeWidth = 1, maxAngleSpan = 220;
float randomSeed; //every time program starts it looks different
float randomStepOnReset=0; // when agent is reborn is gets moved slightly - this says how much
int agentTTL=0; // agent TTL to live in seconds
PImage imagePalette;
float minSpeed = 3, maxSpeed = 3;
float separationPercentage = 0.;
boolean usePalette = false, showPalette, resetWithError, showLive = true;
boolean diminishingAlpha = false;
float alphaDecrement = 0.01;
int numCircles = 50;
PGraphics bg;
int sizeX = 1200;
int sizeY = 800;

// ------ ControlP5 ------
ControlP5 controlP5;
boolean showGUI = false;
Slider[] sliders;

void setup() {
  bg = createGraphics(sizeX,sizeY,P2D);
  frameRate(20);
  //fullScreen(P2D);
  size(1500, 800, P2D);
  background(255);
  imagePalette = loadImage("sky4.jpg");
  palette = new Palette();
  initSwarm();
  setupGUI();
}

void draw() {
  bg.beginDraw();
  bg.fill(255, overlayAlpha);
  bg.noStroke();
  bg.rect(0, 0, width, height);
  pushStyle();
  //draw agents
  for (int i=0; i<agentsCount; i++) agents[i].update();
  popStyle();
  noiseDetail(noiseDet);
  bg.endDraw();
  
  drawGUI();
  
  if (showLive) {
    image(bg, 0, 0);
  }
  
  //println(agents[0].tempAlpha);
  if (showPalette) {
    palette.draw();
  }
}

void initSwarm() {
  pushStyle();
  randomSeed = random(1000);
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
    bg.beginDraw();
    bg.background(255);
    bg.endDraw();
     palette = new Palette();
    initSwarm();
  }
  
  if (key=='f' || key=='F') {
    background(255);
    image(bg, 0, 0);
  }
  
  if (key=='P' || key=='p') palette.draw();
  
  if (key == 't' || key == 't') {
    for (int i=0; i<agents.length; i++) agents[i].resetAgent();
  }
  if (showGUI) controlP5.getGroup("menu").open();
  else controlP5.getGroup("menu").close();

  if (key=='s' || key=='S') bg.save(timestamp()+".png");
  if (key == DELETE || key == BACKSPACE) background(255);
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}