import controlP5.*;
import java.util.Calendar;
import toxi.math.*;
import toxi.color.*;
import toxi.color.theory.*;
import toxi.util.datatypes.*;
import java.util.Iterator;

Palette p;

void setup() {
  size(500,500);
  p = new Palette();
  p.draw();
}

void draw() {
}

void keyPressed() {
  p = new Palette();
  p.draw();
}