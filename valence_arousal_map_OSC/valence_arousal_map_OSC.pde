String name = "Theo";

/**
 * Start muse-io with the following command :
 *   muse-io --osc osc.udp://localhost:8000
 *   you need to make sure you have oscP5 installed.
 */

import oscP5.*;
import netP5.*;

boolean collecting;
Recorder recorder;
float minValence = 1.0, maxValence = 0.0, realValence = 0.0;

float AL = 0;
float AR = 0;
float valence = 0;
float activation = 0;
float accX, accY, accZ;
float[] alpha_relative = new float[4];
float[] beta_relative = new float[4];
float[] gamma_relative = new float[4];
float[] delta_relative = new float[4];
float[] theta_relative = new float[4];
float[] alpha_absolute = new float[4];
float[] beta_absolute = new float[4];
float[] gamma_absolute = new float[4];
float[] delta_absolute = new float[4];
float[] theta_absolute = new float[4];

float[] electrodes = { 3.0, 3.0, 3.0, 3.0 };

PImage bg;

OscP5 oscP5;
NetAddress remoteAddr;

void setup() {
  size(800, 300);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 8000);
  remoteAddr = new NetAddress("127.0.0.1",7000);
  bg = loadImage("map.jpg");
  recorder = new Recorder();
  background(255);
}

void draw() {
  image(bg, 0, 0, width, height);
  stroke(0);
  fill(0);
  ellipse(valence * width, height - (activation * height), 5, 5);
  
  for (int i=0; i<electrodes.length; i++) {
    drawIndicator(i, electrodes[i]);
  }
  
  if (collecting) {
    recorder.addData(frameCount);
    
    pushStyle();
    fill(255,0,0);
    noStroke();
    ellipse(width / 2, height / 2, 100, 100);
    popStyle();
  }
  pushStyle();
  textSize(50);
  text(name, 0, height - 50);
  popStyle();
 
  oscP5.send("/valence",new Object[] { valence }, remoteAddr);
  oscP5.send("/activation",new Object[] { activation }, remoteAddr);
}

void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/muse/elements/alpha_relative")) {
    alpha_relative[0] = msg.get(0).floatValue();
    alpha_relative[1] = msg.get(1).floatValue();
    alpha_relative[2] = msg.get(2).floatValue();
    alpha_relative[3] = msg.get(3).floatValue();
  }
  if (msg.checkAddrPattern("/muse/elements/beta_relative")) {
    beta_relative[0] = msg.get(0).floatValue();
    beta_relative[1] = msg.get(1).floatValue();
    beta_relative[2] = msg.get(2).floatValue();
    beta_relative[3] = msg.get(3).floatValue();
  } 
  if (msg.checkAddrPattern("/muse/elements/gamma_relative")) {
    gamma_relative[0] = msg.get(0).floatValue();
    gamma_relative[1] = msg.get(1).floatValue();
    gamma_relative[2] = msg.get(2).floatValue();
    gamma_relative[3] = msg.get(3).floatValue();
  }
  if (msg.checkAddrPattern("/muse/elements/delta_relative")) {
    delta_relative[0] = msg.get(0).floatValue();
    delta_relative[1] = msg.get(1).floatValue();
    delta_relative[2] = msg.get(2).floatValue();
    delta_relative[3] = msg.get(3).floatValue();
  }  
  if (msg.checkAddrPattern("/muse/elements/theta_relative")) {
    theta_relative[0] = msg.get(0).floatValue();
    theta_relative[1] = msg.get(1).floatValue();
    theta_relative[2] = msg.get(2).floatValue();
    theta_relative[3] = msg.get(3).floatValue();
  }  
  if (msg.checkAddrPattern("/muse/elements/alpha_absolute")) {
    alpha_absolute[0] = msg.get(0).floatValue();
    alpha_absolute[1] = msg.get(1).floatValue();
    alpha_absolute[2] = msg.get(2).floatValue();
    alpha_absolute[3] = msg.get(3).floatValue();

    AL = msg.get(0).floatValue();
    AR = msg.get(3).floatValue();
    valence = ((AL-AR) + 1) * 0.3;    
    activation = AL + AR;    
  }
  if (msg.checkAddrPattern("/muse/elements/beta_absolute")) {
    beta_absolute[0] = msg.get(0).floatValue();
    beta_absolute[1] = msg.get(1).floatValue();
    beta_absolute[2] = msg.get(2).floatValue();
    beta_absolute[3] = msg.get(3).floatValue();
  } 
  if (msg.checkAddrPattern("/muse/elements/gamma_absolute")) {
    gamma_absolute[0] = msg.get(0).floatValue();
    gamma_absolute[1] = msg.get(1).floatValue();
    gamma_absolute[2] = msg.get(2).floatValue();
    gamma_absolute[3] = msg.get(3).floatValue();

    activation += msg.get(0).floatValue() + msg.get(1).floatValue() + msg.get(2).floatValue() + msg.get(3).floatValue();
    activation /=6;
    activation *=0.8;
    //println(AL + " " + AR + " " + valence + " " + activation);    
  }
  if (msg.checkAddrPattern("/muse/elements/delta_absolute")) {
    delta_absolute[0] = msg.get(0).floatValue();
    delta_absolute[1] = msg.get(1).floatValue();
    delta_absolute[2] = msg.get(2).floatValue();
    delta_absolute[3] = msg.get(3).floatValue();
  }  
  if (msg.checkAddrPattern("/muse/elements/theta_absolute")) {
    theta_absolute[0] = msg.get(0).floatValue();
    theta_absolute[1] = msg.get(1).floatValue();
    theta_absolute[2] = msg.get(2).floatValue();
    theta_absolute[3] = msg.get(3).floatValue();
  }   
  
  if (msg.checkAddrPattern("/muse/acc")) {
    accX = msg.get(0).floatValue();
    accY = msg.get(1).floatValue();
    accZ = msg.get(2).floatValue();
    //println(accX + " " + accY + " " + accZ);
  }

  if (msg.checkAddrPattern("/muse/elements/horseshoe")) {
   for (int i=0; i<electrodes.length; i++) {
     electrodes[i] = msg.get(i).floatValue();
   }
  }
}

void keyPressed() {
  if (key == 'c' || key =='C') {
    println("START collecting data");
    recorder = new Recorder();
    collecting = true;
  }
  if (key == 's' || key == 'S') {
    println("STOP collecting data/save data");
    collecting = false;
    recorder.saveData();
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