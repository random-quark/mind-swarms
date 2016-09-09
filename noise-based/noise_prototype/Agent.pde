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

  Agent() {
    p = new PVector(random(width), random(height));
    pOriginal = new PVector(p.x, p.y);
    pOld = new PVector(p.x, p.y);
    stepSize = random(minSpeed, maxSpeed);
    startMillis = millis();
    noiseZ = random(interAgentNoiseZRange);

    setColor();
  }

  void update1() {

    float modifiedNoiseScale = noiseScale;

    //TTL related (not used by default)
    if (agentTTL>0) {
      float remainderTTL = agentTTL - ((millis() - startMillis) / 1000 % agentTTL);
      remainderPercent = remainderTTL / agentTTL;
      if (remainderPercent < separationPercentage) {
        modifiedNoiseScale = noiseScale * remainderPercent;
      }
      if (((millis()-startMillis) / 1000) % agentTTL == 0) {
        resetAgent();
      }
    }

    float noiseVal = noise(p.x/modifiedNoiseScale + randomSeed, p.y/modifiedNoiseScale  + randomSeed, noiseZ  + randomSeed);
    angle = map(noiseVal, 0, 1, -1, 1);
    angle = angle * radians(maxAngleSpan);

    //these two lines show how much I'll add to the x + y axis
    p.x += cos(angle) * stepSize; //stepSize is the speed
    p.y += sin(angle) * stepSize;

    if (p.x<0 || p.x>width || p.y<0 || p.y>height) resetAgent();

    stroke(agentColor);
    strokeWeight(strokeWidth);

    line(pOld.x, pOld.y, p.x, p.y);

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
  //
  void resetAgent() {
    if (false /*resetWithError*/) {
    
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
    agentColor = color(red(c), green(c), blue(c), tempAlpha);
  }
}