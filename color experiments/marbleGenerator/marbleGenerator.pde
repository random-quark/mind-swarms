float xPeriod=1;     // how many lines on the X axis
float yPeriod = 1;   // how many lins on the Y axis
float turbPower = 1.5; // how much turbulence
float turbSize = 150;  // noise zoom in factor

void setup() {
  size(400, 400);
  noiseSeed(0);
}

void draw() {
  background(0);
  colorMode(HSB, 1);
  //turbPower = map(mouseX, 0, width, 0, 20);
  //turbSize = map(mouseY, 0, height, 1, 150);

  color c ;

  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      float xyValue = x * xPeriod / width + y * yPeriod / height + turbPower * noise(x/turbSize, y/turbSize);
      float sineValue = abs(sin(xyValue * 3.14159));
      c = color(19./360., 1-sineValue, map(sineValue, 0, 1, .5, 1));
      stroke(c);
      point(x, y);
    }
  }

  println("TurbPower: " + turbPower + "    TurbSize: " + turbSize + " ");
}

void mousePressed() {
  saveFrame("test.png");
}