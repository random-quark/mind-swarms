class Agent {
  PVector p, pOld;
  float noiseZ, noiseZVelocity = 0.01;
  float stepSize, angle;
  color agentColor;
  boolean isOutside = false; 

  Agent() {
    float startX = 0;//width/2-200;
    float endX = width;//width/2+200;
    float startY = 0;//height/2-200;
    float endY = height;//height/2+200;
    p = new PVector(random(startX, endX), random(startY, endY));

    pOld = new PVector(p.x, p.y);
    stepSize = random(0.5, 1);
    // init noiseZ
    setNoiseZRange(0.4);
    int x = (int)(p.x/width*1280.0);
    int y = (int)(p.y/height*853.0);
    agentColor = imagePalette.get(x, y);
  }

  void update1() {
    angle = noise(p.x/noiseScale, p.y/noiseScale, noiseZ) * noiseStrength;

    p.x += cos(angle) * stepSize;
    p.y += sin(angle) * stepSize;

    if (p.x<-10) isOutside = true;
    else if (p.x>width+10) isOutside = true;
    else if (p.y<-10) isOutside = true;
    else if (p.y>height+10) isOutside = true;

    if (isOutside) {
      p.x = random(width);
      p.y = random(height);
      pOld.set(p);
      isOutside = false;
    int x = (int)(p.x/width*1280.0);
    int y = (int)(p.y/height*853.0);
      agentColor = imagePalette.get(x, y);
    }


    strokeWeight(strokeWidth);//*stepSize);
    stroke(agentColor, agentsAlpha);
    line(pOld.x, pOld.y, p.x, p.y);

    pOld.set(p);
    noiseZ += noiseZVelocity;
  }

  void update2() {
    angle = noise(p.x/noiseScale, p.y/noiseScale, noiseZ) * 24;
    angle = (angle - int(angle)) * noiseStrength;

    p.x += cos(angle) * stepSize;
    p.y += sin(angle) * stepSize;

    // offscreen wrap
    if (p.x<-10) p.x=pOld.x=width+10;
    if (p.x>width+10) p.x=pOld.x=-10;
    if (p.y<-10) p.y=pOld.y=height+10;
    if (p.y>height+10) p.y=pOld.y=-10;

    strokeWeight(strokeWidth*stepSize);
    line(pOld.x, pOld.y, p.x, p.y);

    pOld.set(p);
    noiseZ += noiseZVelocity;
  }


  void setNoiseZRange(float theNoiseZRange) {
    // small values will increase grouping of the agents
    noiseZ = random(theNoiseZRange);
  }
}