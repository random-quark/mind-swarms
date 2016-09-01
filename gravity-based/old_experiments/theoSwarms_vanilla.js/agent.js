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
  //this.tempVector = createVector(0,0)
  this.tempVector = new Victor(0, 0);
}

Agent.prototype.gravitate = function(Z) {

    var F, mX, mY, perfectAngle;
    F = this.mass * Z.mass;

    // console.log("Z: " + Z.x + " " + Z.y)
    this.tempVector.x = Z.x - this.x
    this.tempVector.y = Z.y - this.y

    perfectAngle = this.tempVector.angle();
    // console.log("perfect: " + perfectAngle)

    mX = F * Math.cos(perfectAngle) + this.magnitude * Math.cos(this.angle);
    mY = F * Math.sin(perfectAngle) + this.magnitude * Math.sin(this.angle);
    this.tempVector.x = mX
    this.tempVector.y = mY
    // console.log("mixed vector: " + mX + "   " + mY)

    this.angle = this.tempVector.angle();

    // console.log(degrees(this.findAngle(mX, mY)) + " // " + degrees(this.tempVector.heading()) + " // " )

  if (Math.pow(this.x - Z.x, 2) + Math.pow(this.y - Z.y, 2) >= 50) {
    this.magnitude = 5;
  }
}

Agent.prototype.update = function(attractor) {
  this.gravitate(attractor)
  this.px = this.x
  this.py = this.y
  this.x += this.magnitude * Math.cos(this.angle)
  this.y += this.magnitude * Math.sin(this.angle)
}

Agent.prototype.draw = function() {
  // context.beginPath();
  // context.arc(this.x, this.y, 1, 0, 2 * Math.PI, false);
  // // context.strokeStyle = 'rgba(100,0,0,1)';
  // context.fillStyle = 'rgba(0,0,0,1)';
  // context.fill();
  // context.stroke();

  context.beginPath();
  context.moveTo(this.x, this.y);
  context.lineTo(this.px, this.py);
  context.strokeStyle = 'rgba(100,0,0,0.4)';
  context.stroke();

}
