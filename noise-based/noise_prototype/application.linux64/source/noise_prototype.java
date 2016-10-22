import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import java.util.Calendar; 
import java.util.Iterator; 
import java.util.LinkedList; 
import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class noise_prototype extends PApplet {







ColorMixer colorMixer;
PImage imagePalette;
boolean usePalette = true, showPalette = true;

PGraphics bg;
int sizeX = 2020;
int sizeY = 1180;
boolean showLive;

String participant_name = "null_name";
String thought_name = "null_thought";

Agent[] agents;
int agentsCount = 50000;
int maxAgents = 1000000;
float noiseScale = 250, interAgentNoiseZRange = 0.0f, noiseZStep = 0.001f;
float noiseScaleMin = 150, noiseScaleMax = 250;
int noiseDet = 4;
float overlayAlpha = 0, agentsAlpha = 20, strokeWidth = 1, maxAngleSpan = 220, noiseStrength = 1;
float randomSeed;
int agentTTL=0;
float minSpeed = 3, maxSpeed = 3;
boolean resetWithError;
float resetStep = 15;
boolean diminishingAlpha;
float alphaDecrement = 0.01f;
float randomInitialDirection = 0;//random(360);
String save_destination = "./exports/";
float blendFactor = 0.5f;
int paletteScaleFactor = 4;
//float minMarbleBrightness = 0.7;
float[] globalColorData1 = new float[3];
float[] globalColorData2 = new float[3];
boolean customBlend=true;

Data data;
LinkedList<String> emotionslist = new LinkedList<String>();
LinkedList<Float> emotionspercents = new LinkedList<Float>();
float activationAverage;

int anger = 0xffF5956E;
int joy = 0xfffdec61;
int calm = 0xffffffff;
int disgust = 0xffb8d183;
int sadness = 0xff78c7d6;
int fear = 0xff3e78ae;
int surprise = 0xff824f93;
int love = 0xffe8686b;

ControlP5 controlP5;
boolean showGUI;
Slider[] sliders;

int autoSaveTimePoint = 120; // in seconds
int autoSaveEndPoint = 180; // in seconds
int autoSaveStep = 20; // in seconds

public void setup() {
  //randomSeed(0);
  //noiseSeed(0);
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
  
  background(255);
  imagePalette = loadImage("xPeriod_1.0_yPeriod_1.0_turbPower_2.0_turbSize_133.0_w_500_h_500.png");

  initSwarm();
  setupGUI();
  
  save_destination += participant_name + "/" + thought_name + "/";
}

public void draw() {
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

public void initSwarm() {
  pushStyle();
  randomSeed = random(1000);
  agents = new Agent[maxAgents]; // create more ... to fit max slider agentsCount
  for (int i=0; i<agents.length; i++) agents[i] = new Agent();
  popStyle();
}

public void keyReleased() {
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

public String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS ", Calendar.getInstance());
}

public void saveParameters() {
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

public void autoSave()
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
// M_1_5_03_TOOL.pde
// Agent.pde, GUI.pde

class Agent {
  PVector p, pOld, pOriginal;
  float noiseZ = 0;
  float stepSize, angle;
  float alpha;
  int agentColor;
  int startMillis;
  float remainderPercent;
  float tempAlpha=20;
  
  int width = bg.width;
  int height = bg.height;

  Agent() {
    p = new PVector(random(width), random(height));
    pOriginal = new PVector(p.x, p.y);
    pOld = new PVector(p.x, p.y);
    stepSize = random(minSpeed, maxSpeed);
    startMillis = millis();
    noiseZ = random(interAgentNoiseZRange);
    setColor();
  }

  public void update() {
    if (agentTTL>0) {
      if (((millis()-startMillis)) > agentTTL) {
        resetAgent();
      }
    }

    float noiseVal = noise(p.x/noiseScale + randomSeed, p.y/noiseScale  + randomSeed, noiseZ  + randomSeed);
    angle = map(noiseVal, 0, 1, -1, 1);
    angle = (angle * radians(maxAngleSpan) * noiseStrength) + randomInitialDirection;

    p.x += cos(angle) * stepSize; //stepSize is the speed
    p.y += sin(angle) * stepSize;

    if (p.x<0 || p.x>width || p.y<0 || p.y>height) resetAgent();

    bg.stroke(agentColor);
    bg.strokeWeight(strokeWidth);
    bg.line(pOld.x, pOld.y, p.x, p.y);

    pOld.set(p);
    noiseZ += noiseZStep;

    if (diminishingAlpha) { 
      tempAlpha -= .1f;
      if (tempAlpha<1) {
        resetAgent();
      } else {
        colorMode(RGB, 255);
        agentColor = color(red(agentColor), green(agentColor), blue(agentColor), tempAlpha);
      }
    }
  }

  public void resetAgent() {
    startMillis = millis();
    if (resetWithError) {
      p.x = pOld.x = constrain(pOriginal.x + (int)random(resetStep*2)-resetStep, 0, width);
      p.y = pOld.y = constrain(pOriginal.y + (int)random(resetStep*2)-resetStep, 0, height);      
    } else {
      p.x = pOld.x = (int)random(width);
      p.y = pOld.y = (int)random(height);
    }
    setColor();
  }

  public void setColor() {
    int c=color(0); //remove 0 when done;
    tempAlpha = agentsAlpha;
    alpha = agentsAlpha;
    if (usePalette) {
      c = colorMixer.getColor((int) p.x, (int) p.y);
    } else {
      int x = (int)constrain(p.x/width*imagePalette.width, 0, imagePalette.width);
      int y = (int)constrain(p.y/height*imagePalette.height, 0, imagePalette.height);
      c = imagePalette.get(x, y);
    }
    colorMode(RGB,255);
    agentColor = color(red(c), green(c), blue(c), alpha);
  }
}
class ColorMixer {
  float[] angerData = new float[] {19, 0.05f, 0.9f}; // ORANGE
  float[] joyData = new float[] {55, 0.02f, 0.9f};  //YELLOW
  float[] calmData = new float[] {0, 0.1f, 0.8f}; // WHITE
  float[] disgustData = new float[] {162, 0.1f, 0.8f}; // DISGUST
  float[] sadnessData = new float[] {190, 0.1f, 0.8f}; // LIGHT BLUE
  float[] fearData = new float[] {210, 0.1f, 0.8f}; // BLUE
  float[] surpriseData = new float[] {285, 0.1f, 0.65f}; // PURPLE
  float[] loveData = new float[] {0, 0.1f, 0.8f}; // RED

  PGraphics mixedVbo;
  Palette[] palettes;
  Map<String, float[]> emotionsData;

  ColorMixer(LinkedList<String> emotionslist) {
    //pushStyle();
    //colorMode(HSB, 1);

    emotionsData = new HashMap<String, float[]>();
    emotionsData.put("anger", angerData);
    emotionsData.put("joy", joyData);
    emotionsData.put("calm", calmData);
    emotionsData.put("disgust", disgustData);
    emotionsData.put("sadness", sadnessData);
    emotionsData.put("fear", fearData);
    emotionsData.put("surprise", surpriseData);
    emotionsData.put("love", loveData);

    mixedVbo = createGraphics(sizeX, sizeY, P2D);

    float[] colorData1 =  emotionsData.get(emotionslist.get(0));
    float[] colorData2 =  emotionsData.get(emotionslist.get(1));
    globalColorData1 = colorData1;
    globalColorData2 = colorData2;

    println(emotionslist.get(0), emotionslist.get(1));

    palettes = new Palette[2];
    palettes[0] = new Palette(sizeX, sizeY, colorData1);
    palettes[1] = new Palette(sizeX, sizeY, colorData2);

    createMixedPalette();

    mixedVbo.loadPixels();
  }

  public int getColor(int x, int y) {
    int c = mixedVbo.pixels[y * mixedVbo.width + x];
    return c;
  }

  public void createMixedPalette() {
    pushStyle();
    colorMode(HSB, 1);
    int c1, c2, c;
    mixedVbo.beginDraw();
    for (int x=0; x<sizeX; x++) {
      for (int y=0; y<sizeY; y++) {
        c1 = palettes[0].getColor(x, y);
        c2 = palettes[1].getColor(x, y);
        c = mixColors(c1, c2);
        mixedVbo.stroke(c);
        mixedVbo.point(x, y);
      }
    }
    mixedVbo.endDraw();
    popStyle();
  }

  public int mixColors(int c1, int c2) {
    if (customBlend) {
      if (saturation(c1)<saturation(c2)*blendFactor) return c2;
      else return c1;
    } else return blendColor(c1, c2, DARKEST);
  }

  public void savePalettes() {
    palettes[0].marbleVbo.save(save_destination+"marble01.png");
    palettes[1].marbleVbo.save(save_destination+"marble02.png");
    palettes[0].huesVbo.save(save_destination+"hues01.png");
    palettes[1].huesVbo.save(save_destination+"hues02.png");
    mixedVbo.save(save_destination+"mixedVbo.png");
  }
}
class Data {
  Table data;
  Data() {
  }
  
  public void load() {
    data = loadTable("data.csv", "csv");
    for (TableRow row : data.rows()) {
      println(row);
      emotionslist.add(row.getString(0));
      String percentCol = row.getString(1);
      if (percentCol != null && !percentCol.isEmpty()) {
        float percent = Float.valueOf(percentCol);
        emotionspercents.add(percent);
      }
    }
    participant_name = emotionslist.pollLast();
    thought_name = emotionslist.pollLast();
    activationAverage = Float.valueOf(emotionslist.pollLast());
  }
  
  public void setNoiseScale() {
    noiseScale = map(activationAverage, 0, 1, noiseScaleMax, noiseScaleMin);
  }
}
// M_1_5_03_TOOL.pde
// Agent.pde, GUI.pde

public void setupGUI() {
  int activeColor = color(0, 130, 164);
  controlP5 = new ControlP5(this);
  //controlP5.setAutoDraw(false);
  controlP5.setColorActive(activeColor);
  controlP5.setColorBackground(color(170));
  controlP5.setColorForeground(color(50));
  controlP5.setColorCaptionLabel(color(50));
  controlP5.setColorValueLabel(color(255));

  ControlGroup ctrl = controlP5.addGroup("menu", 15, 25, 35);
  ctrl.setColorLabel(color(255));
  ctrl.close();

  sliders = new Slider[15];

  int left = 0;
  int top = 5;
  int len = 300;

  int si = 0;
  int posY = top;

  sliders[si++] = controlP5.addSlider("agentsCount", 1, maxAgents, left, posY, len, 15);

  posY += 30;
  sliders[si++] = controlP5.addSlider("noiseScale", 1, 1000, left, posY, len, 15);
  posY+=20;
  sliders[si++] = controlP5.addSlider("noiseDet", 1, 15, left, posY, len, 15);
  posY+=20;  
  sliders[si++] = controlP5.addSlider("maxAngleSpan", 0, 360, left, posY, len, 15);
  posY+=20;  
  sliders[si++] = controlP5.addSlider("agentTTL", 0, 50000, left, posY, len, 15);
  posY+=20;
  sliders[si++] = controlP5.addSlider("strokeWidth", 0, 10, left, posY, len, 15);

  posY += 30;
  sliders[si++] = controlP5.addSlider("interAgentNoiseZRange", 0, 1, left, posY, len, 15);
  posY+=20;
  sliders[si++] = controlP5.addSlider("noiseZStep", 0, 0.01f, left, posY, len, 15);
  posY += 20;
  sliders[si++] = controlP5.addSlider("noiseStrength", 0, 1, left, posY, len, 15);

  posY += 30;
  sliders[si++] = controlP5.addSlider("agentsAlpha", 0, 255, left, posY, len, 15);
  posY += 20;
  sliders[si++] = controlP5.addSlider("overlayAlpha", 0, 255, left, posY, len, 15);

  posY += 30;
  sliders[si++] = controlP5.addSlider("minSpeed", 0, 20, left, posY, len, 15);
  posY += 20;
  sliders[si++] = controlP5.addSlider("maxSpeed", 0, 20, left, posY, len, 15);

  posY += 30;
  sliders[si++] = controlP5.addSlider("numCircles", 0, 100, left, posY, len, 15);

  posY += 30;
  Toggle stroke = controlP5.addToggle("diminishingAlpha")
    .setPosition(0, posY)
    .setSize(50, 20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    ;
  stroke.setGroup(ctrl);

  posY+=40;
  Toggle usePalette = controlP5.addToggle("usePalette")
    .setPosition(0, posY)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;
  usePalette.setGroup(ctrl);  

  posY+=40;
  Toggle palette = controlP5.addToggle("showPalette")
    .setPosition(0, posY)
    .setSize(50, 20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    ;
  palette.setGroup(ctrl);  

  posY+=40;
  Toggle reseterror = controlP5.addToggle("resetWithError")
    .setPosition(0, posY)
    .setSize(50, 20)
    .setValue(false)
    .setMode(ControlP5.SWITCH)
    ;
  reseterror.setGroup(ctrl);   

  posY+=40;
  Toggle showLive = controlP5.addToggle("showLive")
    .setPosition(0, posY)
    .setSize(50, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;
  showLive.setGroup(ctrl);     

  for (int i = 0; i < si; i++) {
    sliders[i].setGroup(ctrl);
    sliders[i].setId(i);
    sliders[i].getCaptionLabel().toUpperCase(false);
    sliders[i].getCaptionLabel().getStyle().padding(4, 3, 3, 3);
    sliders[i].getCaptionLabel().getStyle().marginTop = -4;
    sliders[i].getCaptionLabel().getStyle().marginLeft = 0;
    sliders[i].getCaptionLabel().getStyle().marginRight = -14;
    sliders[i].getCaptionLabel().setColorBackground(0x99ffffff);
  }
}

public void drawGUI() {
  controlP5.show();
  controlP5.draw();
}
class Palette {
  int palWidth, palHeight;

  float xPeriod=1.f;     // how many lines on the X axis
  float yPeriod = 1.f;   // how many lins on the Y axis
  float turbPower = 2.0f; // how much turbulence
  float turbSize = 170;  // noise zoom in factor
  int c;
  PGraphics marbleVbo, huesVbo;
  float hueOffset = random(10000);
  float hueRange = 0.1f;
  float noiseStep = 0.005f;
  float minMarbleBrightness = 0;
  float randomXoffset, randomYoffset;


  Palette(int _width, int _height, float[] colorData) {
    noiseSeed((int)random(1000));
    noiseDetail(10);
    pushStyle();
    colorMode(HSB, 360);
    c = color(colorData[0], 100, 100);
    hueRange = colorData[1];
    minMarbleBrightness = colorData[2];
    randomXoffset = (int)random(1000);
    randomYoffset = (int)random(1000);

    palWidth= _width / paletteScaleFactor;
    palHeight = _height / paletteScaleFactor;
    createMarble();
    createHues();
    popStyle();
  }

  public int getColor(int _x, int _y) {
    pushStyle();
    colorMode(HSB, 1);
    int x = constrain(_x / paletteScaleFactor, 0, palWidth-1);
    int y = constrain(_y / paletteScaleFactor, 0, palHeight-1);
    int hue = huesVbo.pixels[y * huesVbo.width + x];
    int marble = marbleVbo.pixels[y * marbleVbo.width + x];
    popStyle();
    return color(hue(hue), saturation(marble), brightness(marble));
  }

  public void createHues() {
    huesVbo = createGraphics(palWidth, palHeight, P2D);
    huesVbo.beginDraw();
    huesVbo.colorMode(HSB, 1);
    for (int x=0; x<palWidth; x++) {
      float hue = huesVbo.hue(c) + map(noise(hueOffset), 0, 1, -hueRange, hueRange);
      if (hue<0) hue+=1;
      huesVbo.stroke(hue, 1, 1);
      huesVbo.line(x, 0, x, palHeight);
      hueOffset+=noiseStep;
    }
    huesVbo.endDraw();
    huesVbo.loadPixels();
  }

  public void createMarble() {
    pushStyle();
    marbleVbo = createGraphics(palWidth, palHeight, P2D);
    marbleVbo.beginDraw();
    marbleVbo.background(255);

    colorMode(HSB, 1);        // FIX ME!!! THIS SHOULD NOT BE HERE!!!! MAYBE A PUSHSTYLE INTHIS FUNCTION?????
    for (int x=0; x<palWidth; x++) {
      for (int y=0; y<palHeight; y++) {
        float xyValue = (x+randomXoffset) * xPeriod / palWidth + (y+randomYoffset) * yPeriod / palHeight + turbPower * noise(x/turbSize, y/turbSize);
        float sineValue = abs(sin(xyValue * 3.14159f));
        int tempColor = color(0, 1-sineValue, map(sineValue, 0, 1, minMarbleBrightness, 1));
        marbleVbo.stroke(tempColor);
        marbleVbo.point(x, y);
      }
    }
    marbleVbo.endDraw();
    marbleVbo.loadPixels();
    popStyle();
  }
}
  public void settings() {  size(1300, 800, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "noise_prototype" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
