// Create a circle shaped path with its center at the center
// of the view and a radius of 30:
// var path = new Path.Circle({
// 	center: view.center,
// 	radius: 30,
// 	strokeColor: 'black'
// });

// function onResize(event) {
// 	// Whenever the window is resized, recenter the path:
// 	path.position = view.center;
// }

Agent.prototype.gravitate = function(gX, gY, gMass) {

    var F = this.mass * gMass;

    this.tempPoint.x = gX - this.path.position.x
		this.tempPoint.y = gY - this.path.position.y

    var perfectAngle = this.tempPoint.angle

		var perfectAngleRad = perfectAngle * (Math.PI / 180.0)

		this.tempPoint.x = F * Math.cos(perfectAngleRad) + this.magnitude * Math.cos(this.angle);
    this.tempPoint.y = F * Math.sin(perfectAngleRad) + this.magnitude * Math.sin(this.angle);

    this.angle = this.tempPoint.angle * (Math.PI / 180.0)
}

function Agent(dx, dy, V, A, M) {
  this.loc = new Point(dx, dy)
	this.size = new Size(4,4)
  this.magnitude = 5
  this.angle = 0
  this.mass = M
	this.path = new Path.Circle(this.loc, this.size);
	this.path.strokeColor = 'black';
	this.tempPoint = new Point();
  // this.agentColor
  // this.lifespan
  // this.strokeW = 1
}

Agent.prototype.update = function() {
  this.path.position.x += this.magnitude * Math.cos(this.angle);
  this.path.position.y += this.magnitude * Math.sin(this.angle);
}

var agents = []
var totalAgents = 200
for (var i = 0; i < totalAgents; i++) {
  newAgent = new Agent(Math.random()*500, Math.random()*500, 0, 0, Math.random(0.7,1.0))
  agents.push(newAgent)
}
var centerOfGravity = new Point(500,500)

function onFrame(event) {
	for (var i = 0; i < totalAgents; i++) {
    agents[i].gravitate(centerOfGravity.x, centerOfGravity.y, 2)
		// agents[i].draw()
		agents[i].update()
		// console.log(agents[i].path.position.x)
	}
}

function onMouseDrag(event) {
	centerOfGravity = event.point
}
