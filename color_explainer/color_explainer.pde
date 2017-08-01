/// program displays color values in both rgb and hsb
/// you can input in any one adn the other will update
/// 

//int _id = -1; // can i make it a class var? no no

float R  = 0.5;  /// actually those first values are not being used
float G  = 0.5; /// but are here to not leave them unitialized
float B  = 0.5;
float hu = 0.5;
float sa = 0.5;
float br = 0.5;

color back; ////some drawing colors
color filler  = color ( R, G, B);
color border;

PGraphics hueImg, satImg, brImg; // imgs for sliders lable
PFont font; 

// background and canvas vars
int halfW, halfH; // wait for size...
int sqSize       = 400;
int backSqSize   = 80;
int margin       = 30;
int slidersInterval; 

// Sliders
VSlider[] rgbSliders = new VSlider[3]; ///RGB
VSlider[] hsbSliders = new VSlider[3]; ///HSB

// control
boolean rgbMode        = true;


void setup()
{
  size(700, 700, P2D);
  colorMode(RGB, 1.0);
  halfW           = width/2;
  halfH           = height/2;

  back   = color (0.117); ////some drawing colors
  border = color (0.142);


  slidersInterval = (width - (sqSize + backSqSize))/6;

  /// initialize RGB and HSV sliders (posX, minValue, maxValue)
  for (int i = 0; i < rgbSliders.length;i++)
  {
    rgbSliders[i] = new VSlider(margin + slidersInterval* i, 0, 255);
  }
  rgbSliders[0].setName("R");
  rgbSliders[1].setName("G");
  rgbSliders[2].setName("B");


  /// HSB sliders (posX, minValue, maxValue, name)
  hsbSliders[0] = new VSlider(width - margin - slidersInterval* 2, 0, 360, "H");
  hsbSliders[1] = new VSlider(width - margin - slidersInterval* 1, 0, 100, "S");
  hsbSliders[2] = new VSlider(width - margin - slidersInterval* 0, 0, 100, "Br");


  /// initial canvas color
  rgbSliders[0].setVal(0.2510);
  rgbSliders[1].setVal(0.5020);
  rgbSliders[2].setVal(0.5020);


  /// draw hue scale image
  hueImg = createGraphics (9, 8, P2D);
  hueImg.beginDraw();
  hueImg.colorMode(HSB, 360, 100, 100);
  for (int i = 0; i<= hueImg.width; i++)
  {
    hueImg.stroke(i*(360/8)+20, 100, 100);
    hueImg.line(i, 0, i, height);
  }
  hueImg.endDraw();

  /// draw saturation scale image
  satImg = createGraphics (9, 8, P2D);
  satImg.beginDraw();
  satImg.colorMode(HSB, 360, 100, 100);
  for (int i = 0; i<= satImg.width; i++)
  {
    satImg.stroke(270, i*(100/8)-15, 100);
    satImg.line(i, 0, i, height);
  }
  satImg.endDraw();

  /// draw brightness scale iimage
  brImg = createGraphics (9, 8, P2D);
  brImg.beginDraw();
  brImg.colorMode(HSB, 360, 100, 100);
  for (int i = 0; i<= satImg.width; i++)
  {
    brImg.stroke(0, 0, 115 - i*(100/8));
    brImg.line(i, 0, i, height);
  }
  brImg.endDraw();
  //font = loadFont("Monospaced-48.vlw");
  font  = createFont("AvenirNext-Regular", 48);
  //font3 = createFont("AppleSDGothicNeo-Medium", 12);


  background(back);
}// end of setup








