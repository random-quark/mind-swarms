// by J.R. Schmidt, circa 2010

//import javax.media.opengl.*;
import processing.opengl.*;
import processing.pdf.*;

ArrayList proxyArray;
ArrayList circArray;
ArrayList ancArray;
ArrayList pArray;
ArrayList sourceArray;
ArrayList allPoints;

float canvasWidth = 1200;
float canvasHeight = 800;
float proxyWidth;
float proxyHeight;
float maxProxy = 600;
float proxyScale;
float aspect;

int numSources = 0;
int sourceSize = 200;
int count = 10000;
float maxDist = 500;


boolean holdShift = false;

void setup() {

  //size(2000, 1300, P2D);
  size(1200, 800, P2D);
  
  frameRate(30);
  proxyArray = new ArrayList();
  circArray = new ArrayList();
  ancArray = new ArrayList();
  pArray = new ArrayList();
  sourceArray = new ArrayList();
  allPoints = new ArrayList();
  setupProxy();
}

//sets up the area where you initialize the attractors
void setupProxy() {
  if (width >= height) {
    aspect = canvasHeight/canvasWidth;
    proxyWidth = maxProxy;
    proxyHeight = maxProxy * aspect;
  }
  else {
    aspect = canvasWidth/canvasHeight;
    proxyWidth = maxProxy * aspect;
    proxyHeight = maxProxy;
  }
  proxyScale = proxyWidth / canvasWidth;
  updateProxy();
}

void updateProxy() {
  noStroke();
  fill(100, 100, 80);
  rect(100, 100, proxyWidth, proxyHeight);
  stroke(0);
  fill(200);
}

void spawn() {
  boolean noOverlap = true;
  float initRadius = 10;
  //theo: calculate where on the canvas the proxy canvas points correspond
  float x = map(mouseX, 100, proxyWidth + 100, 0, canvasWidth);
  float y = map(mouseY, 100, proxyHeight + 100, 0, canvasHeight);

  for (int i = 0; i < circArray.size(); i++) {
    Circ c1 = (Circ) circArray.get(i);
    float distance = dist(c1.getLoc().x, c1.getLoc().y, x, y);
    float radii = c1.getRad() + initRadius;

    if (radii >= distance) { 
      noOverlap = false;
    }
  }

  if (noOverlap) { //if cicrcle you're adding doesn't overlap with existing -> create a new one
    //real Circle;
    Circ c = new Circ(ancArray, x, y, initRadius); //create a circle in the real canvas (theo)
    circArray.add(c);
    
    //proxyCircle
    Circ cProxy = new Circ(ancArray, mouseX, mouseY, initRadius * proxyScale); // create a circle in the proxy canvas (theo)
    proxyArray.add(cProxy);
  }
}

void spawnSource(){
  numSources ++;
  float x = map(mouseX, 100, proxyWidth + 100, 0, canvasWidth);
  float y = map(mouseY, 100, proxyHeight + 100, 0, canvasHeight);
  line(mouseX - 5, mouseY, mouseX + 5, mouseY);
  line(mouseX, mouseY - 5, mouseX, mouseY + 5);
  PVector source = new PVector(x, y);
  sourceArray.add(source);
}

// primitive way to create PPoints and spread them evently outside of the canvas. - theo
void initializeSwarm() {
  for (int i = 0; i < count; i++) {
      float angle = random(360);
      float m = 2;                                        //mass - theo
      PVector v = new PVector(0, 0);                      //velocity - theo
      PVector a = new PVector(random(0)-0, random(0)-0);  //acceleration - theo
      float xPos = random(width);
      float yPos = random(height);
      //spawns particles randomly around the border of a canvas
      if (angle < 90){
        yPos = - 1 - random(200); 
      }
      else if (angle < 180){
        xPos = width + 1 + random(200);
      }
      else if (angle < 270){
        yPos = height + 1 + random(200);
      }
      else{
        xPos = - 1 - random(200);
      }    
      PVector randomLoc = new PVector(xPos, yPos);
      PPoint p = new PPoint(randomLoc, a, v, m);
      pArray.add(p);
  }
}

// checks if a passed circle touches any of the others. If it does, it returns true (and circle stop growing) - theo
boolean checkBounds(Circ _c) {
  Circ c1 = _c;
  for (int i = 0; i < circArray.size(); i++) {
    Circ c2 = (Circ) circArray.get(i);
    if (c2 != c1) {

      float distance = dist(c1.getLoc().x, c1.getLoc().y, c2.getLoc().x, c2.getLoc().y);
      float radii = c1.getRad() + c2.getRad();

      if (radii >= distance) return true;
    }
  }
  return false;
}

void calcGrav() {
  // All Points
  for (int i = 0; i < pArray.size(); i++) {
    PPoint p1 = (PPoint) pArray.get(i);
    p1.update();
    PVector totDir = new PVector(0, 0);
    for (int k = 0; k < ancArray.size(); k++) {
      PPoint anc = (PPoint) ancArray.get(k);
      float ancDist = dist(anc.getLoc().x, anc.getLoc().y, p1.getLoc().x, p1.getLoc().y);
      if (ancDist < maxDist) {
        PVector dir = p1.calcGrav(anc);
        dir.div(5);
        totDir.add(dir);
      }
      else {
        PVector dir = p1.calcGrav(anc);
        dir.div(50);
        totDir.add(dir);
      }
    }
    p1.applyForce(totDir);
  }
}

// keep growing the circles until they touch another circle.
void updateCircles() {
  for (int i = 0; i < circArray.size(); i++) {
    Circ c = (Circ) circArray.get(i);
    Circ cp = (Circ) proxyArray.get(i);
    c.update(1, false);
    cp.update(proxyScale, true);

    if (checkBounds(c)) {
      c.terminate();
      cp.terminate();
    }
  }
}

ArrayList getAllPoints() {
  return allPoints;
}

void draw() {
  updateCircles();
  
  //GL gl = ((PGraphicsOpenGL)g).gl;
  // additive blending
  //gl.glEnable(GL.GL_BLEND);

  //if (random(100) > 0) {
    //gl.glBlendFunc(GL.GL_SRC_ALPHA, GL.GL_ONE);
  //}

  calcGrav();

  // disable depth test
  //gl.glDisable(GL.GL_DEPTH_TEST);
}