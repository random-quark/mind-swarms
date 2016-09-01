class PPoint {

  int index;
  PVector birthLoc;
  PVector lastLoc;
  PVector loc;
  PVector acc;
  PVector vel;
  float maxVel;
  float minVel = .5;
  float mass;
  float grav = -9.8;
  float damp = .96;
  float spike = 0;
  
  float x;
  float y;
  float lastX;
  float lastY;
  
  

  PPoint(PVector _loc, PVector _vel, PVector _acc, float _mass) {


    birthLoc = _loc;
    loc = _loc.get();
    lastLoc = _loc.get();
    vel = _vel.get();
    acc = _acc.get();
    mass = _mass;
    maxVel = _mass;
    


    //stroke(50, random(205) + 50, random(205) + 50, 15);
  }

  void update() {
        
    float r = abs(vel.x * 10) + abs(vel.y * 12);
    float g = abs(vel.x * vel.y) * 2;
    float b = abs(vel.x * 9 + vel.y * 9);

    //float r = abs(vel.x * 2 + vel.y * 2);
    //float g = abs(vel.x * vel.y) * .4;
    //float b = abs(vel.x * 5) + abs(vel.y * 5);

    //float r = abs(vel.x*45);
    //float g = abs(vel.x*15 + vel.y*15);
    //float b = abs(vel.x * vel.y * 4);

    vel.add(acc);
    vel.mult(damp);
    loc.add(vel);
    acc.mult(0);

    if (vel.mag() < minVel) {
      
      
      loc = new PVector(birthLoc.x, birthLoc.y);
      lastLoc = loc.get();
      //vel.mult(spike);
      //loc.x += random(mass) - mass;
      //loc.y += random(mass) - mass;
    }

    //strokeWeight(1);
    //stroke(r, g, b, 20);
    //point(loc.x, loc.y);

    strokeWeight(1);
    stroke(r, g, b, 20);

    line(lastLoc.x, lastLoc.y, loc.x, loc.y);


    lastLoc = loc.get();
  }

  void applyForce(PVector force) {

    force.div(mass);
    acc.add(force);
  }

  PVector calcGrav(PPoint _p) {

    PVector dir = PVector.sub(loc, _p.getLoc());
    float distance = dir.mag();
    distance = constrain(distance, 5, 25);
    dir.normalize();
    float force = (grav * mass * _p.getMass()) / (distance * distance);
    dir.mult(force);
    return dir;
  }

  PVector getLoc() {
    return loc.get();
  }

  PVector getVel() {
    return vel.get();
  }

  PVector getAcc() {
    return acc.get();
  }

  float getMass() {
    return mass;
  }

  void setLoc(PVector _loc) {
    loc = _loc;
  }

  void setVel(PVector _vel) {
    vel = _vel;
  }

  void setAcc(PVector _acc) {
    acc = _acc;
  }
  
}