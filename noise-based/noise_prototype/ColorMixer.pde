class ColorMixer {
  color anger = #F5956E;
  color joy = #fdec61;
  color calm = #ffffff;
  color disgust = #b8d183;
  color sadness = #78c7d6;
  color fear = #3e78ae;
  color surprise = #824f93;
  color love = #e8686b;
  color[] colorList = {anger, joy, calm, disgust, sadness, fear, surprise, love};

  Palette[] palettes;

  ColorMixer() {
    palettes = new Palette[2];
    palettes[0] = new Palette(sizeX, sizeY, anger);
    palettes[1] = new Palette(sizeX, sizeY, sadness);
  }

  color getColor(int x, int y) {
    color c1 = palettes[0].getColor(x, y);
    //color c2 = palettes[1].getColor(x, y);
    //color c = blendColor(c1, c2, ADD);
    return color(c1);
  }
}