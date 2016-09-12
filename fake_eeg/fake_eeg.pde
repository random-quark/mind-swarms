import oscP5.*;
OscP5 oscP5;

String datas[] = { "happy", "sad", "relaxed", "stressed" };
float noiseValues[] = new float[datas.length];
String output = "";
float t;

void setup() {
  size(400,400);
  frameRate(60);
  OscProperties properties = new OscProperties();
  properties.setRemoteAddress("127.0.0.1", 5000);
  oscP5 = new OscP5(this, properties);
  for (int i=0;i<noiseValues.length;i++) {
    noiseValues[i] = random(1000);
  }
  t = 0;
}

void draw() {
  for (int i = 0; i<datas.length; i++) {
    OscMessage msg = new OscMessage("/" + datas[i]);
    float val = noise(noiseValues[i] + t);
    t++;
    msg.add(val);
    oscP5.send(msg);
    output = "Sent " + datas[i] + " with value " + val + "\n" + output;
  }
  
  background(255);
  stroke(0);
  fill(0);
  text(output, 10, 20);
}