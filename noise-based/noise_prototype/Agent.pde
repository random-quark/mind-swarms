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
    if (agentTTL>0) {
      if (((millis()-startMillis)) > agentTTL) {
        resetAgent();
      }
    }

    float noiseVal = noise(p.x/noiseScale + randomSeed, p.y/noiseScale  + randomSeed, noiseZ  + randomSeed);
    angle = map(noiseVal, 0, 1, -1, 1);
    angle = (angle * radians(maxAngleSpan) * noiseStrength) + randomInitialDirection;

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
      p.x = pOld.x = constrain(pOriginal.x + (int)random(resetStep*2)-resetStep, 0, width);
      p.y = pOld.y = constrain(pOriginal.y + (int)random(resetStep*2)-resetStep, 0, height);      
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
    colorMode(RGB);
    agentColor = color(red(c), green(c), blue(c), alpha);
  }
}