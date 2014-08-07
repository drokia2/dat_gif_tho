import g4p_controls.*;
import controlP5.*;
import java.awt.Frame;

class Point {
    float x, y;

    Point(float x1, float y1) {
        this.x = x1;
        this.y = y1;
    }      
}

float distance(Point p1, Point p2) {
  return sqrt( pow(p2.y - p1.y,2) + pow( p2.x - p1.x,2) );
}

float FRAME_RATE = 100;

//GUI
ControlP5 cp5;
ControlFrame cf;
ColorPicker cp1;
ColorPicker cp2;
float speedFactor = 0.25; //need to initialize the variables associated with the sliders, in addition to setting the default for the slider
float numWavesFactor = 0.25;

// Setup the Processing Canvas
void setup(){
  size(CANVAS_WIDTH, CANVAS_HEIGHT, OPENGL);
  frameRate(FRAME_RATE);
  smooth();
  createGUI();
}

public void createGUI() {  
  cp5 = new ControlP5(this);
  cf = addControlFrame("parameters", 300,300);
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}

public class ControlFrame extends PApplet {

  int w, h;

  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
    cp5.addSlider("speedFactor", 0, 1, 0.25, 10, 10, 100, 10);
    cp5.addSlider("numWavesFactor", 0, 1, 0.25, 10, 30, 100, 10);
    
    cp1 = cp5.addColorPicker("picker1")
          .setPosition(10, 50)
          .setColorValue(color(137, 209, 184, 255))
          ;
          
    cp2 = cp5.addColorPicker("picker2")
          .setPosition(10, 130)
          .setColorValue(color(204, 226, 189, 255))
          ;  
  }

  public void draw() {
      background(255);
  }
  
  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }

  public ControlP5 control() {
    return cp5;
  }
  
  ControlP5 cp5;
  Object parent; 
}

int CUBE_WIDTH = 20;
int NUM_ROWS = 30;
int NUM_COLS = 30;
int CANVAS_WIDTH = 600;
int CANVAS_HEIGHT = 600;
int TOP = 0;
int LEFT = 0;
int BACK = 0;
float MARGINX = 15;
float MARGINY = 10;

int SHORT = 10;
float LONG = 20;
float ORIGINAL_LONG = 20;
float EDGE = sqrt(pow(SHORT,2) + pow(LONG,2));

int MAX_SPEED = 4;
int MAX_NUM_WAVES = 8;

//Colors
color blue = color(137,209,184);
color yellow = color(204, 226, 189);
color black = color(0);
color white = color(255);

// Main draw loop
void draw(){
    background(0);
    smooth();

    int count = 0;
    Point center = new Point(width/2, height/2);
    float maxDistance = distance(center, new Point(0,0));
            
    for (float centery = 0; centery < NUM_ROWS*EDGE; centery += EDGE+ SHORT) {      
        float begin = (count % 2) * LONG;
        
        for (float centerx=begin; centerx < NUM_COLS*LONG*2; centerx += LONG*2) {                     
            
            Point p1 = new Point(centerx, centery - SHORT);
            Point p5 = new Point(centerx - LONG, centery + EDGE);
            Point p7 = new Point(centerx + LONG, centery + EDGE);
            Point middlep1p3 = new Point(p1.x, p1.y + SHORT);
            Point destinationp7 = new Point(p7.x, p7.y + SHORT);
            Point destinationp5 = new Point(p5.x, p5.y + SHORT);
            
            float d13 = distance(middlep1p3, center);
            float d7 = distance(destinationp7, center);
            float d5 = distance(destinationp5, center);
          
            float speed = speedFactor * MAX_SPEED;
            float numWavesFactor = numWavesFactor * MAX_NUM_WAVES;
            numWavesFactor = map(numWavesFactor, 0, MAX_NUM_WAVES, 1, MAX_NUM_WAVES);
            
            float verticalScalar13 = ((sin(speed*(frameCount/FRAME_RATE + (d13/maxDistance)*numWavesFactor*PI)) + 1)/2);
            float verticalScalar5 = (sin(speed*(frameCount/FRAME_RATE + (d5/maxDistance)*numWavesFactor*PI)) + 1)/2;
            float verticalScalar7 = (sin(speed*(frameCount/FRAME_RATE + (d7/maxDistance)*numWavesFactor*PI)) + 1)/2;     
          
            Point p2, p3, p4, p6;
            p1 = new Point(centerx, centery - SHORT * verticalScalar13);
            p2 = new Point(centerx - LONG, centery);
            p3 = new Point(centerx, centery + SHORT * verticalScalar13);
            p4 = new Point(centerx + LONG, centery);
            p5 = new Point(centerx - LONG, centery + EDGE + SHORT * (1 - verticalScalar5));
            p6 = new Point(centerx, centery + SHORT + EDGE); 
            p7 = new Point(centerx + LONG, centery + EDGE + SHORT * (1 - verticalScalar7));
            
            float d3 = distance(p3, center);
            float colorFactor = d3/maxDistance;
                        
            color mainColor = lerpColor(blue, yellow, colorFactor);
            color lighter = lerpColor(mainColor, white, 0.5);
            color darker = lerpColor(mainColor, black, 0.1);
            
            noStroke();
                        
            fill(darker);   
            quad(p1.x, p1.y, 
                p4.x, p4.y, 
                p3.x, p3.y,
                p2.x, p2.y);

            fill(mainColor);
            quad(p3.x, p3.y, 
                p4.x, p4.y, 
                p7.x, p7.y, 
                p6.x, p6.y);
            
            fill(lighter);
            quad(p3.x, p3.y, 
                p2.x, p2.y, 
                p5.x, p5.y, 
                p6.x, p6.y);

        }        
        count++;
    }    
  
                
}

