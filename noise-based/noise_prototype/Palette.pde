class Palette {
  int palWidth, palHeight;

  float xPeriod=1.;     // how many lines on the X axis
  float yPeriod = 1.;   // how many lins on the Y axis
  float turbPower = 2.0; // how much turbulence
  float turbSize = 133;  // noise zoom in factor
  color c;
  PGraphics marbleVbo, huesVbo;
  ColorList colorlist;
  float hueOffset = random(10000);
  float hueRange = 0.1;
  float noiseStep = 0.005;

  Palette(int _width, int _height, color _c) {
    pushStyle();
    c = _c;
    println(c);
    palWidth= _width;
    palHeight = _height;
    createMarble();
    //createToxiHues();
    createHues();
  }

  color getColor(int x, int y) {
    colorMode(HSB, 1);
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
      float hue = hue(c) + map(noise(hueOffset), 0, 1, -hueRange, hueRange);
      if (hue<0) hue+=1;
      huesVbo.stroke(hue, 1, 1);
      huesVbo.line(x, 0, x, palHeight);
      hueOffset+=noiseStep;
    }
    huesVbo.endDraw();
    huesVbo.loadPixels();
  }

  void createToxiHues() {
    generateColorList();
    ColorGradient gradient = new ColorGradient();
    huesVbo = createGraphics(palWidth, 200, P2D);
    huesVbo.beginDraw();

    huesVbo.colorMode(RGB, 255);

    int pos = 0;
    for (Iterator i = colorlist.iterator(); i.hasNext(); ) {
      TColor c = (TColor) i.next();
      float position = map(pos, 0, colorlist.size()-1, 0, palWidth);
      gradient.addColorAt(position, c);
      pos++;
    }

    ColorList list = gradient.calcGradient(0, palWidth);
    println(list.size());
    int counter = 0;
    for (Iterator i=list.iterator(); i.hasNext(); ) {
      TColor c = (TColor)i.next();
      color crgb = c.toARGB();
      huesVbo.stroke(crgb);
      for (int h=0; h<100; h++) {
        huesVbo.point(counter, h);
      }
      counter++;
    }
    huesVbo.endDraw();
    huesVbo.loadPixels();
  }

  void generateColorList() {    
    TColor cp = TColor.newHSV(hue(c), saturation(c), brightness(c));
    colorlist = ColorList.createUsingStrategy(ColorTheoryRegistry.ANALOGOUS, cp);
    colorlist = new ColorRange(colorlist).addBrightnessRange(0, 1).getColors(null, 50, 1);
    colorlist.sortByDistance(false);
  }

  void createMarble() {
    marbleVbo = createGraphics(palWidth, palHeight, P2D);
    marbleVbo.beginDraw();
    marbleVbo.background(255);
    colorMode(HSB, 1);
    float hue = hue(c);
    for (int x=0; x<palWidth; x++) {
      for (int y=0; y<palHeight; y++) {
        float xyValue = x * xPeriod / palWidth + y * yPeriod / palHeight + turbPower * noise(x/turbSize, y/turbSize);
        float sineValue = abs(sin(xyValue * 3.14159));
        c = color(0, 1-sineValue, map(sineValue, 0, 1, .5, 1));
        marbleVbo.stroke(c);
        marbleVbo.point(x, y);
      }
    }
    marbleVbo.endDraw();
    marbleVbo.loadPixels();
    colorMode(RGB, 255);
    popStyle();
  }
}