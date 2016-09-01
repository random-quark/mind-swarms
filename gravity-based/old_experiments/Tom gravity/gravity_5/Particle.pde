class Particle {
  PVector acceleration, velocity, location, previousLocation;
  float mass;
  float alpha;
  int agentColor;
  
  Particle(float _mass, PVector startLocation) {
    acceleration = new PVector();
    //velocity = new PVector(random(-1, 1), random(-1, 1));
    velocity = new PVector();
    location = startLocation;
    previousLocation = location;
    mass = _mass;
    alpha = 10;
    
    int x = (int)(location.x/width*1280.0);
    int y = (int)(location.y/height*853.0);
    agentColor = imagePalette.get(x, y);    
  }
  
  void gravitate(Attractor attractor) {
    PVector force = PVector.sub(attractor.location, location);
    float distance = force.mag();
    distance = constrain(distance, 5.0, 500.0);
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
    //fill(agentColor, alpha);
    stroke(agentColor, alpha);
    strokeWeight(0.1);
    line(previousLocation.x, previousLocation.y, location.x, location.y);
    previousLocation = location.copy();
    previousLocation = new PVector(location.x, location.y);
    
    //ellipse(location.x, location.y, 2, 2);
  }
}