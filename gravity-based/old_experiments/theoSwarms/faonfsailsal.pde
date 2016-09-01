class particle {

  float x;
  float y;
  float px;
  float py;
  float magnitude;
  float mixedAngle;
  float mass;
  color agentColor;
  float lifespan;
  float strokeW;
  PVector tempVector = new PVector(0,0);

  particle( float dx, float dy, float V, float A, float M ) {
    x = dx;
    y = dy;
    px = dx;
    py = dy;
    magnitude = 5;
    mixedAngle = A;
    mass = M;
    lifespan = random(10, 50);
    int x = (int)(dx/width*1280.0);
    int y = (int)(dy/height*853.0);
    agentColor = imagePalette.get(x, y);
    strokeW = 2;
  }

  void reset( float dx, float dy, float V, float A, float M ) {
    x = dx;
    y = dy;
    px = dx;
    py = dy;
    magnitude = V;
    mixedAngle = A;
    mass = M;
    lifespan = random(20, 50);
    int x = (int)(dx/width*1280.0);
    int y = (int)(dy/height*853.0);
    agentColor = imagePalette.get(x, y);
  }

  void gravitate( particle Z ) {
    float F, mX, mY, perfectAngle;
    F = mass * Z.mass;

    tempVector.set(Z.x - x, Z.y - y);
    perfectAngle = tempVector.heading();
    mX = F * cos(perfectAngle) + magnitude * cos(mixedAngle);
    mY = F * sin(perfectAngle) + magnitude * sin(mixedAngle);

    tempVector.set(mX, mY);
    mixedAngle = tempVector.heading();
  }

  // there was some repel code originally here.
  // look at git history or online example if you need it

  void deteriorate() {
    magnitude *= 0.935;
  }

  void update() {
    x += magnitude * cos(mixedAngle);
    y += magnitude * sin(mixedAngle);
    lifespan-=1;
    strokeW-=0.05;
    strokeW=constrain(strokeW, 0.3, 20); 
    if (lifespan<0) {
      lifespan = random(20, 50);
      agentColor = imagePalette.get((int)(x/width*1280.0), (int)(y/height*853.0));
    }
  }

  void display() {
    stroke(agentColor, 5);
    strokeWeight(strokeW);
    line(px, py, x, y);
    px = x;
    py = y;
  }
}