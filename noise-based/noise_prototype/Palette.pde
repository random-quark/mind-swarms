class Palette {
  color anger = #F5956E;
  color joy = #fdec61;
  color calm = #ffffff;
  color disgust = #b8d183;
  color sadness = #78c7d6;
  color fear = #3e78ae;
  color surprise = #824f93;
  color love = #e8686b;
  
  color[] colors = { anger, joy, calm, disgust, sadness, fear, surprise, love };
  color[][] palette;
  color[][] squares;
  int cols, rows;
  int resolution;
  
  float  noiseScale = 40;
  
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
    noiseDetail(4);
    generateSquares(250);
    palette = new color[width][height];
    for (int x=0; x<width; x++) {
      for (int y=0; y<height; y++) {
        int _x = int(constrain(x/resolution,0,cols-1));
        int _y = int(constrain(y/resolution,0,rows-1));
        color c = squares[_x][_y];
        pushStyle();
        colorMode(HSB, 100);
        palette[x][y] = color(hue(c), 100, noise(x/noiseScale, y/noiseScale) * 100);
        palette[x][y] = color(hue(c), 100, 100);
        popStyle();
      }
    }
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