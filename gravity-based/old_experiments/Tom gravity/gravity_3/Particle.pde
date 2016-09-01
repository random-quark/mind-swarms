class Particle {
  PVector acceleration, velocity, location, previousLocation;
  float mass;
  float alpha;
  int c;
  
  Particle(float _mass, PVector startLocation) {
    acceleration = new PVector();
    //velocity = new PVector(random(-1, 1), random(-1, 1));
    velocity = new PVector();
    location = startLocation;
    previousLocation = location;
    mass = _mass;
    alpha = 5;
  }
  
  void gravitate(Attractor attractor) {
    PVector force = PVector.sub(attractor.location, location);
    float distance = force.mag();
    distance = constrain(distance, 5.0, 25.0);
    force.normalize();
    float strength = (G * attractor.mass * mass) / (distance * distance);
    force.mult(strength);
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
    stroke(c, alpha);
    line(previousLocation.x, previousLocation.y, location.x, location.y);
    previousLocation = location.copy();
    previousLocation = new PVector(location.x, location.y);
    
    //ellipse(location.x, location.y, 2, 2);
  }
}