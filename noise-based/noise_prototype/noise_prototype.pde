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
import java.util.Iterator;
import java.util.LinkedList;
import java.util.*;

ColorMixer colorMixer;
PImage imagePalette;
int numCircles = 1;
boolean usePalette = true, showPalette = true;

PGraphics bg;
int scalingFactor = 1;
int sizeX = 1300*scalingFactor;
int sizeY = 800*scalingFactor;
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
float noiseScaleMin = 150, noiseScaleMax = 250;

Data data;
LinkedList<String> emotionslist = new LinkedList<String>();
float activationAverage;

color anger = #F5956E;
color joy = #fdec61;
color calm = #ffffff;
color disgust = #b8d183;
color sadness = #78c7d6;
color fear = #3e78ae;
color surprise = #824f93;
color love = #e8686b;

Map emotionscolors;

ControlP5 controlP5;
boolean showGUI;
Slider[] sliders;

void setup() {
  randomSeed(0);
  noiseSeed(0);
  data = new Data();
  data.load();
  data.setNoiseScale();
  
  colorMixer = new ColorMixer(emotionslist);

  bg = createGraphics(sizeX, sizeY, P2D);
  bg.beginDraw();
  bg.background(255);
  bg.endDraw();
  frameRate(20);
  //fullScreen(P2D);
  size(1300, 800, P2D);
  background(255);
  imagePalette = loadImage("xPeriod_1.0_yPeriod_1.0_turbPower_2.0_turbSize_133.0_w_500_h_500.png");

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

  //if (showLive && frameCount%30==0) image(bg, 0, 0, width, height);
  image(bg, 0, 0, width, height);
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
    //palettes[0] = new Palette(sizeX, sizeY, fear);
    //palettes[1] = new Palette(sizeX, sizeY, joy);
    initSwarm();
  }

  if (key=='f' || key=='F') {
    background(255);
    image(bg, 0, 0);
  }

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