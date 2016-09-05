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
    loc = _loc.copy();
    lastLoc = _loc.copy();
    vel = _vel.copy();
    acc = _acc.copy();
    mass = _mass;
    maxVel = _mass;
    //stroke(50, random(205) + 50, random(205) + 50, 15);
  }

  void update() {
    
    // color scheme, looks like most of his works - theo
    float b = abs(vel.x * 10) + abs(vel.y * 12);
    float r = abs(vel.x * vel.y) * 2;
    float g = abs(vel.x * 9 + vel.y * 9);

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

    if (vel.mag() < minVel) { //if the velocity is too slow then send the particle to its original location to start again
      loc.set(birthLoc.x, birthLoc.y);
      lastLoc.set(loc.x, loc.y);
      //vel.mult(spike);
      //loc.x += random(mass) - mass;
      //loc.y += random(mass) - mass;
    }

    strokeWeight(1);     // reduce this for more natural blend - theo
    stroke(r, g, b, 10); // alpha was 20, I made it 10 - theo

    //stroke(0,255);
    line(lastLoc.x, lastLoc.y, loc.x, loc.y);

    //lastLoc = loc.copy();
    lastLoc.set(loc.x, loc.y);
  }

  void applyForce(PVector force) {
    force.div(mass);
    acc.add(force);
  }

  PVector calcGrav(PPoint _p) {
    PVector dir = PVector.sub(loc, _p.getLoc());
    float distance = dir.mag();
    distance = constrain(distance, 5, 25); //affects the power of gravity (smaller 3rd value makes for more rotations)
    dir.normalize();
    float force = (grav * mass * _p.getMass()) / (distance * distance);
    dir.mult(force);
    return dir;
  }

  PVector getLoc() {
    return loc.copy();
  }

  PVector getVel() {
    return vel.copy();
  }

  PVector getAcc() {
    return acc.copy();
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