import g4p_controls.*;

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
GWindow parametersWindow;
GSlider speedSlider;
GSlider numWavesSlider;

// Setup the Processing Canvas
void setup(){
  size(CANVAS_WIDTH, CANVAS_HEIGHT, OPENGL);
  frameRate(FRAME_RATE);
  smooth();
  createGUI();
}

public void createGUI() {
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  
  //window
  parametersWindow = new GWindow(this, "Parameters", 0, 0, 240, 120, false, JAVA2D);
  parametersWindow.addDrawHandler(this, "parametersWindow");
  
  //speed slider
  speedSlider = new GSlider(parametersWindow.papplet, 70, 20, 100, 40, 10.0);
  speedSlider.setLimits(0.25, 0.0, 1.0);
  speedSlider.setNumberFormat(G4P.DECIMAL, 2);
  speedSlider.setOpaque(false);
  speedSlider.addEventHandler(this, "sliderChanged");
  
  //numWavesSlider
  numWavesSlider = new GSlider(parametersWindow.papplet, 70, 60, 100, 40, 10.0);
  numWavesSlider.setLimits(0.25, 0.0, 1.0);
  numWavesSlider.setNumberFormat(G4P.DECIMAL, 2);
  numWavesSlider.setOpaque(false);
  numWavesSlider.addEventHandler(this, "sliderChanged");
}

synchronized public void parametersWindow(GWinApplet appc, GWinData data) {
  appc.background(230);
}
 
// Handle events for slider1
public void speedSliderChanged(GSlider source, GEvent event) {
  println("new value: " + source.getValueF());
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

public int computeNumWaves()
{
  float sliderValue = numWavesSlider.getValueF();
  
  if (sliderValue < 0.25) {
    return 1;
  } else if (sliderValue < 0.5) {
    return 2;
  } else if (sliderValue < 0.75) {
    return 4;
  } else return 8;
}

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
          
            float speed = speedSlider.getValueF() * MAX_SPEED;
            float numWavesFactor = numWavesSlider.getValueF() * MAX_NUM_WAVES;
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

