class Attractor {
  float mass;
  PVector location;
  
  Attractor(float _mass) {
    mass = _mass;
    location = new PVector(random(width), random(height));
  }
  
  void draw() {
    ellipse(location.x, location.y, mass, mass);
  }
}