/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/1163*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
ImgProc imgProc = new ImgProc();

float noiseScale = 0.005;
float noiseZ = 0;
int particlesDensity = 8;
int particleMargin = 64;  
Particle[] particles;
int[] currFrame;
int[] prevFrame;
int[] tempFrame;

void setup() {
  size(512, 512);
  frameRate(30);
  colorMode(HSB, 255);

  currFrame = new int[width*height];
  prevFrame = new int[width*height];
  tempFrame = new int[width*height];
  for(int i=0; i<width*height; i++) {
    currFrame[i] = color(0, 0, 0);
    prevFrame[i] = color(0, 0, 0);
    tempFrame[i] = color(0, 0, 0);
  }

  particles = new Particle[(width+particleMargin*2)/particlesDensity*(height+particleMargin*2)/particlesDensity];
  int i = 0;
  for(int y=-particleMargin; y<height+particleMargin; y+=particlesDensity) {
    for(int x=-particleMargin; x<width+particleMargin; x+=particlesDensity) {
       if (i == particles.length) {
         println(i);
         break;
       }
       int c = color(50+50*sin(PI*x/width), 127, 255*sin(PI*y/width));
       particles[i++] = new Particle(x, y, c);
    }
  }
}

void draw() {  
  noiseZ += 2*noiseScale;
  
  imgProc.blur(prevFrame, tempFrame, width, height);
  imgProc.scaleBrightness(tempFrame, tempFrame, width, height, 0.2);  
  arraycopy(tempFrame, currFrame);
  
  for(int i=0; i<particles.length; i++) {
    particles[i].update();
    particles[i].draw();
  }  
  imgProc.drawPixelArray(currFrame, 0, 0, width, height);
  arraycopy(currFrame, prevFrame);
}

class Particle {
  float x;
  float y;
  int c;
  float speed = 2;
  Particle(int x, int y, int c) {
    this.x = x;
    this.y = y;
    this.c = c;
  }
  void update() {
    float noiseVal = noise(x*noiseScale, y*noiseScale, noiseZ);
    float angle = noiseVal*2*PI;
    x += speed * cos(angle);
    y += speed * sin(angle);
    
    if (x < -particleMargin){
      x += width + 2*particleMargin;
    } else if (x > width + particleMargin){
      x -= width + 2*particleMargin;
    }
    
    if (y < -particleMargin){
      y += height + 2*particleMargin;
    } else if (y > height + particleMargin){
      y -= height + 2*particleMargin;
    }
  }
  void draw() {
    if ((x >= 0) && (x < width-1) && (y >= 0) && (y < height-1)) {
      int currC = currFrame[(int)x + ((int)y)*width];
      currFrame[(int)x + ((int)y)*width] = blendColor(c, currC, ADD);
    }
  }
}
