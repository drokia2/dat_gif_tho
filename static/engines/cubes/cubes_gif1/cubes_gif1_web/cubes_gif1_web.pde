class Point {
    float x, y;

    Point(float x1, float y1) {
        this.x = x1;
        this.y = y1;
    }

    void reset(float x1, float y1) {
        this.x = x1;
        this.y = y1;
    }    
}

float distance(Point p1, Point p2) {
  return sqrt( pow(p2.y - p1.y,2) + pow( p2.x - p1.x,2) );
}

float distance(float x1, float x2, float y1, float y2) {
  return sqrt( pow(y2 - y1,2) + pow( x2 - x1,2) );
}

int FRAME_RATE = 60;

Point[] points;
float[] xs, ys;
int POINT_POOL_SIZE = 11;

// Setup the Processing Canvas
void setup(){
  size(CANVAS_WIDTH, CANVAS_HEIGHT, OPENGL);
  frameRate(FRAME_RATE);
  points = new Point[POINT_POOL_SIZE];
  
  xs = new float[POINT_POOL_SIZE];
  ys = new float[POINT_POOL_SIZE];
  
  for (int i = 0; i < POINT_POOL_SIZE; i++) {
    points[i] = new Point(0,0);
    xs[i] = 0;
    ys[i] = 0;
  }
  //smooth();
}

int CUBE_WIDTH = 20;
int NUM_ROWS = 30;
int NUM_COLS = 30;
int CANVAS_WIDTH = 600;
int CANVAS_HEIGHT = 600;
int TOP = 0;
int LEFT = 0;
int BACK = 0;
int MARGINX = 15;
int MARGINY = 10;

int SHORT = 10;
int LONG = 20;
int ORIGINAL_LONG = 20;
float EDGE = sqrt(pow(SHORT,2) + pow(LONG,2));

int MAX_SPEED = 8;
int MAX_NUM_WAVES = 8;

//Colors
color blue = color(137,209,184);
color yellow = color(204, 226, 189);
color black = color(0);
color white = color(255);

// Main draw loop
void draw(){
    background(0);       
    
    if (frameCount % 60 == 0) {
      println(frameRate);
    }
    
    int count = 0;
    Point center = new Point(width/2, height/2);
    float maxDistance = distance(center, new Point(0,0));       
        
    for (float centery = 0; centery < NUM_ROWS*EDGE; centery += EDGE + SHORT) {      
        float begin = (count % 2) * LONG;
        
        for (float centerx = begin; centerx < NUM_COLS*LONG*2; centerx += LONG*2) {                     
            
            xs[1] = centerx;
            ys[1] = centery - SHORT;
            
            xs[5] = centerx - LONG;
            ys[5] = centery + EDGE;
            
            xs[7] = centerx + LONG;
            ys[7] = centery + EDGE;
            
            xs[8] = xs[1]; 
            ys[8] = ys[1] + SHORT; //middlep1p3
            
            xs[9] = xs[7]; 
            ys[9] = ys[7] + SHORT; //destinationp7
            
            xs[10] = xs[5];
            ys[10] = ys[5] + SHORT; //destinationp5
            
            float d13 = distance(xs[8], width/2, ys[8], height/2);
            float d7 = distance(xs[9], width/2, ys[9], height/2);
            float d5 = distance(xs[10], width/2, ys[10], height/2);
          
            float speed = cubesGUI.speed * MAX_SPEED;
            float numWavesFactor = cubesGUI.numWaves * MAX_NUM_WAVES;
            numWavesFactor = map(numWavesFactor, 0, MAX_NUM_WAVES, 1, MAX_NUM_WAVES);
            
            float verticalScalar13 = ((sin(speed*(frameCount/FRAME_RATE + (d13/maxDistance)*numWavesFactor*PI)) + 1)/2);
            float verticalScalar5 = (sin(speed*(frameCount/FRAME_RATE + (d5/maxDistance)*numWavesFactor*PI)) + 1)/2;
            float verticalScalar7 = (sin(speed*(frameCount/FRAME_RATE + (d7/maxDistance)*numWavesFactor*PI)) + 1)/2;     
          
            xs[1] = centerx;
            ys[1] = centery - SHORT * verticalScalar13;
            
            xs[2] = centerx - LONG;
            ys[2] = centery;
            
            xs[3] = centerx;
            ys[3] = centery + SHORT * verticalScalar13;
            
            xs[4] = centerx + LONG;
            ys[4] = centery;
            
            xs[5] = centerx - LONG;
            ys[5] = centery + EDGE + SHORT * (1 - verticalScalar5);
            
            xs[6] = centerx;
            ys[6] = centery + SHORT + EDGE;
            
            xs[7] = centerx + LONG;
            ys[7] = centery + EDGE + SHORT * (1 - verticalScalar7);
            
            float d3 = distance(xs[3], width/2, ys[3], height/2);
            float colorFactor = cubesGUI.colorTravel ? verticalScalar13 : d3/pow(maxDistance, cubesGUI.colorFactor);
            
            color color1 = color(cubesGUI.color1[0], cubesGUI.color1[1], cubesGUI.color1[2]);
            color color2 = color(cubesGUI.color2[0], cubesGUI.color2[1], cubesGUI.color2[2]);
            color mainColor = lerpColor(color1, color2, colorFactor);
            color lighter = lerpColor(mainColor, white, 0.5);
            color darker = lerpColor(mainColor, black, 0.1);
            
            noStroke();
                        
            fill(darker);   
            quad(xs[1], ys[1], 
                xs[4], ys[4], 
                xs[3], ys[3],
                xs[2], ys[2]);

            fill(mainColor);
            quad(xs[3], ys[3], 
                xs[4], ys[4], 
                xs[7], ys[7], 
                xs[6], ys[6]);
            
            fill(lighter);
            quad(xs[3], ys[3], 
                xs[2], ys[2], 
                xs[5], ys[5], 
                xs[6], ys[6]);

        }        
        count++;
    }            
}

