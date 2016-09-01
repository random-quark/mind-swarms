boolean debug = false;
int numParticles = 10000;
int numAttractors = 5;
float G = 5;
float particleMass = 1;
float defaultMass = 5;
Particle[] particles = new Particle[numParticles];
Attractor[] attractors = new Attractor[numAttractors];

void setup() {
  size(500,500);
  background(255);
  for (int i = 0; i < particles.length; i++) {
    PVector startLocation = new PVector(random(width), random(height));
    particles[i] = new Particle(particleMass, startLocation);
  }
  for (int i = 0; i < attractors.length; i++) {
    attractors[i] = new Attractor(defaultMass);
  }
}

void draw() {
  //pushStyle();
  //fill(255,5);
  //rect(0,0,width,height);
  //popStyle();
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