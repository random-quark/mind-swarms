class Circ {
  
  PVector loc;
  PPoint anchor;
  ArrayList ancArray;
  ArrayList pArray;
  float rad;
  boolean terminated = false;
  boolean drawing = false;
  
  float wander = 0;


  Circ(ArrayList _ancArray, float _x, float _y, float _rad) {


    ancArray = _ancArray;
    loc = new PVector(_x, _y);
    rad = _rad;
    
  }

  void setAnchor() {

    PVector l2 = new PVector(loc.x, loc.y);
    PVector v2 = new PVector(0, 0);
    PVector a2 = new PVector(0, 0);
    anchor = new PPoint(l2, a2, v2, rad);
    ancArray.add(anchor);
    
    println(ancArray.size());
  }

  void terminate() {
    terminated = true;
  }

  void startDraw() {
  
    setAnchor();
    drawing = true;
  }


  void update(float _incRad, boolean _display) {

    if (!terminated) {
      rad += _incRad;

      if (_display) {
        ellipse(loc.x, loc.y, rad*2, rad*2);
        line(loc.x - 2, loc.y, loc.x + 2, loc.y);
        line(loc.x, loc.y - 2, loc.x, loc.y + 2);
      }
    }
    if (drawing){
      
      PVector currentLoc = anchor.getLoc();
      float newX = currentLoc.x + random(wander) - wander/2;
      float newY = currentLoc.y + random(wander) - wander/2;
      
      anchor.setLoc(new PVector(newX, newY));
    }
  }

  float getRad() {

    return rad;
  }

  PVector getLoc() {

    return loc;
  }
}





























