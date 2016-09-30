class Palette {
  int palWidth, palHeight;
  
  int scaleFactor = 4;

  float xPeriod=1.;     // how many lines on the X axis
  float yPeriod = 1.;   // how many lins on the Y axis
  float turbPower = 2.0; // how much turbulence
  float turbSize = 170;  // noise zoom in factor
  color c;
  PGraphics marbleVbo, huesVbo;
  float hueOffset = random(10000);
  float hueRange = 0.1;
  float noiseStep = 0.005;

  Palette(int _width, int _height, color _c) {
    noiseSeed((int)random(1000));
    noiseDetail(10);
    pushStyle();
    c = _c;
    println("color hue: " + hue(c));
    palWidth= _width / scaleFactor;
    palHeight = _height / scaleFactor;
    createMarble();
    //createToxiHues();
    createHues();
  }

  color getColor(int _x, int _y) {
    colorMode(HSB, 1);
    int x = _x / scaleFactor;
    int y = _y / scaleFactor;
    color hue = huesVbo.pixels[y * huesVbo.width + x];
    color marble = marbleVbo.pixels[y * huesVbo.width + x];

    return color(hue(hue), saturation(marble), brightness(marble));
    //color c = color(hue(huesVbo.get(x,y)), saturation(marbleVbo.get(x,y)), brightness(marbleVbo.get(x,y)));
    //return c;
  }

  void createHues() {
    huesVbo = createGraphics(palWidth, palHeight, P2D);
    huesVbo.beginDraw();
    huesVbo.colorMode(HSB, 1);
    for (int x=0; x<palWidth; x++) {
      float hue = huesVbo.hue(c) + map(noise(hueOffset), 0, 1, -hueRange, hueRange);
      if (hue<0) hue+=1;
      huesVbo.stroke(hue, 1, 1);
      huesVbo.line(x, 0, x, palHeight);
      hueOffset+=noiseStep;
    }
    huesVbo.endDraw();
    huesVbo.loadPixels();
  }

  void createMarble() {
    marbleVbo = createGraphics(palWidth, palHeight, P2D);
    marbleVbo.beginDraw();
    marbleVbo.background(255);
    colorMode(HSB, 1);        // FIX ME!!! THIS SHOULD NOT BE HERE!!!!
    for (int x=0; x<palWidth; x++) {
      for (int y=0; y<palHeight; y++) {
        float xyValue = x * xPeriod / palWidth + y * yPeriod / palHeight + turbPower * noise(x/turbSize, y/turbSize);
        float sineValue = abs(sin(xyValue * 3.14159));
        color tempColor = color(0, 1-sineValue, map(sineValue, 0, 1, .8, 1));
        marbleVbo.stroke(tempColor);
        marbleVbo.point(x, y);
      }
    }
    marbleVbo.endDraw();
    marbleVbo.loadPixels();
    popStyle();
  }
}