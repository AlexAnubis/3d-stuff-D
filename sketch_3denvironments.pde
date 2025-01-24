import java.awt.Robot;

color black = #000000;
color white = #FFFFFF;
color purple = #6f3198;
int gridSize;
PImage map;

Robot rbt;
boolean skipFrame;

boolean wkey, akey, skey, dkey;
float eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ;
float leftRightHeadAngle, upDownHeadAngle;

ArrayList<GameObject> objects;
PImage mossyStone;
PImage oakPlank;

void setup(){
  objects = new ArrayList<GameObject>();
  mossyStone = loadImage("Stone_Bricks.png");
  oakPlank = loadImage("woodplank.png");
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
  
  map = loadImage("map3.png");
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
  pointLight(255,255,255,eyeX,eyeY,eyeZ);
  camera(eyeX, eyeY, eyeZ, focusX, focusY, focusZ, upX, upY, upZ);
  drawFloor(-2000, 2000, height, gridSize);
  drawFloor(-2000, 2000, height-gridSize*4, gridSize);
  drawFocalPoint();
  controlCamera();
  drawMap();
  
  int i = 0;
  while (i < objects.size()) {
    GameObject obj = objects.get(i);
    obj.act();
    obj.show();
    if (obj.lives == 0) {
      objects.remove(i);
    } else {
    i++;
    }
    
    
  }

}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x,y);
      if (c != white) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, mossyStone, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, mossyStone, gridSize);
      }
      if (c == purple || c == black) {
        texturedCube(x*gridSize-2000, height-gridSize, y*gridSize-2000, oakPlank, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*2, y*gridSize-2000, oakPlank, gridSize);
        texturedCube(x*gridSize-2000, height-gridSize*3, y*gridSize-2000, oakPlank, gridSize);
      }
    }
  }
}

void drawFloor(int start, int end, int level, int gap){
  stroke(255);
  strokeWeight(1);
  int x = start;
  int z = start;
  while (z < end) {
    texturedCube(x, level, z, oakPlank, gap);
    x = x + gap;
    if(x >= end){
    x = start;
  
    z = z + gap;
    }
  }
  //for (int x = -2000; x <= 2000; x = x + 100) {
  //  line(x,height,-2000,x,height,2000);
  //  line(-2000,height,x,2000,height,x);
  //}
  //for (int x = -2000; x <= 2000; x = x + 100) {
  //  line(x,height-gridSize*3,-2000,x,height-gridSize*3,2000);
  //  line(-2000,height-gridSize*3,x,2000,height-gridSize*3,x);
  //}
  
}

void controlCamera(){
  
  if (wkey && canMoveForward()) {
    eyeX = eyeX + cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ + sin(leftRightHeadAngle)*10;
  }
  if (skey && canMoveBack()) {
    eyeX = eyeX - cos(leftRightHeadAngle)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle)*10;
  }
  if (akey && canMoveLeft()){
    eyeX = eyeX - cos(leftRightHeadAngle+PI/2)*10;
    eyeZ = eyeZ - sin(leftRightHeadAngle+PI/2)*10;
  }
  if (dkey && canMoveRight()) {
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

boolean canMoveForward(){
  float fwdx, fwdy, fwdz;
  
  int mapx, mapy;
  
  fwdx = eyeX + cos(leftRightHeadAngle)*200;
  fwdy = eyeY;
  fwdz = eyeZ + sin(leftRightHeadAngle)*200;
  
  mapx = int(fwdx+2000) / gridSize;
  mapy = int(fwdz+2000) / gridSize;
  if (map.get(mapx, mapy) == white) {
    return true;
  }  else {
    return false;
  }

}

boolean canMoveBack(){
  float backx, backy, backz;
  
  int mapx, mapy;
  
  backx = eyeX - cos(leftRightHeadAngle)*200;
  backy = eyeY;
  backz = eyeZ - sin(leftRightHeadAngle)*200;
  
  mapx = int(backx+2000) / gridSize;
  mapy = int(backz+2000) / gridSize;
  if (map.get(mapx, mapy) == white) {
    return true;
  }  else {
    return false;
  }

}

boolean canMoveLeft(){
  float leftx, lefty, leftz;
  int mapx, mapy;
  
  leftx = eyeX - cos(leftRightHeadAngle+PI/2)*200;
  lefty = eyeY;
  leftz = eyeZ - sin(leftRightHeadAngle+PI/2)*200;
  
  mapx = int(leftx+2000) / gridSize;
  mapy = int(leftz+2000) / gridSize;
  if (map.get(mapx, mapy) == white) {
    return true;
  }  else {
    return false;
  }

}

boolean canMoveRight(){
  float rightx, righty, rightz;
  int mapx, mapy;
  
  rightx = eyeX + cos(leftRightHeadAngle+PI/2)*200;
  righty = eyeY;
  rightz = eyeZ + sin(leftRightHeadAngle+PI/2)*200;
  
  mapx = int(rightx+2000) / gridSize;
  mapy = int(rightz+2000) / gridSize;
  if (map.get(mapx, mapy) == white) {
    return true;
  }  else {
    return false;
  }

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
