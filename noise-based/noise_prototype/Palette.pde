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
  
  ColorList colorlist;
  
  color[] generateRestrictedColors(int number) {
    color[] restrictedColors = new color[number];
    for (int i=0; i<number; i++) {
      restrictedColors[i] = colors[(int) random((float) colors.length)];
    }
    return restrictedColors;
  }

  void generateSquares(int _resolution) {
    color[] restrictedColors = generateRestrictedColors(3);
    resolution = _resolution;
    cols = width / resolution;
    rows = height / resolution;
    resolution = _resolution;
    squares = new color[cols][rows];
    for (int x=0; x<cols; x++) {
      for (int y=0; y<rows; y++) {
        int pick = (int) random((float) restrictedColors.length);
        squares[x][y] = restrictedColors[pick];
      }
    }
  }
    
  Palette() {
    palette = new color[width][height];
    ColorGradient gradient = new ColorGradient();
    
    generateColorList();
    int pos = 0;
    for (Iterator i = colorlist.iterator(); i.hasNext();) {
      TColor c = (TColor) i.next();
      float position = map(pos, 0, colorlist.size(), 0, width);
      gradient.addColorAt(position,c);
      pos++;
    }
    println("pos",pos);
        
    ColorList list = gradient.calcGradient(0, width);
    int x = 0;
    for (Iterator i=list.iterator(); i.hasNext();) {
      TColor c = (TColor)i.next();
      color crgb = c.toARGB();
      for (int y=0; y<height; y++) {
        pushStyle();
        colorMode(HSB, 100);
        float n = noise(x/noiseScale, y/noiseScale);
        int sat = (int) (crgb * n);
        color chsb = color(hue(crgb), saturation(sat), brightness((int) (crgb * n)));
        palette[x][y] = crgb;
        popStyle();        
      }
      x++;
    }    
  }
  
  void generateColorList() {
    TColor c = ColorRange.DARK.getColor();
    ColorTheoryStrategy s = ColorTheoryRegistry.COMPOUND;
    colorlist = ColorList.createUsingStrategy(s, c);
    colorlist = new ColorRange(colorlist).addBrightnessRange(0,1).getColors(null,10000,30);
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