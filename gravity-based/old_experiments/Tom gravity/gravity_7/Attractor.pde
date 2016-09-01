class Attractor {
  float mass;
  PVector location;
  
  Attractor(float _mass, PVector _location) {
    mass = _mass;
    location = _location;
  }
  
  void draw() {
    ellipse(location.x, location.y, mass, mass);
  }
}