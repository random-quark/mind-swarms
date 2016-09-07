import toxi.color.*;
import toxi.color.theory.*;
import toxi.util.datatypes.*;
import toxi.math.*;

void setup() {
  size(500, 500);
}

void draw() {
  //default Processing gradient using lerpColor
  color a = color(249, 149, 101);
  color b = color(114, 199, 216);

  for (int x=0; x<width; x++) {
    stroke(lerpColor(a, b, map(x, 0, width, 0, 1)));
    line(x, 0, x, height);
  }

  ////ToxiLibs gradient
  //ColorGradient grad=new ColorGradient();
  //TColor a = TColor.newHSV(19./360, 59./100, 98./100);
  //TColor b = TColor.newHSV(190./360, 47./100, 85./100);

  //grad.addColorAt(0, a);
  //grad.addColorAt(width, b);

  //ColorList cols=grad.calcGradient(0, width);
  //int x=0;
  //for (TColor c : cols) {
  //  stroke(c.toARGB());
  //  line(x, 0, x, height);
  //  x++;
  //}
}