function Agent(dx, dy, V, A, M) {
  this.x = dx
  this.y = dy
  this.px = dx
  this.py = dy
  this.magnitude = 5
  this.angle = A
  this.mass = M
  this.agentColor
  this.lifespan
  this.strokeW = 1
  this.tempVector = createVector(0,0)
}

Agent.prototype.findAngle = function(x, y) {
  var theta;
  if (this.x === 0) {
    if (this.y > 0) {
      theta = HALF_PI;
    } else if (this.y < 0) {
      theta = 3 * HALF_PI;
    } else {
      theta = 0;
    }
  } else {
    theta = atan(this.y / this.x);
    if ((this.x < 0) && (this.y >= 0)) {
      theta += PI;
    }
    if ((this.x < 0) && (this.y < 0)) {
      theta -= PI;
    }
  }
  return theta;
}

Agent.prototype.gravitate = function(Z) {

    var F, mX, mY, perfectAngle;
    F = this.mass * Z.mass;
    
    this.tempVector.set(Z.x - this.x, Z.y - this.y)
    
    perfectAngle = this.tempVector.heading();
    

    mX = F * cos(perfectAngle) + this.magnitude * cos(this.angle);
    mY = F * sin(perfectAngle) + this.magnitude * sin(this.angle);
    this.tempVector.set(mX, mY)

    this.angle = this.tempVector.heading();
    // var p2 = new Point(mX, mY)
    // var vec = p1 - p2
    // var point1 = new Point(50, 0)

    
    console.log(degrees(this.findAngle(mX, mY)) + " // " + degrees(this.tempVector.heading()) + " // " )
    
  // var F = this.mass * Z.mass;

  // var mX = (this.mass * this.x + Z.mass * Z.x) / (this.mass + Z.mass);
  // var mY = (this.mass * this.y + Z.mass * Z.y) / (this.mass + Z.mass);
  // var A = this.findAngle(mX - this.x, mY - this.y);
  // console.log(degrees(A))
  // // console.log(Z.y)
  
  // mX = F * cos(A);
  // mY = F * sin(A);

  // mX += this.magnitude * cos(this.angle);
  // mY += this.magnitude * sin(this.angle);

  // this.magnitude = sqrt(sq(mX) + sq(mY));
  // this.angle = this.findAngle(mX, mY);

  if (sq(this.x - Z.x) + sq(this.y - Z.y) >= 50) {
    this.magnitude = 5;
  }
}

Agent.prototype.update = function() {
  this.x += this.magnitude * cos(this.angle);
  this.y += this.magnitude * sin(this.angle);
}

Agent.prototype.draw = function() {
  fill(255, 0, 0)
  ellipse(this.x, this.y, 5, 5)
}