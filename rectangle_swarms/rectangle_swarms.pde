float centerX, centerY;
int formResolution = 30;
float startRadius = 100;
float stepSize = 50;
float[] x = new float[formResolution];
float[] y = new float[formResolution];
float[] noiseOffs = new float[formResolution];
float angle = 360.0/float(formResolution);
float yoff = random(0.5);

void setup() {
  size(800, 800);
  background(255);
  noFill();
  centerX = -startRadius/2; //width/2;
  centerY = width/2;

  for (int i=0; i<formResolution; i++) {
    x[i] = cos(angle*i) * startRadius;
    y[i] = sin(angle*i+444.2) * startRadius;
    noiseOffs[i]=random(100);
  }
}

void draw() {
  //  background(255);
  centerX += 0.2;//(mouseX-centerX) * 0.01;

  for (int i=0; i<formResolution; i++) {
    float rad =startRadius + map(noise(noiseOffs[i]), 0, 1, -stepSize, stepSize);
    float endX = rad * sin((i*angle)*PI/180);
    float endY = rad * cos((i*angle)*PI/180);
    x[i] = endX;
    y[i] = endY;
    noiseOffs[i]+=0.001;
    //ellipse(x[i]+centerX,y[i]+centerY,5,5);
  }
  //t+=0.01;
  yoff+=0.001;
  float modY = map(noise(yoff), 0, 1, -200, 200); //sin(frameCount/100.0)*100;

  color from = color(100, 0, 0, 5);
  color to = color(0, 0, 100, 5);
  color c = lerpColor(from, to, map(sin(centerX/60.0), -1, 1, 0, 1));
  strokeWeight(2);
  stroke(c);
  beginShape();

  curveVertex(x[formResolution-1]+centerX, y[formResolution-1]+centerY+modY);

  for (int i=0; i<formResolution; i++) {
    curveVertex(x[i]+centerX, y[i]+centerY+modY);
    //ellipse(x[i]+centerX, y[i]+centerY, 3, 3);
  }
  curveVertex(x[0]+centerX, y[0]+centerY+modY);

  curveVertex(x[1]+centerX, y[1]+centerY+modY);

  endShape();
}