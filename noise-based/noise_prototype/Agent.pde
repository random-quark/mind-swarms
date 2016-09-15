// M_1_5_03_TOOL.pde
// Agent.pde, GUI.pde

class Agent {
  PVector p, pOld, pOriginal;
  float noiseZ = 0.01;
  float stepSize, angle;
  float alpha;
  color agentColor;
  int startMillis;
  float remainderPercent;
  float tempAlpha=20;
  
  int width = bg.width;
  int height = bg.height;

  Agent() {
    p = new PVector(random(width), random(height));
    pOriginal = new PVector(p.x, p.y);
    pOld = new PVector(p.x, p.y);
    stepSize = random(minSpeed, maxSpeed);
    startMillis = millis();
    noiseZ = random(interAgentNoiseZRange);
    setColor();
  }

  void update() {
    float modifiedNoiseScale = noiseScale;

    if (agentTTL>0) {
      float remainderTTL = agentTTL - ((millis() - startMillis) % agentTTL);
      remainderPercent = remainderTTL / agentTTL;
      if (remainderPercent < separationPercentage) {
        modifiedNoiseScale = noiseScale * remainderPercent;
      }
      if (((millis()-startMillis)) > agentTTL) {
        resetAgent();
      }
    }

    float noiseVal = noise(p.x/modifiedNoiseScale + randomSeed, p.y/modifiedNoiseScale  + randomSeed, noiseZ  + randomSeed);
    angle = map(noiseVal, 0, 1, -1, 1);
    angle = angle * radians(maxAngleSpan);

    p.x += cos(angle) * stepSize; //stepSize is the speed
    p.y += sin(angle) * stepSize;

    if (p.x<0 || p.x>width || p.y<0 || p.y>height) resetAgent();

    bg.stroke(agentColor);
    bg.strokeWeight(strokeWidth);
    bg.line(pOld.x, pOld.y, p.x, p.y);

    pOld.set(p);
    noiseZ += noiseZStep;

    if (diminishingAlpha) { 
      tempAlpha -= .1;
      if (tempAlpha<1) {
        resetAgent();
      } else {
        colorMode(RGB);
        agentColor = color(red(agentColor), green(agentColor), blue(agentColor), tempAlpha);
      }
    }
  }

  void resetAgent() {
    startMillis = millis();
    if (resetWithError) {
      p.x = pOld.x = pOriginal.x + (int)random(10)-5;
      p.y = pOld.y = pOriginal.y + (int)random(10)-5;      
    } else {
      p.x = pOld.x = (int)random(width);
      p.y = pOld.y = (int)random(height);
    }
    setColor();
  }

  void setColor() {
    color c;
    tempAlpha = agentsAlpha;
    alpha = agentsAlpha;
    if (usePalette) {
      c = palette.getColor(p);
    } else {
      int x = (int)constrain(p.x/width*imagePalette.width, 0, imagePalette.width);
      int y = (int)constrain(p.y/height*imagePalette.height, 0, imagePalette.height);
      c = imagePalette.get(x, y);
    }
    colorMode(HSB, 1);
    agentColor = color(234./360., saturation(c)*1.5, brightness(c)*1.4, tempAlpha/255.);
    //agentColor = color(red(c), green(c), blue(c), tempAlpha);
  }
}