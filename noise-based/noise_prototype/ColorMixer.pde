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
    palettes[0] = new Palette(sizeX/scalingFactor, sizeY/scalingFactor, anger);
    palettes[1] = new Palette(sizeX/scalingFactor, sizeY/scalingFactor, surprise);

    palettes[0].marbleVbo.save("marble01.png");
    palettes[1].marbleVbo.save("marble02.png");
    palettes[0].huesVbo.save("hues01.png");
    palettes[1].huesVbo.save("hues02.png");

    saveMixedPalette();
  }

  color getColor(int x, int y) {
    color c1 = palettes[1].getColor(x/scalingFactor, y/scalingFactor);
    color c2 = palettes[0].getColor(x/scalingFactor, y/scalingFactor); 
    color c = blendColor(c1, c2, DARKEST); //MULTIPLY
    return c;
  }

  void saveMixedPalette() {
    PGraphics mixedVbo = createGraphics(sizeX, sizeY, P2D);
    color c1, c2, c;
    mixedVbo.beginDraw();
    for (int x=0; x<sizeX; x++) {
      for (int y=0; y<sizeY; y++) {
        c1 = palettes[0].getColor(x, y);
        c2 = palettes[1].getColor(x, y);
        c = blendColor(c1, c2, DARKEST);
        mixedVbo.stroke(c);
        mixedVbo.point(x, y);
      }
    }
    mixedVbo.endDraw();
    mixedVbo.save("mixedVbo.png");
  }
}