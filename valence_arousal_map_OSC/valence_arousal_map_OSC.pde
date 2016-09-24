/**
 * Start muse-io with the following command :
 *   muse-io --osc osc.udp://localhost:8000
 *   you need to make sure you have oscP5 installed.
 */

import oscP5.*;
import netP5.*;

float AL = 0;
float AR = 0;
float valence = 0;
float activation = 0;

PImage bg;

OscP5 oscP5;

void setup() {
  size(800, 600);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 8000);
  bg = loadImage("map.jpg");
}


void draw() {
  image(bg, 0, 0, width, height);
  stroke(0);
  fill(0);
  ellipse(valence * width, height - (activation * height), 10, 10);
}

void mousePressed() {
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {

  if (theOscMessage.checkAddrPattern("/muse/elements/alpha_absolute")==true) {

    AL = theOscMessage.get(0).floatValue();
    AR = theOscMessage.get(3).floatValue();
    valence = ((AL-AR) + 1) * 0.3 ;

    activation = AL + AR;
  }

  if (theOscMessage.checkAddrPattern("/muse/elements/gamma_absolute")==true) {

    activation += theOscMessage.get(0).floatValue() + theOscMessage.get(1).floatValue() + theOscMessage.get(2).floatValue() + theOscMessage.get(3).floatValue();
    activation /=6;
    activation *=0.8;

    println(AL + " " + AR + " " + valence + " " + activation);
  }  
  
  if (theOscMessage.checkAddrPattern("/muse/elements/is_good")==true) {
   
    // OK this turns out not to be a good measure
    println("Muse connection is good / bad (1 / 0) " + theOscMessage.get(0).intValue());
    
  }
  
    // this is useful though
    if (theOscMessage.checkAddrPattern("/muse/elements/touching_forehead")==true) {
   
    println("Muse is touching forehead yes / no (1 / 0) " + theOscMessage.get(0).intValue());
    
  }

  /* print the address pattern and the typetag of the received OscMessage */
  //print("### received an osc message.");
  //print(" addrpattern: "+theOscMessage.addrPattern());
  //println(" typetag: "+theOscMessage.typetag());
}