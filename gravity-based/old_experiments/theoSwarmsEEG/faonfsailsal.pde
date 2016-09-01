class particle {

  float x;
  float y;
  float px;
  float py;
  float magnitude;
  float angle;
  float mass;
  color agentColor;
  float lifespan;
  float strokeW;
  int minLifespan;
  int maxLifespan;

  particle( float dx, float dy, float V, float A, float M ) {
    x = dx;
    y = dy;
    px = dx;
    py = dy;
    magnitude = V;
    angle = A;
    mass = M;
    minLifespan = 30;
    maxLifespan = 90;
    lifespan = random(minLifespan, maxLifespan);
    int x = (int)(dx/width*1280.0);
    int y = (int)(dy/height*853.0);
    agentColor = color(map(beta, 0, width, 0, 255), 255, 255, 5);
    strokeW = 1;
  }

  void reset( float dx, float dy, float V, float A, float M ) {
    x = dx;
    y = dy;
    px = dx;
    py = dy;
    magnitude = V;
    angle = A;
    mass = M;
    lifespan = random(minLifespan, maxLifespan);
    int x = (int)(dx/width*1280.0);
    int y = (int)(dy/height*853.0);
    //agentColor = imagePalette.get(x, y);
    agentColor = color(map(beta, 0, width, 0, 255), 255, 255, 5);
  }

  void gravitate( particle Z ) {
    float F, mX, mY, A;
    if ( sq( x - Z.x ) + sq( y - Z.y ) != 0 ) {
      F = mass * Z.mass;
      mX = ( mass * x + Z.mass * Z.x ) / ( mass + Z.mass );
      mY = ( mass * y + Z.mass * Z.y ) / ( mass + Z.mass );
      A = findAngle( mX - x, mY - y );

      mX = F * cos(A);
      mY = F * sin(A);

      mX += magnitude * cos(angle);
      mY += magnitude * sin(angle);

      magnitude = sqrt( sq(mX) + sq(mY) );
      angle = findAngle( mX, mY );
    }
    if ( sq( x - Z.x ) + sq( y - Z.y ) >= 50 ) {
      magnitude = 5;
    }
  }

  void repel( particle Z ) {
    float F, mX, mY, A;
    if ( sq( x - Z.x ) + sq( y - Z.y ) != 0 ) {
      F = mass * Z.mass;
      mX = ( mass * x + Z.mass * Z.x ) / ( mass + Z.mass );
      mY = ( mass * y + Z.mass * Z.y ) / ( mass + Z.mass );
      A = findAngle( x - mX, y - mY );

      mX = F * cos(A);
      mY = F * sin(A);

      mX += magnitude * cos(angle);
      mY += magnitude * sin(angle);

      magnitude = sqrt( sq(mX) + sq(mY) );
      angle = findAngle( mX, mY );
    }
  }

  void deteriorate() {
    magnitude *= 0.935;
  }

  void update() {

    x += magnitude * cos(angle);
    y += magnitude * sin(angle);
    lifespan-=1;
    strokeW-=0.05;
    strokeW=constrain(strokeW, 0.3, 20); 
    if (lifespan<0) {
      // reset( random(width), random(height), 0, 0, 1 );
      //int x = (int)(x/width*1280.0);
      //int y = (int)(y/height*853.0);
      lifespan = random(minLifespan, maxLifespan);
      //agentColor = imagePalette.get((int)(x/width*1280.0), (int)(y/height*853.0));
      agentColor = color(map(x, 0, width, 0, 255), 255, 255, 5);
    }
  }

  void display() {
    stroke(agentColor);
    strokeWeight(strokeW);
    line(px, py, x, y);
    px = x;
    py = y;
  }
}

float findAngle( float x, float y ) {
  float theta;
  if (x == 0) {
    if (y > 0) {
      theta = HALF_PI;
    } else if (y < 0) {
      theta = 3*HALF_PI;
    } else {
      theta = 0;
    }
  } else {
    theta = atan( y / x );
    if (( x < 0 ) && ( y >= 0 )) { 
      theta += PI;
    }
    if (( x < 0 ) && ( y < 0 )) { 
      theta -= PI;
    }
  }
  return theta;
}