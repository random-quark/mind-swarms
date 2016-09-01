class Circ {
  PVector loc;
  PPoint anchor;
  ArrayList ancArray;
  ArrayList pArray;
  float rad;
  boolean terminated = false;
  boolean drawing = false;
  float wander = 30; // this is what makes the centers of gravity move about, creating the ribbons in the examples we saw.

  Circ(ArrayList _ancArray, float _x, float _y, float _rad) {
    ancArray = _ancArray;
    loc = new PVector(_x, _y);
    rad = _rad;    
  }

  void setAnchor() {
    PVector l2 = new PVector(loc.x, loc.y);
    PVector v2 = new PVector(0, 0);
    PVector a2 = new PVector(0, 0);
    anchor = new PPoint(l2, a2, v2, rad); //rad is passed because it reflects the mass of the center of gravity (of the anchor point)
    ancArray.add(anchor);
    println("ANCHOR ARRAY SIZE: " + ancArray.size());
  }

  void terminate() {
    terminated = true;
  }

  void startDraw() {
    setAnchor();
    drawing = true;
  }
  
  // ****** UPDATE CIRCLE ******
  void update(float _incRad, boolean _display) {
    if (!terminated) {
      rad += _incRad;
      if (_display) {
        ellipse(loc.x, loc.y, rad*2, rad*2);
        line(loc.x - 2, loc.y, loc.x + 2, loc.y);
        line(loc.x, loc.y - 2, loc.x, loc.y + 2);
      }
    }
    // when in drawing mode this allows for the anchor point to move about (wander). Movement set to 0 by default - theo
    if (drawing){
      PVector currentLoc = anchor.getLoc();
      float newX = currentLoc.x + random(wander) - wander/2;
      float newY = currentLoc.y + random(wander) - wander/2;      
      anchor.setLoc(new PVector(newX, newY));
      //pushStyle();
      //fill(0,255);
      //ellipse(newX, newY, 10, 10); // for debugging - theo
      //popStyle();
    }
  }

  float getRad() {
    return rad;
  }

  PVector getLoc() {
    return loc;
  }
}