class ColorMixer {
  float[] angerData = new float[] {19, 0.05, 0.9}; // ORANGE
  float[] joyData = new float[] {55, 0.02, 0.9};  //YELLOW
  float[] calmData = new float[] {0, 0.1, 0.8}; // WHITE
  float[] disgustData = new float[] {162, 0.1, 0.8}; // DISGUST
  float[] sadnessData = new float[] {190, 0.1, 0.8}; // LIGHT BLUE
  float[] fearData = new float[] {210, 0.1, 0.8}; // BLUE
  float[] surpriseData = new float[] {285, 0.1, 0.65}; // PURPLE
  float[] loveData = new float[] {0, 0.1, 0.8}; // RED

  PGraphics mixedVbo;
  Palette[] palettes;
  Map<String, float[]> emotionsData;
  int mixerWidth, mixerHeight;
  
  ColorMixer(LinkedList<String> emotionslist, int _w, int _h) {

    mixerWidth = _w;
    mixerHeight = _h;
    emotionsData = new HashMap<String, float[]>();
    emotionsData.put("anger", angerData);
    emotionsData.put("joy", joyData);
    emotionsData.put("calm", calmData);
    emotionsData.put("disgust", disgustData);
    emotionsData.put("sadness", sadnessData);
    emotionsData.put("fear", fearData);
    emotionsData.put("surprise", surpriseData);
    emotionsData.put("love", loveData);

    mixedVbo = createGraphics(mixerWidth, mixerHeight, P2D);

    float[] colorData1 =  emotionsData.get(emotionslist.get(0));
    float[] colorData2 =  emotionsData.get(emotionslist.get(1));
    globalColorData1 = colorData1;
    globalColorData2 = colorData2;

    println(emotionslist.get(0), emotionslist.get(1));

    palettes = new Palette[2];
    palettes[0] = new Palette(mixedVbo.width, mixedVbo.height, colorData1);
    palettes[1] = new Palette(mixedVbo.width, mixedVbo.height, colorData2);

    createMixedPalette();

    mixedVbo.loadPixels();
  }

  color getColor(int _x, int _y) {
    int x = int(map(_x, 0, sizeX, 0, mixedVbo.width));
    int y = int(map(_y, 0, sizeY, 0, mixedVbo.height));
    color c = mixedVbo.pixels[y * mixedVbo.width + x];
    return c;
  }

  void createMixedPalette() {
    pushStyle();
    colorMode(HSB, 1);
    color c1, c2, c;
    mixedVbo.beginDraw();
    for (int x=0; x<mixedVbo.width; x++) {
      for (int y=0; y<mixedVbo.height; y++) {
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
    if (customBlend) {
      if (saturation(c1)<saturation(c2)*blendFactor) return c2;
      else return c1;
    } else return blendColor(c1, c2, DARKEST);
  }

  void savePalettes() {
    palettes[0].marbleVbo.save(save_destination+"marble01.png");
    palettes[1].marbleVbo.save(save_destination+"marble02.png");
    palettes[0].huesVbo.save(save_destination+"hues01.png");
    palettes[1].huesVbo.save(save_destination+"hues02.png");
    mixedVbo.save(save_destination+"mixedVbo.png");
  }
}