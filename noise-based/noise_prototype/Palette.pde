class Palette {
  color anger = #F5956E;
  color joy = #fdec61;
  color calm = #ffffff;
  color disgust = #b8d183;
  color sadness = #78c7d6;
  color fear = #3e78ae;
  color surprise = #824f93;
  color love = #e8686b;

  int palWidth, palHeight;

  float xPeriod=1.;     // how many lines on the X axis
  float yPeriod = 1.;   // how many lins on the Y axis
  float turbPower = 2.0; // how much turbulence
  float turbSize = 133;  // noise zoom in factor

  PGraphics[] palette = new PGraphics[2];
  color[] mylist = new color[2];
  mylist[1] = color(255,0,0);
  
  //colors[1] = sadness;

  Palette(int _width, int _height) {
    pushStyle();
    colorMode(HSB, 1);
    palette[0] = createGraphics(_width, _height, P2D);
    palette[1] = createGraphics(_width, _height, P2D);
    palWidth = _width;
    palHeight = _height;
    color c;
    
    for (int paletteNo = 0; paletteNo<2; paletteNo++) {
      for (int x=0; x<palWidth; x++) {
        for (int y=0; y<palHeight; y++) {
          float xyValue = x * xPeriod / width + y * yPeriod / height + turbPower * noise(x/turbSize, y/turbSize);
          float sineValue = abs(sin(xyValue * 3.14159));
          c = color(hue(colors[paletteNo]), 1-sineValue, map(sineValue, 0, 1, .5, 1));
          stroke(c);
          palette[paletteNo].point(x, y);
        }
      }
    }
    colorMode(RGB, 255);
    popStyle();
  }
}