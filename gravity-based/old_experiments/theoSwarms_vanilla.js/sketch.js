var agents = []
var canvas = document.getElementById('myCanvas')
var context = canvas.getContext('2d')
var attractor = new Agent(200,200,0,0,2)

setup()
setInterval(function(){ draw() }, 1000/100);

function setup() {
  context.lineWidth = 1;
  context.strokeStyle = 'rgba(0,0,0,0.5)';
  canvas.width  = window.innerWidth*0.985;
  canvas.height = window.innerHeight*0.983;
  // console.log(window.innerWidth)
  createAgents(5000)
}

function draw(){
  //  context.clearRect(0, 0, canvas.width, canvas.height)
   context.fillStyle="rgba(255,255,255,0.08)";
  //  context.globalAlpha=0.1;
   context.fillRect(0,0,canvas.width, canvas.height)
   agents.forEach(function(a){
     a.draw()
     a.update(attractor)
   })
}

function createAgents(max){
  for (var x=0; x<max; x+=1){
    var a = new Agent(Math.random()*canvas.width, Math.random()*canvas.height, 0, 0, Math.random()*0.6 + 0.3)
    agents.push(a)
  }
}

function getMousePos(canvas, evt) {
  var rect = canvas.getBoundingClientRect();
  return {
    x: evt.clientX - rect.left,
    y: evt.clientY - rect.top
  };
}

canvas.addEventListener('mousemove', function(evt) {
    var mousePos = getMousePos(canvas, evt);
    attractor.x = mousePos.x
    attractor.y = mousePos.y
  }, false);
