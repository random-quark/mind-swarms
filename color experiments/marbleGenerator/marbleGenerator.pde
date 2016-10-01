float xPeriod= 1;     // how many lines on the X axis
float yPeriod = 1;   // how many lins on the Y axis
float turbPower = 1.5; // how much turbulence
float turbSize = 150;  // noise zoom in factor
float randomXoffset, randomYoffset;

void setup() {
  noiseSeed(0);
  //size(433, 266);
  //size(1300, 800);
  size(500, 500);
  noiseSeed(0);
  randomXoffset = (int)random(1000);
  randomYoffset = (int)random(1000);
}

void draw() {
  background(0);
  colorMode(HSB, 1);
  //turbPower = map(mouseX, 0, width, 0, 20);
  //turbSize = map(mouseY, 0, height, 1, 400);
  //randomXoffset = mouseX;
  randomYoffset = mouseY;
  color c ;

  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      float xyValue = (x+randomXoffset)  * xPeriod / width + (y+randomYoffset) * yPeriod / height + turbPower * noise(x/turbSize, y/turbSize);
      float sineValue = abs(sin(xyValue * 3.14159));
      //float sineValue = abs(sin(x/100.+y/100.));
      c = color(19./360., 1-sineValue, map(sineValue, 0, 1, .5, 1));
      stroke(c);
      point(x, y);
    }
  }

  println("TurbPower: " + turbPower + "    TurbSize: " + turbSize + " ");
}

void mousePressed() {
  randomXoffset = random(100000);
  randomYoffset = random(100000);
  //saveFrame("test.png");
}