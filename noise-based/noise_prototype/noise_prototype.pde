import controlP5.*;
import java.util.Calendar;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.*;

ColorMixer colorMixer;
PImage imagePalette;
boolean usePalette = true, showPalette = true;

boolean EEGNoiseScale = true; //TURN TO TRUE IF USING REAL DATA
int sizeX = 1920; // JUST ADJUST THIS. THE REST WILL FOLLOW
int sizeY = int(float(sizeX)/1.7777);
int margin = 50;
float goldenRatio = float(sizeX)/1920. * 2.;
boolean customBlend=true;

PGraphics bg;
boolean showLive;

String participant_name = "null_name";
String thought_name = "null_thought";

Agent[] agents;
int agentsCount = int(50000*goldenRatio);
int maxAgents = 1600000;
float noiseScale = goldenRatio/2.*250., interAgentNoiseZRange = 0.0, noiseZStep = 0.001;
float noiseScaleMin = 150, noiseScaleMax = 450;
int noiseDet = 4;
float overlayAlpha = 0, agentsAlpha = 20, strokeWidth = 1, maxAngleSpan = 220, noiseStrength = 1;
float randomSeed;
int agentTTL=0;
float minSpeed = 3, maxSpeed = 3;
boolean resetWithError;
float resetStep = 15;
boolean diminishingAlpha;
float alphaDecrement = 0.01;
float randomInitialDirection = 0;//random(360);
String save_destination = "./exports/";
float blendFactor = 0.5;
int paletteScaleFactor = 4;
//float minMarbleBrightness = 0.7;
float[] globalColorData1 = new float[3];
float[] globalColorData2 = new float[3];


Data data;
LinkedList<String> emotionslist = new LinkedList<String>();
LinkedList<Float> emotionspercents = new LinkedList<Float>();
float activationAverage;

color anger = #F5956E;
color joy = #fdec61;
color calm = #ffffff;
color disgust = #b8d183;
color sadness = #78c7d6;
color fear = #3e78ae;
color surprise = #824f93;
color love = #e8686b;

ControlP5 controlP5;
boolean showGUI;
Slider[] sliders;

int autoSaveTimePoint = 120; // in seconds
int autoSaveEndPoint = 180; // in seconds
int autoSaveStep = 20; // in seconds

void setup() {
  println(goldenRatio);
  sizeX+=margin*2;
  sizeY+=margin*2;
  println(sizeX + "  " + sizeY);
  //randomSeed(0);
  //noiseSeed(0);
  data = new Data();
  data.load();
  if (EEGNoiseScale) data.setNoiseScale();
  

  colorMixer = new ColorMixer(emotionslist);

  bg = createGraphics(sizeX, sizeY, P2D);
  bg.beginDraw();
  bg.background(255);
  bg.endDraw();
  frameRate(20);
  //fullScreen(P2D);
  size(1300, 732, P2D);
  background(255);
  imagePalette = loadImage("xPeriod_1.0_yPeriod_1.0_turbPower_2.0_turbSize_133.0_w_500_h_500.png");

  initSwarm();
  setupGUI();
  
  save_destination += participant_name + "/" + thought_name + "/";
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

  background(255);
  drawGUI();

  //if (showLive && frameCount%300==0) image(bg, 0, 0, width, height);
  image(bg, 0, 0, width, height);
  if (showPalette) {
    pushMatrix();
    translate(sizeX, 0);
    //palette.draw();
    popMatrix();
  }

  autoSave();
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
    bg.save(save_destination + timestamp()+".png");
    saveParameters();
    //colorMixer.savePalettes();
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS ", Calendar.getInstance());
}

void saveParameters() {
  String[] parameters={"usePalette " + usePalette, "sizeX " + sizeX, "sizeY " + sizeY, "agentsCount "+agentsCount, "maxAgents "+maxAgents, "noiseScale "+maxAgents, "interAgentNoiseZRange "+interAgentNoiseZRange, 
    "noiseZStep "+noiseZStep, "noiseDet "+noiseDet, "overlayAlpha "+ overlayAlpha, "agentsAlpha "+agentsAlpha, "strokeWidth "+strokeWidth, "maxAngleSpan "+ maxAngleSpan, "noiseStrength "+ noiseStrength, 
    "resetStep "+ resetStep, "randomSeed "+randomSeed, "agentTTL " + agentTTL, "minSpeed "+ minSpeed, "maxSpeed "+maxSpeed, "resetWithError "+resetWithError, "diminishingAlpha "+ diminishingAlpha, 
    "alphaDecrement "+ alphaDecrement, "randomInitialDirection "+ randomInitialDirection, "noiseScaleMin "+noiseScaleMin, "noiseScaleMax "+noiseScaleMax, "blendFactor "+ blendFactor, 
    "paletteScaleFactor "+ paletteScaleFactor, "emotionslist.get(0) "+ emotionslist.get(0), "emotionslist.get(1)"+emotionslist.get(1), "seconds to form: " + millis()/1000, "frameCount to form: " + frameCount, 
    "globalColorData1: " + globalColorData1[0] + ", " + globalColorData1[1] + ", " + globalColorData1[2], "globalColorData2: " + globalColorData2[0] + ", " + globalColorData2[1] + ", " + globalColorData2[2],
    "customBlend: " + customBlend};
    
  File theDir = new File(save_destination);
  theDir.mkdir();
  saveStrings(save_destination+"parameters.txt", parameters);
}

void autoSave()
{
  if ((millis()/1000)%autoSaveTimePoint==0)
  {
    println("saving at: " + millis()/1000);
    bg.save(save_destination + timestamp()+".png");
    saveParameters();
    //colorMixer.savePalettes();
    autoSaveTimePoint+=autoSaveStep;
  }
  if (autoSaveTimePoint>autoSaveEndPoint) {
    exit();
  }
}