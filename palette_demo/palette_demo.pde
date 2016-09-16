import controlP5.*;
import java.util.Calendar;
import toxi.math.*;
import toxi.color.*;
import toxi.color.theory.*;
import toxi.util.datatypes.*;
import java.util.Iterator;

Palette p;
int numCircles = 0;

void setup() {
  size(500,500);
  p = new Palette(500,500);
  p.draw();
}

void draw() {
}

void keyPressed() {
  background(255);
  p = new Palette(500,500);
  p.draw();
}