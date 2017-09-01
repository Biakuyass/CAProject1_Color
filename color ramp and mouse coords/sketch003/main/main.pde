import java.util.LinkedList;
import java.util.Iterator;
// Lectures in Graphics (LiG): sketch003
// Author(s): Han Zhang, Luyao Huang
// Subject: P1 Color
// Class: CS6491 
// Last update on: September 1,2017        
// Usage: press 'r' to see rows
// click&drag mouse horizontally to change number of disks
// Contains: tools for using colors, images, screen (help) text                      *** update as needed
// Comments: Demonstrates loops, classes, 2D transforms                              *** update as needed

//**************************** global variables ****************************
Boolean scribeText=true; // toggle for displaying of help text
int n=20; 
float n_float=20; // number of disks shown, float is used to provide smooth mouse-drag edit of n
// color variables are defined in the "utilities" tab and set in "defineColors" during initialization
ColorRamp colorramp = new ColorRamp();
ColorRamp colorramp2 = new ColorRamp();
ColorRamp colorramp3 = new ColorRamp();
class RGBColor
{
  int r, g, b;
  RGBColor(int r_, int g_, int b_)
  {
    r = r_;
    g = g_;
    b = b_;
  }
}
float HaltonSequence(int base, int index)
{
  LinkedList<Integer> record = new LinkedList<Integer>();

  int remainder = index % base;
  int quotient = index / base;
  record.add(remainder);

  while (quotient != 0 )
  {
    remainder = quotient % base;
    quotient /= base;
    record.add(remainder);
  }

  float result = 0;
  Iterator<Integer> it = record.iterator();

  int exponential = -1;
  while (it.hasNext())
  {
    Integer i = it.next();
    result += i * pow(base, exponential--);
  }

  return result;
}
int [] LabColorramp(int i)
{
  int [] rgb = new int[3];
        double a = HaltonSequence(2, i) * 100;
        double b = HaltonSequence(3, i) * 200 - 100;
        double c = HaltonSequence(4, i) * 200 - 100;
        rgb = LABtoRGB((double)a, (double)b, (double)c);
        return rgb;
}
int [] RGBColorramp(int i)
{
  int [] rgb = new int[3];
          rgb[0] = (int)(HaltonSequence(3, i) * 256);
        rgb[1] = (int)(HaltonSequence(3, i) * 256);
        rgb[2] = (int)(HaltonSequence(3, i) * 256);
  return rgb;
}
class ColorRamp
{
  LinkedList<RGBColor> colors;
  ColorRamp() {
    colors = new LinkedList<RGBColor>();
  }

  void createramp(int n, int type)
  {
    for (int i = 1; i <= n; i++)
    {
      int [] rgb = new int [3];
      switch(type)
      {
      case 0 :
        rgb = LabColorramp(i);
        break;
      case 1 :
        rgb = RGBColorramp(i);
        break;
      case 2 :
        switch(i)
        {
          case 30:
          rgb = LabColorramp(31);
          break;
          case 29:
          rgb = LabColorramp(26);
          break;
          case 2:
          rgb = LabColorramp(16);
          break;
          case 26:
          rgb =  RGBColorramp(24);
          break;
          default:
          if (i % 3 == 0)
        {
          rgb = LabColorramp(i);

        } else
        {
          rgb = RGBColorramp(i);
        }
        }
        break;
      default:
        break;
      }
      colors.add(new RGBColor(rgb[0], rgb[1], rgb[2]));
      
      //colors.get(11)
    }
  }


  void showramp(float y)
  {
    Iterator<RGBColor> it = colors.iterator();
    float start_x = 20;
    float start_y = y;
    float rectwidth = 15;
    float rectheight = 40;
    while (it.hasNext())
    {
      RGBColor rgbcolor = (RGBColor)it.next();

      fill(rgbcolor.r, rgbcolor.g, rgbcolor.b);
      rect(start_x, start_y, rectwidth, rectheight);
      start_x += rectwidth;
      
      //println(temp.r + "   " + temp.g + "  " + temp.b);
    }
  }
}

//**************************** initialization ****************************
void setup() {               // executed once at the begining 
  size(600, 600);            // canvas size
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  defineMyColors(); // sets HSB color mode and THEN defines values for color variables

  colorramp.createramp(32, 0);
  colorramp2.createramp(32, 1);
  colorramp3.createramp(32, 2);
}

//**************************** display current frame ****************************
void draw() {      // executed at each frame
  background(white); // clear screen and paints white background
  //pen(black,3); // sets stroke color (to balck) and width (to 3 pixels)
  noStroke();

  if (!mousePressed && !keyPressed) scribeMouseCoordinates();
  //****************************** add your code here to display the two spirals ***************


  colorramp.showramp(300); 
  colorramp2.showramp(350); 
   colorramp3.showramp(400); 
  //************ submit your code (above) on paper (with your name and screen snap shot with your face) at the beginning of lecture on due date


  if (scribeText) displayTextImage();
}  // end of draw()


// User actions
void keyPressed() { // executed each time a key is pressed: sets the "keyPressed" and "key" state variables, 
  // till it is released or another key is pressed or released
  if (key=='?') scribeText=!scribeText; // toggle display of help text and authors picture
  if (key=='!') snapPicture(); // make a picture of the canvas
  if (key=='+') {
    n++; 
    n_float=n;
  }  // increment n and sets n_float in case it is dragged with a continuous motion of the mouse
  if (key=='-') if (n>=0) {
    n--; 
    n_float=n;
  }  // decrements n
  if (key=='Q') exit();  // quit application
}


void mouseDragged() { // executed when mouse is pressed and moved
  n_float+=20.*(mouseX-pmouseX)/width; // updates float value of n
  if (n_float>0) n=round(n_float);  // snaps n to closest int
}


// EDIT WITH PROPER CLASS, PROJECT, STUDENT'S NAME, AND DESCRIPTION OF ACTION KEYS ***************************
String title ="CS6491 Fall 2012, Project 1: SHOW COLORED RAMP", name ="Jarek Rossignac", 
  menu="?:help(on/off), !:snapPicure, Q:quit", 
  guide="r: to see ramp, press&drag mouse right/left to change the number of disks"; // help info