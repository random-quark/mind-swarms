/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/27564*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
//This program is an alteration of "Gravity Swarm" by Claudio Gonzalez.
//Credit goes to him for all of the particle behavioral properties and the base orbiting factor
//Edits to the behavior of the orbital properties, color/distance interaction and gravity factor alterations by Basil Vendryes. Make sure to check out the original "Gravity Swarm" however, as it is a spectacular and inspirational work.
float driftX;
float driftY;
float randX = random(-50, 50);
float randY = random(-50, 50);

particle[] Z = new particle[10000];
float colour = random(1);
float xoff = random(15000);
PImage imagePalette;

void setup() {
  size(800, 800, P2D); 
  imagePalette = loadImage("wrangler.jpg");
  background(255);
  driftX = random(width);
  driftY = random(height);

  for (int i = 0; i < Z.length; i++) {
    Z[i] = new particle( random(width), random(height), 0, 0, random(0.2, 1) ); // INTERESTING RESULTS WHEN USING random(0.2, 1) for mass
  }

  frameRate(60);
  colorMode(RGB, 255);
}

void draw() {

  //  stroke(0);
  //  fill(255,5);
  //  rect(0,0,width,height);

  if (frameCount%8==0) {
    randX = random(-30, 30);
    randY = random(-30, 30);
  }

  //noise method A
  float finalX = map(noise(xoff), 0, 1, -50, width+50) + randX;
  float finalY = map(noise(xoff+44.3), 0, 1, -50, height+50) + randY;

  particle gravitron = new particle( finalX, finalY, 0, 0, 2 );

  for (int i = 0; i < Z.length; i++) {
    if ( mousePressed && mouseButton == LEFT ) {
      Z[i].gravitate( new particle( mouseX+randX, mouseY+randY, 0, 0, 2 ) );
    } else {

      Z[i].gravitate( gravitron );

      //there was code to detereorate particles here
      // look at git history or online example if you need it
    }
    Z[i].update();
    Z[i].display();
  }

  xoff+=0.004;
}