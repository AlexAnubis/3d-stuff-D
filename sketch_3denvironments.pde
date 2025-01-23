import java.awt.Robot;

color black = #000000;
color white = #FFFFFF;
int gridSize;
PImage map;

Robot rbt;
boolean skipFrame;

boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ;
float leftRightHeadAngle, upDownHeadAngle;
PImage mossyStone;
PImage oakPlank;

void setup(){
  mossyStone = loadImage("mossystonebricks.png");
  textureMode(NORMAL);
  fullScreen(P3D);
  textureMode(NORMAL);
  wkey = akey = skey = dkey = false;
  eyeX = width/2;
  eyeY = 9*height/10;
  eyeZ = height/2;
  focusX = width/2;
  focusY = height/2;
  focusZ = height/2 - 100;
  upX = 0;
  upY = 1;
  upZ = 0;
  leftRightHeadAngle = radians(270);
  noCursor();
  
  map = loadImage("map.png");
  gridSize = 100;
  
  try{
    rbt = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
  skipFrame = false;
}

void draw(){
  background(0);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ);
  drawFloor();
  drawFocalPoint();
  controlCamera();
  drawMap();

}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x,y);
      if (c != white) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, mossyStone, gridSize);
      }
    }
  }
}

void drawFloor(){
  background(0);
  stroke(255);
  for (int x = -2000; x <= 2000; x = x + 100) {
    line(x,height,-2000,x,height,2000);
    line(-2000,height,x,2000,height,x);
  }
}

void controlCamera(){
  
  if (wkey) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey) {
    eyeX = eyeX - cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey){
    eyeX = eyeX - cos(leftRightHeadAngle+PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle+PI/2)*10;
  }
  if (dkey) {
    eyeX = eyeX + cos(leftRightHeadAngle+PI/2)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle+PI/2)*10;
  }
  
  if (skipFrame == false) {
    leftRightHeadAngle = leftRightHeadAngle + (mouseX - pmouseX)*0.005;
    upDownHeadAngle = upDownHeadAngle + (mouseY - pmouseY)*0.005;
  }
  if (upDownHeadAngle > PI/2.5) upDownHeadAngle = PI/2.5;
  if (upDownHeadAngle < -PI/2.5) upDownHeadAngle = -PI/2.5;
  
  focusX = eyeX + cos(leftRightHeadAngle)*300;
  focusY = eyeY + tan(upDownHeadAngle)*300;
  focusZ = eyeZ + sin(leftRightHeadAngle)*300;
  
  if (mouseX > width-2) {
    rbt.mouseMove(3, mouseY);
    skipFrame = true;
  }  else if (mouseX < 2) {
    rbt.mouseMove(width-3, mouseY);
    skipFrame = true;
  }  else {
    skipFrame = false;
  }
  
  
  println(eyeX, eyeY, eyeZ);
}

void drawFocalPoint(){
  pushMatrix();
  translate(focusX, focusY, focusZ);
  sphere(5);
  popMatrix();

}

void keyPressed() {
  if (key == 'W' || key == 'w') wkey = true;
  if (key == 'A' || key == 'a') akey = true;
  if (key == 'D' || key == 'd') dkey = true;
  if (key == 'S' || key == 's') skey = true;
}

void keyReleased() {
  if (key == 'W' || key == 'w') wkey = false;
  if (key == 'A' || key == 'a') akey = false;
  if (key == 'D' || key == 'd') dkey = false;
  if (key == 'S' || key == 's') skey = false;
}
