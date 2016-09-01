import controlP5.*;

// GUI
ControlP5 controlP5;
boolean showGUI = false;
Slider[] sliders;

// CONSTANTS
boolean debug = false;
int maxParticles = 20000;
int numParticles = 5000;
int numAttractors = 30;
int maxAttractors = 100;
float G = 1;
float particleMass = 10;
float attractorMass = 30;
Particle[] particles = new Particle[maxParticles];
ArrayList<Attractor> attractors = new ArrayList<Attractor>();

PImage imagePalette;

void setup() {
  imagePalette = loadImage("wrangler.jpg");
  size(500,500);
  background(255);
  //attractors.add(new Attractor(1000, new PVector(width/2, height/2)));
  for (int i = 0; i < numAttractors; i++) {
    attractors.add(new Attractor(random(100), new PVector(random(width), random(height))));
  }
  
  for (int i = 0; i < particles.length; i++) {
    int r = (int) random(4);
    PVector startLocation = new PVector();
    switch(r) {
      case 0:
        startLocation = new PVector(random(width),0);
        break;
      case 1:
        startLocation = new PVector(random(width),height);
        break;
      case 2:
        startLocation = new PVector(0, random(height));
        break;
      case 3:
        startLocation = new PVector(width, random(height));
        break;        
    }
    particles[i] = new Particle(particleMass, startLocation);
  }
  
  setupGUI();
}

void draw() {
  //updateCounts();
  
  //pushStyle();
  //fill(255,5);
  //rect(0,0,width,height);
  //popStyle();
  
  //background(255);
  
  if (mousePressed) {
    
  }
  
  for (int i = 0; i < numParticles; i++) {
    for (int j = 0; j < attractors.size(); j++) {
      particles[i].gravitate(attractors.get(j));
    }
    particles[i].update();
    particles[i].draw();
  }
  if (debug) {
    for (int i = 0; i < attractors.size(); i++) {
      attractors.get(i).draw();
    }
  }
  
  drawGUI();
}

void keyReleased(){
  if (key=='m' || key=='M') {
    showGUI = controlP5.getGroup("options").isOpen();
    showGUI = !showGUI;
  }
  if (showGUI) controlP5.getGroup("options").open();
  else controlP5.getGroup("options").close();

  //if (key == '1') drawMode = 1;
  //if (key == '2') drawMode = 2;
  //if (key=='s' || key=='S') saveFrame(timestamp()+".png");
  //if (key == DELETE || key == BACKSPACE) {background(0); agentsAlpha=0;}
}