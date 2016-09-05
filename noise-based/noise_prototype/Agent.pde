// M_1_5_03_TOOL.pde
// Agent.pde, GUI.pde

class Agent {
  PVector p, pOld, pOriginal;
  float noiseZ = 0.01;
  float stepSize, angle;
  float alpha;
  color agentColor;
  int startMillis;

  Agent() {
    p = new PVector(random(width), random(height));
    pOriginal = new PVector(p.x, p.y);
    pOld = new PVector(p.x, p.y);
    stepSize = random(minSpeed, maxSpeed);
    startMillis = millis();

    //procedural color
    //colorMode(HSB, 1);
    //agentColor = color(map(stepSize,minSpeed,maxSpeed,0.6,.8),1,1,map(agentsAlpha,0,255,0,1));

    //color from underlying picture
    int x = (int)(p.x/width*imagePalette.width);
    int y = (int)(p.y/height*imagePalette.height);
    color c = imagePalette.get(x, y);
    alpha = agentsAlpha;
    agentColor = color(red(c), green(c), blue(c), alpha);

    setNoiseZ(noiseZMax);
  }

  void update1() {
    alpha -= agentAlphaDecrement;
    
    float modifiedNoiseScale = noiseScale;
    float remainderTTL = agentTTL - ((millis() - startMillis) / 1000 % agentTTL);
    if ((remainderTTL / agentTTL) < separationPercentage) {
      modifiedNoiseScale = noiseScale * (remainderTTL / agentTTL);
    }
    
    float noiseVal = noise(p.x/modifiedNoiseScale + randomSeed, p.y/modifiedNoiseScale  + randomSeed, noiseZ  + randomSeed);
    angle = map(noiseVal, 0, 1, -1, 1);
    angle = angle * radians(maxAngleSpan);

    //these two lines show how much I'll add to the x + y axis
    p.x += cos(angle) * stepSize; //stepSize is the speed
    p.y += sin(angle) * stepSize;

    // offscreen simple wrap
    //if (p.x<-10) p.x=pOld.x=width+10;
    //if (p.x>width+10) p.x=pOld.x=-10;
    //if (p.y<-10) p.y=pOld.y=height+10;
    //if (p.y>height+10) p.y=pOld.y=-10;

    // offscreen wrap - send to original position + restart
    //if (p.x<-10 || p.x>width+10 || p.y<-10 || p.y>height+10) {
    //  p.x=pOld.x=pOriginal.x; 
    //  p.y=pOld.y=pOriginal.y;
    //  noiseZ += noiseZStep;
    //}

    if (((millis()-startMillis) / 1000) % agentTTL == 0) {
      resetAgent();
    }

    //strokeWeight(strokeWidth*stepSize);
    stroke(agentColor);
    strokeWeight(strokeWidth);
    line(pOld.x, pOld.y, p.x, p.y);

    pOld.set(p);
  }

  void resetAgent() {
    alpha = agentsAlpha;
    p.x=pOld.x=pOriginal.x+random(-randomStepOnReset,randomStepOnReset); 
    p.y=pOld.y=pOriginal.y+random(-randomStepOnReset,randomStepOnReset);
    noiseZ += noiseZStep;
  }
  void setNoiseZ(float noiseZMax) {
    // small values will increase grouping of the agents
    noiseZ = random(noiseZMax);
  }
}