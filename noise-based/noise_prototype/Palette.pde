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
  int cols, rows;
  int resolution;
  
  color[] generateRestrictedColors(int number) {
    color[] restrictedColors = new color[number];
    for (int i=0; i<number; i++) {
      restrictedColors[i] = colors[(int) random((float) colors.length)];
    }
    return restrictedColors;
  }

  Palette(int _resolution) {
    color[] restrictedColors = generateRestrictedColors(3);
    resolution = _resolution;
    cols = width / resolution;
    rows = height / resolution;
    resolution = _resolution;
    palette = new color[cols][rows];
    for (int x=0; x<cols; x++) {
      for (int y=0; y<rows; y++) {
        int pick = (int) random((float) restrictedColors.length);
        palette[x][y] = restrictedColors[pick];
      }
    }
  }
  
  color getColor(PVector location) {
    int x = int(constrain(location.x/resolution,0,cols-1));
    int y = int(constrain(location.y/resolution,0,rows-1));
    color c = palette[x][y];
    colorMode(HSB);
    color output = color(hue(c), random(150,255), random(150,255));
    return output;
  }
  
  void draw() {
     for (int x=0; x<cols; x++) {
      for (int y=0; y<rows; y++) {
        pushStyle();
        fill(palette[x][y]);
        rect(x*resolution,y*resolution,resolution,resolution);
        popStyle();
      }
     }
  }
}