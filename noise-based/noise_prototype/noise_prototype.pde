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
import java.util.LinkedList;
import java.util.Map;
import oscP5.*;

Palette palette;
PImage imagePalette;
int numCircles = 1;
boolean usePalette = true, showPalette = true;

PGraphics bg;
int sizeX = 1300;
int sizeY = 800;
boolean showLive;

Agent[] agents;
int agentsCount = 30000;
int maxAgents = 100000;
float noiseScale = 150, interAgentNoiseZRange = 0.0, noiseZStep = 0.001;
int noiseDet = 4;
float overlayAlpha = 0, agentsAlpha = 20, strokeWidth = 1, maxAngleSpan = 220, noiseStrength = 1;
float resetStep = 15;
float randomSeed;
int agentTTL=0;
float minSpeed = 3, maxSpeed = 3;
boolean resetWithError;
boolean diminishingAlpha;
float alphaDecrement = 0.01;
float randomInitialDirection = 0;//random(0);

HashMap<String, Float> emotions = new HashMap<String, Float>();
Emotions emotionReceiver; 

Data data;
LinkedList<String> emotionslist = new LinkedList<String>();
float activationAverage;

ControlP5 controlP5;
boolean showGUI;
Slider[] sliders;

void setup() {
  data = new Data();
  data.load();
  emotionReceiver = new Emotions();
  
  bg = createGraphics(sizeX,sizeY,P2D);
  bg.beginDraw();
  bg.background(255);
  bg.endDraw();
  frameRate(20);
  //fullScreen(P2D);
  size(1300, 800, P2D);
  background(255);
  imagePalette = loadImage("xPeriod_1.0_yPeriod_1.0_turbPower_2.0_turbSize_133.0_w_500_h_500.png");
  palette = new Palette(sizeX, sizeY);
  initSwarm();
  setupGUI();
}

void draw() {
  bg.beginDraw();
  bg.fill(255, overlayAlpha);
  bg.noStroke();
  bg.rect(0, 0, width, height);
  pushStyle();
  for (int i=0; i<agentsCount; i++) agents[i].update();
  popStyle();
  noiseDetail(noiseDet);
  bg.endDraw();
  
  drawGUI();
  
  if (showLive) image(bg, 0, 0);
  if (showPalette) {
    pushMatrix();
    translate(sizeX, 0);
    //palette.draw();
    popMatrix();
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
     palette = new Palette(sizeX, sizeY);
    initSwarm();
  }
  
  if (key=='f' || key=='F') {
    background(255);
    image(bg, 0, 0);
  }
  
  //if (key=='P' || key=='p') palette.draw();

  if (key == 't' || key == 't') {
    for (int i=0; i<agents.length; i++) agents[i].resetAgent();
  }
  if (showGUI) controlP5.getGroup("menu").open();
  else controlP5.getGroup("menu").close();

  if (key=='s' || key=='S') {
    bg.save(timestamp()+".png");
    saveFrame(timestamp()+"-settings.png");
  }
  if (key == DELETE || key == BACKSPACE) background(255);
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", Calendar.getInstance());
}