class Particle {
  PVector acceleration, velocity, location, previousLocation;
  float mass;
  int alpha;
  int c;
  
  Particle(float _mass, PVector startLocation) {
    acceleration = new PVector();
    velocity = new PVector();
    location = startLocation;
    previousLocation = location;
    mass = _mass;
    alpha = 10;
  }
  
  void gravitate(Attractor attractor) {
    PVector force = PVector.sub(attractor.location, location);
    float distance = force.mag();
    float m = (G * mass * attractor.mass) / (distance * distance);
    force.normalize();
    force.mult(m);
    applyForce(force);
  }
  
  void applyForce(PVector force) {
    PVector calculatedForce = PVector.div(force, mass);
    acceleration.add(calculatedForce);
  }
  
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void draw() {
    fill(c, alpha);
    stroke(c, 1);
    point(location.x, location.y);
    line(previousLocation.x, previousLocation.y, location.x, location.y);
    previousLocation = location;
  }
}