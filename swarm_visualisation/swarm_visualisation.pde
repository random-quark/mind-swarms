import controlP5.*;
import java.util.Calendar;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.*;

// Use Processing 3.4 (from July 2018 if possible)
// it does not run properly with later versions. It produces black images

// STEPS
// 1. Modify "IMPORTANT PARAMETERS" section below.
// 2. Make sure it has 5GB of memory in settings.
// 3. Export app
// 4. Move to mind-swarms/automated/ folder
// 5. Choose/create thoughts file (ends with csv)
// 6. Edit batch_command.sh file to accept thought file from step 5
// 7. Make money

// this is now taken care of in the script, but just in case
// TO crop recursively to get rid of perimeter:
// find . -name "*.png" -exec mogrify {} -crop +100+50 +repage -crop -0-50 {} \; 

ColorMixer colorMixer;
PImage imagePalette;
boolean usePalette = true, showPalette = true;

//IMPORTANT PARAMETERS
float templateX = 1920.;
//float ratioY = 1.414285714;
float ratioY = 1.777777;
//int sizeX = int(1920*3.2);
int sizeX = 1920;

int autoSaveTimePoint = int(60); // in seconds
int autoSaveEndPoint = int(121); // in seconds
int autoSaveStep = int(30); // in seconds

boolean useHash = false; // true: uses hash - false: generates random each time
int backgroundColor = 255;
boolean hideGUI = true;

// participant-related data
boolean state = false; // happy (true) vs. sad (false)
String participant_name = "Georgia Tucker";
String thought_name = "Doing hand stands on bolivia salt flats"; //also used to generate unique hash for emotion

Patch patch;
boolean patched = true;

int paletteScaleFactor = 2;
int margin = 50;
int agentsCount = int(50000);
boolean customBlend=true; //false = DARK blend

// biz cards? (confirm)
//float templateX = 1920.;
//float ratioY = 1.77777777777777;
//int sizeX = 1920;
//int paletteScaleFactor = 2;
//int agentsCount = int(75000);

boolean EEGNoiseScale = false; //TURN TO TRUE IF USING EEG DATA from FILE (I generated mine at FALSE setting)
int sizeY = int(float(sizeX)/ratioY);
float goldenRatio = (float(sizeX)/templateX) * (float(sizeY)/(templateX/ratioY));
float blendFactor = 0.5;
float noiseScale = (sqrt(goldenRatio) * 300.); //divided by 2 because noisescale is really in one dimension. It's not an WxH relationship.
long Rseed = 1000;
long Nseed = 20000;
boolean allowRandomness=true;
float strokeWidth = 1;

Agent[] agents;
int maxAgents = 50000;

PGraphics bg;
boolean showLive;

float interAgentNoiseZRange = 0.0, noiseZStep = 0.001;
float noiseScaleMin = 150, noiseScaleMax = 450;
int noiseDet = 4;
float overlayAlpha = 0, agentsAlpha = 20, maxAngleSpan = 220, noiseStrength = 1;
float randomSeed;
int agentTTL=0;
float minSpeed = 3, maxSpeed = 3;
boolean resetWithError;
float resetStep = 15;
boolean diminishingAlpha;
float alphaDecrement = 0.01;
float randomInitialDirection = 0;//random(360);
String save_destination = "./exports/";
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

void setup() {
  println("Golden Ratio: " + goldenRatio);
  println("noise scale: " + noiseScale);
  println("agentsCount: " + agentsCount);

  sizeX+=margin*2;
  sizeY+=margin*2;
  println(sizeX + "  " + sizeY);
  if (allowRandomness==false) {
    randomSeed(Rseed);
    noiseSeed(Nseed);
    println("WARNING: not using randomness");
  }
  if (patched) {
    patch = new Patch();
    patch.load(state);
  } else {
    data = new Data();
    data.load();
  }
  if (EEGNoiseScale) data.setNoiseScale();

  print("generating colorMixer ");
  colorMixer = new ColorMixer(emotionslist, sizeX/paletteScaleFactor, sizeY/paletteScaleFactor);
  println("done");

  bg = createGraphics(sizeX, sizeY, P2D);
  println("created graphics");
  bg.beginDraw();
  bg.background(backgroundColor);
  bg.endDraw();
  //frameRate(20); // WHY IS THIS HERE?
  //fullScreen(P2D);
  size(1200, 675, P2D);
  background(255);
  imagePalette = loadImage("xPeriod_1.0_yPeriod_1.0_turbPower_2.0_turbSize_133.0_w_500_h_500.png");
  initSwarm();
  println("initialised swarm");
  if (!hideGUI) setupGUI();
  println("prepared gui");

  save_destination += participant_name + "/" + thought_name + "/";
  //colorMixer.savePalettes();
  //exit();
  println("exited setup function");

  saveParameters();
  colorMixer.savePalettes();
}

void draw() {
  bg.beginDraw();
  //bg.background(255);
  bg.fill(255, overlayAlpha);
  bg.noStroke();
  bg.rect(0, 0, width, height);
  pushStyle();
  for (int i=0; i<agentsCount; i++) agents[i].update();
  popStyle();
  noiseDetail(noiseDet);
  bg.endDraw();

  background(255);
  if (!hideGUI) drawGUI();

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
    print("saving image...");
    //bg.save(save_destination + timestamp()+"_manual.png");
    bg.save(save_destination + timestamp()+emotionslist.get(0)+"_"+emotionslist.get(1)+"_manual.png");
    saveParameters();
    colorMixer.savePalettes();
    println("DONE");
  }
}

String timestamp() {
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS ", Calendar.getInstance());
}

void saveParameters() {
  String[] parameters={"usePalette " + usePalette, "sizeX " + sizeX, "sizeY " + sizeY, "agentsCount "+agentsCount, "maxAgents "+maxAgents, "noiseScale "+noiseScale, "interAgentNoiseZRange "+interAgentNoiseZRange, 
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
    bg.save(save_destination + timestamp()+emotionslist.get(0)+"_"+emotionslist.get(1)+".png");
    saveParameters();
    colorMixer.savePalettes();
    autoSaveTimePoint+=autoSaveStep;
  }
  if (autoSaveTimePoint>autoSaveEndPoint) {
    exit();
  }
}
