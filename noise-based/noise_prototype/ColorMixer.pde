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
    palettes[0] = new Palette(sizeX, sizeY, c1);
    palettes[1] = new Palette(sizeX, sizeY, c2);

    createMixedPalette();

    mixedVbo.loadPixels();
  }

  color getColor(int x, int y) {
    color c = mixedVbo.pixels[y * mixedVbo.width + x];
    return c;
  }

  void createMixedPalette() {
    pushStyle();
    colorMode(HSB, 1);
    color c1, c2, c;
    mixedVbo.beginDraw();
    for (int x=0; x<sizeX; x++) {
      for (int y=0; y<sizeY; y++) {
        c1 = palettes[0].getColor(x, y);
        c2 = palettes[1].getColor(x, y);
        c = mixColors(c1, c2);
        mixedVbo.stroke(c);
        mixedVbo.point(x, y);
      }
    }
    mixedVbo.endDraw();
    popStyle();
  }

  color mixColors(color c1, color c2) {
    //float weightedC1Sat = saturation(c1)*emotionspercents.get(0);
    //float weightedC2Sat = saturation(c2)*emotionspercents.get(1);
    //if (weightedC1Sat < weightedC2Sat) return c2;
    //else return c1;
    //if (saturation(c1)<saturation(c2)*blendFactor) return c2;
    //else return c1;
    
    pushStyle();
    colorMode(RGB, 255);
    color c = color( min((float) red(c1), (float) red(c2)), min((float) green(c1), (float) green(c2)), min((float) blue(c1), (float) blue(c2)) );
    popStyle();
    return c;
  }

  void savePalettes() {
    palettes[0].marbleVbo.save(save_destination+"marble01.png");
    palettes[1].marbleVbo.save(save_destination+"marble02.png");
    palettes[0].huesVbo.save(save_destination+"hues01.png");
    palettes[1].huesVbo.save(save_destination+"hues02.png");
    mixedVbo.save(save_destination+"mixedVbo.png");
  }
}