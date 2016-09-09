class Palette {
  color anger = #F5956E;
  color joy = #fdec61;
  color calm = #ffffff;
  color disgust = #b8d183;
  color sadness = #78c7d6;
  color fear = #3e78ae;
  color surprise = #824f93;
  color love = #e8686b;
  
  float SWATCH_HEIGHT = 40;
  float SWATCH_WIDTH = 5;
  int SWATCH_GAP = 1;
  float MAX_SIZE = 150;
  int NUM_DISCS = 300;
  
  color[] colors = { anger, joy, calm, disgust, sadness, fear, surprise, love };
  color[][] palette;
  color[][] squares;
  int cols, rows;
  int resolution;
  
  float  noiseScale = 40;
  
  String blend = "burn";
  
  ColorList colorlist;
  
  color[] generateRestrictedColors(int number) {
    color[] restrictedColors = new color[number];
    for (int i=0; i<number; i++) {
      restrictedColors[i] = colors[(int) random((float) colors.length)];
    }
    return restrictedColors;
  }
  
  void addCircles() {
    
  }
    
  Palette() {
    palette = new color[width][height];
    ColorGradient gradient = new ColorGradient();
    
    generateColorList();
    int pos = 0;
    for (Iterator i = colorlist.iterator(); i.hasNext();) {
      TColor c = (TColor) i.next();
      float position = map(pos, 0, colorlist.size()-1, 0, width);
      gradient.addColorAt(position,c);
      pos++;
    }
        
    ColorList list = gradient.calcGradient(0, width);
    int x = 0;
    for (Iterator i=list.iterator(); i.hasNext();) {
      TColor c = (TColor)i.next();
      color crgb = c.toARGB();
      for (int y=0; y<height; y++) {
        pushStyle();
        colorMode(HSB, 1);
        float noise = noise(x/noiseScale, y/noiseScale);
        float brightness = brightness(crgb);
        if (blend == "burn") {
          noise *= 1.5;
          noise = constrain(noise, 0, 1);
          brightness = 1 - (1 - noise) / brightness(crgb);
        } else if (blend == "lighten") {
          brightness = max(noise, brightness(crgb));
        } else if (blend == "add") {
          brightness = min(255, (noise + brightness(crgb)));
        }
        color chsb = color(hue(crgb), saturation(crgb), brightness);
        palette[x][y] = chsb;
        popStyle();        
      }
      x++;
    }    
    
    addCircles();
  }
  
  void generateColorList() {
    color[] restrictedPalette = generateRestrictedColors(1);
    color cp = restrictedPalette[0]; 
    //TColor c = TColor.newHex(hex(cp));
    
    TColor c = TColor.newHSV(80. / 360, 42. / 100, 83. / 100);
    //tcolor should be equal to the one generated by r palette
    
    colorlist = ColorList.createUsingStrategy(ColorTheoryRegistry.SPLIT_COMPLEMENTARY, c);
    colorlist = new ColorRange(colorlist).addBrightnessRange(0,1).getColors(null,100,1);
    colorlist.sortByDistance(false);
  }
    
  color getColor(PVector location) {
    return palette[(int) location.x][(int) location.y];
  }
    
  void draw() {
     for (int x=0; x<width; x++) {
      for (int y=0; y<height; y++) {
        pushStyle();
        stroke(palette[x][y]);
        point(x,y);
        popStyle();
      }
     }
  }
}