void draw ()
{
  colorMode(RGB, 1.0);
  background(back);

  /// test for RGB or HSB mode acording to mouse position
  /// means;  one is accepting inputs and other following
  if (mouseX < width/2)
  {
    rgbMode = true;
  }
  else
  {
    rgbMode = false;
  }

  ///draw border not using stroke... opsgl
  noStroke();
  colorMode(RGB, 1.0);
  fill (border);
  rectMode(CENTER);
  //rect( halfW, halfH, sqSize + backSqSize, sqSize + backSqSize);


  /// draw canvas in RGB mode
  if (rgbMode)
  {
    colorMode(RGB, 1.0);
    noStroke();
    filler = color ( R, G, B);
    fill (filler);
    rectMode(CENTER);
    rect(halfW, halfH, sqSize, sqSize);


    /// sliders goC() and goI() - i'm having problems with overloading and processingjs...
    /// just activate and draw
    R = rgbSliders[0].goC(color(1.0, 0.0, 0.0));
    G = rgbSliders[1].goC(color(0.0, 1.0, 0.0));
    B = rgbSliders[2].goC(color(0.0, 0.0, 1.0));
    hsbSliders[0].goI(hueImg);
    hsbSliders[1].goI(satImg);
    hsbSliders[2].goI(brImg);


    /// changing color mode and read colors in new mode
    colorMode(HSB, 1.0);       
    hu = hue(filler);
    sa = saturation(filler);
    br = brightness(filler);
    ///setting value
    hsbSliders[0].setVal(hu);
    hsbSliders[1].setVal(sa);
    hsbSliders[2].setVal(br);
  }
  else if (!rgbMode)
  {
    /// the same, other way arround
    colorMode(HSB, 1.0);
    noStroke();
    filler = color ( hu, sa, br);
    fill (filler);
    rectMode(CENTER);
    rect(halfW, halfH, sqSize, sqSize);

    /// sliders
    hu = hsbSliders[0].goI(hueImg);
    sa = hsbSliders[1].goI(satImg);
    br = hsbSliders[2].goI(brImg);

    rgbSliders[0].goC(color(1.0, 0.0, 0.0));
    rgbSliders[1].goC(color(0.0, 1.0, 0.0));
    rgbSliders[2].goC(color(0.0, 0.0, 1.0));


    colorMode(RGB, 1.0);
    R = red(filler);
    G = green(filler);
    B = blue(filler);

    rgbSliders[0].setVal(R);
    rgbSliders[1].setVal(G);
    rgbSliders[2].setVal(B);
  }


  //rgbSliders[0].debug();
  //hsbSliders[0].debugln();
}//end of draw







void mousePressed()
{

  for (int i=0; i< rgbSliders.length; i++)
  {
    if (!rgbSliders[i].isOver())
    {
      rgbSliders[i].notOthers = true;
    }
  }
  for (int i=0; i< hsbSliders.length; i++)
  {
    if (!hsbSliders[i].isOver())
    {
      hsbSliders[i].notOthers = true;
    }
  }
}






void mouseReleased()
{
  for (int i=0; i< rgbSliders.length; i++)
  {

    rgbSliders[i].notOthers = false;
    rgbSliders[i].locked = false;
  }
  for (int i=0; i< hsbSliders.length; i++)
  {

    hsbSliders[i].notOthers = false;
    hsbSliders[i].locked = false;
  }
}



class VSlider 
{

  /// some colors to draw with
  color   lineColor;    
  color   knobColor;
  color   lineUnsel     = color(0.19);
  color   knobUnsel     = color(0.294);
  color   lineFocus     = color(0.22);
  color   knobFocus     = color(0.313);
  color   lineSel       = color(0.3);
  color   knobSel       = color(0.450);


  /// done with colors...
  float   x;//>                                     // position along x axis
  int     knobSize       = 12;


  /// align with border square
  float   halfSliderLength  = (sqSize + backSqSize)/2.0; 
  float   upperY            = halfH - halfSliderLength;
  float   lowerY            = halfH + halfSliderLength;

  /// values for slider
  float   maxValue          = -1;       
  float   minValue          = -1;
  float   knobValue         = 0.5;      // let's keep it always between 0.0 and 1.0
  float   knobDraw          = lowerY;   // this we will map to slider vsize to draw knob  
  String  name              ="";        // to write to screen
  float   retorno           = -1;             
  ///control ...
  boolean notOthers         = false;
  boolean locked            = false;



  VSlider() { // default constructor
  };





  /// with name
  VSlider (float _x, float _minValue, float _maxValue, String _name)
  {
    x        = _x;
    maxValue = _maxValue;
    minValue = _minValue;
    name     = _name;
  }




  /// without name
  VSlider (float _x, float _minValue, float _maxValue)
  {
    x        = _x;
    maxValue = _maxValue;
    minValue = _minValue;
    name     = "!NOTNAMEDYETPLEASEDO!";
  }




  /// add a colored square to sliders and diplay text % included
  /// it is not overloaded cause i'm havong trouble with overload and processingjs
  /// will look after later...
  float goC(color c) 
  {
    colorMode(RGB, 1.0);
    noStroke();
    fill (c);
    rect(x, (upperY+lowerY)/2, 8, 8);
    displayNumbers();
    displayPercents(); /// only rgb needs
    return go();
  }// eof go(color)




