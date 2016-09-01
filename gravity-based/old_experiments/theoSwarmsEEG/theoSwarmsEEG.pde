/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/27564*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//This program is an alteration of "Gravity Swarm" by Claudio Gonzalez.
//Credit goes to him for all of the particle behavioral properties and the base orbiting factor
//Edits to the behavior of the orbital properties, color/distance interaction and gravity factor alterations by Basil Vendryes. Make sure to check out the original "Gravity Swarm" however, as it is a spectacular and inspirational work.

import netP5.*;
import oscP5.*;

OscP5 osc;

float driftX;
float driftY;
float randX = random(-50, 50);
float randY = random(-50, 50);

particle[] Z = new particle[10000];
float colour = random(1);
float xoff = random(15000);
PImage imagePalette;

float beta, mellow, concentration;

void oscEvent(OscMessage msg) {
  switch(msg.addrPattern()) {
    case "/muse/elements/experimental/concentration":
      concentration = msg.get(0).floatValue();
      break;
    case "/muse/elements/experimental/mellow":
      println(msg.get(0).floatValue());
      mellow = msg.get(0).floatValue();
      break;
    case "/muse/elements/beta_absolute":
      beta = msg.get(0).floatValue();
      break;    
  }
}

void setup() {
  osc = new OscP5(this,5000);
  size(800, 800, P2D); 
  imagePalette = loadImage("wrangler.jpg");
  background(255);
  driftX = random(width);
  driftY = random(height);

  for (int i = 0; i < Z.length; i++) {
    Z[i] = new particle( random(width), random(height), 0, 0, 1 );
  }

  frameRate(60);
  colorMode(HSB, 255);
}

void draw() {
  if (frameCount%50==0) {
    randX = random(-50, 50);
    randY = random(-50, 50);
  }

  //noise method A
  //float finalX = map(noise(xoff), 0, 1, -50, width+50) + randX;
  //float finalY = map(noise(xoff+44.3), 0, 1, -50, height+50) + randY;

  //EEG method
  float finalX = map(mellow, 0, 1, -50, width+50);
  float finalY = map(concentration, 0, 1, -50, height+50);

  //noise method B (more realistic
  //driftX += map(noise(xoff), 0, 1, -4, 4);
  //driftY += map(noise(xoff+44.3), 0, 1, -4, 4);
  //if (driftX>width) driftX=0;
  //if (driftX<0) driftX=width;
  //if (driftY>height) driftY=0;
  //if (driftY<0) driftY=height;
  //float finalX = driftX + randX;
  //float finalY = driftY + randY;

  particle gravitron = new particle( finalX, finalY, 0, 0, .6 );

  for (int i = 0; i < Z.length; i++) {
    if ( mousePressed && mouseButton == LEFT ) {
      finalX = mouseX+randX;
      finalY = mouseY+randY;
      Z[i].gravitate( new particle( finalX, finalY, 0, 0, 2 ) );
    } else {

      Z[i].gravitate( gravitron );


      //Z[i].deteriorate();
    }
    Z[i].update();
    Z[i].display();
  }

  xoff+=0.007;
  //pushStyle();
  //fill(0);
  //ellipse(finalX, finalY, 10, 10);
  //popStyle();
  
  pushMatrix();
  pushStyle();
  fill(0);
  rect(0,0,250,50);
  translate(10,10);
  fill(255);
  text("mellow: " + mellow, 0, 0);
  text("concentration: " + concentration, 0, 15);
  text("beta: " + beta, 0, 30);
  popStyle();
  popMatrix();
}