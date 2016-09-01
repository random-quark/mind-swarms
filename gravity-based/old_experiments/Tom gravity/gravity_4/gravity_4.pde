boolean debug = false;
int numParticles = 10000;
int numAttractors = 2;
float G = 0.5;
float particleMass = 1;
float attractorMass = 100;
Particle[] particles = new Particle[numParticles];
Attractor[] attractors = new Attractor[numAttractors];

PImage imagePalette;

void setup() {
  imagePalette = loadImage("wrangler.jpg");
  size(500,500);
  background(255);
  for (int i = 0; i < particles.length; i++) {
    PVector startLocation = new PVector(random(width), random(height));
    particles[i] = new Particle(particleMass, startLocation);
  }
  for (int i = 0; i < attractors.length; i++) {
    attractors[i] = new Attractor(attractorMass);
  }
}

void draw() {
  //pushStyle();
  //fill(255,5);
  //rect(0,0,width,height);
  //popStyle();
  
  //background(255);
  
  for (int i = 0; i < particles.length; i++) {
    for (int j = 0; j < attractors.length; j++) {
      particles[i].gravitate(attractors[j]);
    }
    particles[i].update();
    particles[i].draw();
  }
  if (debug) {
    for (int i = 0; i < attractors.length; i++) {
      attractors[i].draw();
    }
  }
}