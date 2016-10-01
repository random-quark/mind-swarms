class Palette {
  int palWidth, palHeight;

  float xPeriod=1.;     // how many lines on the X axis
  float yPeriod = 1.;   // how many lins on the Y axis
  float turbPower = 2.0; // how much turbulence
  float turbSize = 170;  // noise zoom in factor
  color c;
  PGraphics marbleVbo, huesVbo;
  float hueOffset = random(10000);
  float hueRange = 0.1;
  float noiseStep = 0.005;
  float minMarbleBrightness = 0;
  float randomXoffset, randomYoffset;


  Palette(int _width, int _height, float[] colorData) {
    noiseSeed((int)random(1000));
    noiseDetail(10);
    pushStyle();
    colorMode(HSB, 360);
    c = color(colorData[0], 100, 100);
    hueRange = colorData[1];
    minMarbleBrightness = colorData[2];
    randomXoffset = (int)random(1000);
    randomYoffset = (int)random(1000);

    palWidth= _width / paletteScaleFactor;
    palHeight = _height / paletteScaleFactor;
    createMarble();
    createHues();
    popStyle();
  }

  color getColor(int _x, int _y) {
    pushStyle();
    colorMode(HSB, 1);
    int x = constrain(_x / paletteScaleFactor, 0, palWidth-1);
    int y = constrain(_y / paletteScaleFactor, 0, palHeight-1);
    color hue = huesVbo.pixels[y * huesVbo.width + x];
    color marble = marbleVbo.pixels[y * huesVbo.width + x];
    popStyle();
    return color(hue(hue), saturation(marble), brightness(marble));
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
    pushStyle();
    marbleVbo = createGraphics(palWidth, palHeight, P2D);
    marbleVbo.beginDraw();
    marbleVbo.background(255);

    colorMode(HSB, 1);        // FIX ME!!! THIS SHOULD NOT BE HERE!!!! MAYBE A PUSHSTYLE INTHIS FUNCTION?????
    for (int x=0; x<palWidth; x++) {
      for (int y=0; y<palHeight; y++) {
        float xyValue = (x+randomXoffset) * xPeriod / palWidth + (y+randomYoffset) * yPeriod / palHeight + turbPower * noise(x/turbSize, y/turbSize);
        float sineValue = abs(sin(xyValue * 3.14159));
        color tempColor = color(0, 1-sineValue, map(sineValue, 0, 1, minMarbleBrightness, 1));
        marbleVbo.stroke(tempColor);
        marbleVbo.point(x, y);
      }
    }
    marbleVbo.endDraw();
    marbleVbo.loadPixels();
    popStyle();
  }
}