void setup() {

  size(500, 500);
}
void draw() {
  colorMode(RGB);
  background(255);

  float zoom=40;//map(mouseX, 0, width, 0, 200);
  int a = (int)map(mouseY, 0, height, 1, 20);
  float b = map(mouseX, 0, width, 0.1, 1.);
  noiseDetail(a, b);
  
  for (int x=0; x<width; x++) {
    for (int y=0; y<height; y++) {
      colorMode(RGB);
      float c = noise(x/zoom, y/zoom) * 256;
      color cA = color(236, 102, 101);
      color cB = color(114, 199, 216);
      color newC = lerpColor(cA, cB, map(x, 0, width, 0, 1));
      colorMode(HSB);
      color hsbNewC = color(hue(newC), saturation(newC), c);
      stroke(hsbNewC);
      point(x, y);
    }
  }
  fill(255);
  text(str(zoom), 10, 10);
}