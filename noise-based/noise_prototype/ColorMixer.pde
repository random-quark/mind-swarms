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
  PGraphics mixedVbo;
  Palette[] palettes;

  ColorMixer(LinkedList<String> emotionslist) {
    emotionscolors = new HashMap<String, Integer>();
    emotionscolors.put("anger", #F5956E);
    emotionscolors.put("joy", #fdec61);
    emotionscolors.put("calm", #ffffff);
    emotionscolors.put("disgust", #b8d183);
    emotionscolors.put("sadness", #78c7d6);
    emotionscolors.put("fear", #3e78ae);
    emotionscolors.put("surprise", #824f93);
    emotionscolors.put("love", #e8686b);

    mixedVbo = createGraphics(sizeX, sizeY, P2D);

    color c1 = color((int)emotionscolors.get(emotionslist.get(0)));
    color c2 = color((int)emotionscolors.get(emotionslist.get(1)));

    println(emotionslist.get(0), emotionslist.get(1));

    palettes = new Palette[2];
    palettes[0] = new Palette(sizeX/scalingFactor, sizeY/scalingFactor, c1);
    palettes[1] = new Palette(sizeX/scalingFactor, sizeY/scalingFactor, c2);

    createMixedPalette();

    mixedVbo.loadPixels();

    palettes[0].marbleVbo.save("marble01.png");
    palettes[1].marbleVbo.save("marble02.png");
    palettes[0].huesVbo.save("hues01.png");
    palettes[1].huesVbo.save("hues02.png");
    mixedVbo.save("mixedVbo.png");
  }

  color getColor(int x, int y) {
    color c = mixedVbo.pixels[y * mixedVbo.width + x];
    return c;
  }

  void createMixedPalette() {
    color c1, c2, c;
    mixedVbo.beginDraw();
    for (int x=0; x<sizeX; x++) {
      for (int y=0; y<sizeY; y++) {
        c1 = palettes[0].getColor(x, y);
        c2 = palettes[1].getColor(x, y);
        c = mixColors(c1, c2);
        //c = blendColor(c1, c2, DARKEST);
        mixedVbo.stroke(c);
        mixedVbo.point(x, y);
      }
    }
    mixedVbo.endDraw();
  }

  color mixColors(color c1, color c2) {
    //if (brightness(c1)<brightness(c2)) return c1;
    //return c2;
    if (saturation(c1)<saturation(c2)*8) return c2;
    else return c1;
    //return blendColor(c1, c2, DARKEST);
  }
}