  /// add an image square to sliders and diplay text 
  /// for hsb sliders...
  float goI(PImage img)
  {
    image(img, x-(img.width/2), ((upperY+lowerY)/2) - img.height/2 );
    displayNumbers();
    return go();
  }//eof go(image)





  /// main method, should be doing less...
  float go ()
  {
    /// draw slider
    colorMode(RGB, 1.0);
    stroke(lineColor);
    strokeWeight(2);
    line( x, upperY, x, lowerY);


    /// test for proper click
    if (isOver() && mousePressed && !locked)
    {
      locked = true;
    }


    // not others is true for every other slider that was no clicked first
    // wont grab new sliders while locked in one 
    if (locked && !notOthers)
    {
      /// assign mouse y to knobvalue. constrained and mapped for drawing  
      float constrainedMouseY = constrain(mouseY, upperY, lowerY); 
      //grab the user input and normalize it
      knobValue = map(constrainedMouseY, lowerY, upperY, 0.0, 1.0);
      /// paint if locked
      lineColor = lineSel;
      knobColor = knobSel;
    } 
    else if (!locked) 
    {   
      /// test for focus if/elseif/elseif... for painting only 
      /// if slider is in the same vertical half of screen as mouse it is active

      if ( x > width/2 && mouseX > width/2 )
      {
        lineColor = lineFocus;
        knobColor = knobFocus;
      } 
      else if (x > width/2 && mouseX < width/2)
      {
        lineColor = lineUnsel;
        knobColor = knobUnsel;
      }
      else if (x < width/2 && mouseX > width/2)
      {
        lineColor = lineUnsel;
        knobColor = knobUnsel;
      }
      else
      {
        lineColor = lineFocus;
        knobColor = knobFocus;
      }
    }


    ///drawKnob
    noStroke();
    fill(knobColor);
    /// map nrmalized value to slider vsize
    knobDraw = map(knobValue, 0.0, 1.0, lowerY - knobSize/2, upperY + knobSize/2 );
    ellipse( x, knobDraw, knobSize, knobSize);


    /// tool tip, kind of..
    if (locked ||  isOver() || notOthers )
    {
      textFont(font, 18);
      color toAdd = color(0.25);
      color tempC = blendColor(lineColor, toAdd, ADD);
      fill(tempC);
      text(name, x - textWidth(name)-6, knobDraw-6);
    }


    return knobValue;
  }//end of go()






  void setName(String newName)
  {
    name = newName;
  }//end fo setName()






  /// 
  void setVal(float value)
  {
    knobValue = value;
  }





  ///
  void displayNumbers()
  {
    /// convert to specic slider range and format and write upwards(?)
    int mappedValue = int((knobValue)*maxValue);
    String valueToDisplay = nf(mappedValue, 3);

    pushMatrix();
    fill(lineColor);
    textFont(font, 40);
    textAlign(LEFT, TOP);
    rotate(-HALF_PI);
    translate(-lowerY - textWidth(valueToDisplay)-10, x-19);
    text(valueToDisplay, 0, 0);
    popMatrix();
    textAlign(LEFT);
  }//eof displayNumbers 





  ///
  void displayPercents() 
  {
    /// convert rgb in percents, format and write upwards(?)
    float percent = knobValue*100;
    String valueInPercent = nf(percent, 3, 2) + "%";

    pushMatrix();
    color toAdd = color(0.25);
    color percentColor = blendColor(lineColor, toAdd, ADD);
    fill(percentColor);
    textFont(font, 16);
    textAlign(LEFT, TOP);
    rotate(-HALF_PI);
    translate(-upperY - textWidth(valueInPercent), x-19);
    text(valueInPercent, 0, 0);
    popMatrix();
    textAlign(LEFT);
  }//eof displayPercents




  /// debug help
  void debug()
  {
    //print("  "+name+" knobValue="+ knobValue+ " knobDraw= "+ knobDraw);
    //print("locked = " + locked + "    notOthers = " + notOthers);
  }//eof debug()

  void debugln()
  {
    //println("  "+name+" knobValue="+ knobValue+ " knobDraw= "+ knobDraw);
    //println("   locked = " + locked + "    notOthers = " + notOthers);
  }// eof debugln()




  /// mouse detecting stuff
  boolean isOver() 
  {
    float disX = x - mouseX;
    float disY = knobDraw - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < (knobSize/2+3) ) {
      return true;
    } 
    else {
      return false;
    }
  }
}// end of Slider class