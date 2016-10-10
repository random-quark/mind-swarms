import controlP5.*;

/**
 * Start muse-io with the following command :
 *   muse-io --osc osc.udp://localhost:8000
 *   you need to make sure you have oscP5 installed.
 */

import oscP5.*;
import netP5.*;

ControlP5 controlP5;
boolean showGUI, record, calibrate, saveData, adjustData;
Recorder recorder;
float minValence = 1.0, maxValence = 0.0, realValence = 0.0;

float AL = 0;
float AR = 0;
float valence = 0;
float activation = 0;
float accX, accY, accZ;

float[] electrodes = { 3.0, 3.0, 3.0, 3.0 };

PImage bg;

OscP5 oscP5;
NetAddress remoteAddr;

void setup() {
  setupGUI();
  size(800, 650);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 8000);
  remoteAddr = new NetAddress("127.0.0.1",7000);
  bg = loadImage("map.jpg");
  recorder = new Recorder();
}


void draw() {
  image(bg, 0, 0, width, height);
  stroke(0);
  fill(0);
  ellipse(valence * width, height - (activation * height), 10, 10);
  
  for (int i=0; i<electrodes.length; i++) {
    drawIndicator(i, electrodes[i]);
  }
  
  drawGUI();
  
  if (record) {
    recorder.addData(frameCount, valence, activation);
  }
  if (calibrate) {
    minValence = min(valence, minValence);
    maxValence = max(valence, maxValence);
  }  
  if (saveData) {
    recorder.saveData();
    saveData = false;
    record = false;
  }
  
  int posY = 10;
  int posX = 150;
  text("minValence: " + minValence, width - posX, posY);
  posY += 10;
  text("maxValence: " + maxValence, width - posX, posY);
  posY += 10;
  text("realValence: " + realValence, width - posX, posY);  
  posY += 10;
  text("adjustedValence: " + valence, width - posX, posY);    
  
  oscP5.send("/valence",new Object[] { valence }, remoteAddr);
  oscP5.send("/activation",new Object[] { activation }, remoteAddr);
}

void mousePressed() {
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  if (theOscMessage.checkAddrPattern("/muse/elements/alpha_absolute")==true) {

    AL = theOscMessage.get(0).floatValue();
    AR = theOscMessage.get(3).floatValue();
    
    
    valence = ((AL-AR) + 1) * 0.3;
    //valence = (AL-AR) + 1;
    
    realValence = valence;
    if (adjustData) {
      valence = map(valence, minValence, maxValence, 0, 1);
    }

    activation = AL + AR;
  }
  
  if (theOscMessage.checkAddrPattern("/muse/acc")==true) {

    accX = theOscMessage.get(0).floatValue();
    accY = theOscMessage.get(1).floatValue();
    accZ = theOscMessage.get(2).floatValue();
    println(accX + " " + accY + " " + accZ);
  }

  if (theOscMessage.checkAddrPattern("/muse/elements/gamma_absolute")==true) {

    activation += theOscMessage.get(0).floatValue() + theOscMessage.get(1).floatValue() + theOscMessage.get(2).floatValue() + theOscMessage.get(3).floatValue();
    activation /=6;
    activation *=0.8;

    //println(AL + " " + AR + " " + valence + " " + activation);
  }  
  
  if (theOscMessage.checkAddrPattern("/muse/elements/is_good")==true) {
   
    // OK this turns out not to be a good measure
    //println("Muse connection is good / bad (1 / 0) " + theOscMessage.get(0).intValue());
    
  }
  
    // this is useful though
    if (theOscMessage.checkAddrPattern("/muse/elements/touching_forehead")==true) {
   
    //println("Muse is touching forehead yes / no (1 / 0) " + theOscMessage.get(1).intValue());
    
  }
  
  if (theOscMessage.checkAddrPattern("/muse/elements/horseshoe")) {
   for (int i=0; i<electrodes.length; i++) {
     electrodes[i] = theOscMessage.get(i).floatValue();
   }
  }
}

void drawIndicator(int position, float value) {
  float inverseStrength = map(value, 1, 3, 0, 1);
  color c = lerpColor(color(0,255,0), color(255,0,0), inverseStrength);
  pushStyle();
  fill(c);
  rect(position * (width/4), 0, width/4, 75);
  popStyle();
}