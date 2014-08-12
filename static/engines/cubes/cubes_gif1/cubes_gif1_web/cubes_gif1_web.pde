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

int FRAME_RATE = 60;

Point[] points;
int POINT_POOL_SIZE = 11;

// Setup the Processing Canvas
void setup(){
  size(CANVAS_WIDTH, CANVAS_HEIGHT, OPENGL);
  frameRate(FRAME_RATE);
  points = new Point[POINT_POOL_SIZE];
  
  for (int i = 0; i < POINT_POOL_SIZE; i++) {
    points[i] = new Point(0,0);
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
    smooth();    
    
    if (frameCount % 60 == 0) {
      println(frameRate);
    }
    
    int count = 0;
    Point center = new Point(width/2, height/2);
    float maxDistance = distance(center, new Point(0,0));       
        
    for (float centery = 0; centery < NUM_ROWS*EDGE; centery += EDGE + SHORT) {      
        float begin = (count % 2) * LONG;
        
        for (float centerx = begin; centerx < NUM_COLS*LONG*2; centerx += LONG*2) {                     
            
            points[1].reset(centerx, centery - SHORT);
            points[5].reset(centerx - LONG, centery + EDGE);
            points[7].reset(centerx + LONG, centery + EDGE);
            points[8].reset(points[1].x, points[1].y + SHORT); //middlep1p3
            points[9].reset(points[7].x, points[7].y + SHORT); //destinationp7
            points[10].reset(points[5].x, points[5].y + SHORT); //destinationp5
            
            float d13 = distance(points[8], center);
            float d7 = distance(points[9], center);
            float d5 = distance(points[10], center);
          
            float speed = cubesGUI.speed * MAX_SPEED;
            float numWavesFactor = cubesGUI.numWaves * MAX_NUM_WAVES;
            numWavesFactor = map(numWavesFactor, 0, MAX_NUM_WAVES, 1, MAX_NUM_WAVES);
            
            float verticalScalar13 = ((sin(speed*(frameCount/FRAME_RATE + (d13/maxDistance)*numWavesFactor*PI)) + 1)/2);
            float verticalScalar5 = (sin(speed*(frameCount/FRAME_RATE + (d5/maxDistance)*numWavesFactor*PI)) + 1)/2;
            float verticalScalar7 = (sin(speed*(frameCount/FRAME_RATE + (d7/maxDistance)*numWavesFactor*PI)) + 1)/2;     
          
            points[1].reset(centerx, centery - SHORT * verticalScalar13);
            points[2].reset(centerx - LONG, centery);
            points[3].reset(centerx, centery + SHORT * verticalScalar13);
            points[4].reset(centerx + LONG, centery);
            points[5].reset(centerx - LONG, centery + EDGE + SHORT * (1 - verticalScalar5));
            points[6].reset(centerx, centery + SHORT + EDGE); 
            points[7].reset(centerx + LONG, centery + EDGE + SHORT * (1 - verticalScalar7));
            
            float d3 = distance(points[3], center);
            float colorFactor = cubesGUI.colorTravel ? verticalScalar13 : d3/pow(maxDistance, cubesGUI.colorFactor);
            
            color color1 = color(cubesGUI.color1[0], cubesGUI.color1[1], cubesGUI.color1[2]);
            color color2 = color(cubesGUI.color2[0], cubesGUI.color2[1], cubesGUI.color2[2]);
            color mainColor = lerpColor(color1, color2, colorFactor);
            color lighter = lerpColor(mainColor, white, 0.5);
            color darker = lerpColor(mainColor, black, 0.1);
            
            noStroke();
                        
            fill(darker);   
            quad(points[1].x, points[1].y, 
                points[4].x, points[4].y, 
                points[3].x, points[3].y,
                points[2].x, points[2].y);

            fill(mainColor);
            quad(points[3].x, points[3].y, 
                points[4].x, points[4].y, 
                points[7].x, points[7].y, 
                points[6].x, points[6].y);
            
            fill(lighter);
            quad(points[3].x, points[3].y, 
                points[2].x, points[2].y, 
                points[5].x, points[5].y, 
                points[6].x, points[6].y);

        }        
        count++;
    }            
}

