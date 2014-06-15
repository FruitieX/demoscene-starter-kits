PShape turtle;

void setup()
{
  size(500,500,P3D);
  turtle = loadShape("/home/jonathan/graffathon-demo/demo/turtle.obj");
  noStroke();
  frameRate(10);
}

void draw()
{
  colorMode(HSB, 100);
  color bg = color(100*pow(sin(radians(frameCount+60)), 2), 100, 100);
  background(bg);
  colorMode(RGB, 255);
  translate(width/2, height/2, 0);
  pushMatrix();
  rotateX(radians(90));
  colorMode(HSB, 100);
  color hsb = color(100*pow(sin(radians(frameCount)), 6), 100, 100);
  fill(hsb);
  colorMode(RGB, 255);
  pushMatrix();
  scale(150);
  lights();
  rotateX(radians(90));
  rotateY(-radians(90));
  turtle.disableStyle();
  translate(0,0,-0.6);
  //shape(turtle);
  colorMode(HSB, 100);
  for (int i=0; i <= 5; i++){
    int h = (int) random(100);
    pushMatrix();
    fill(h, 100, 100, 50);
    float x = random(-1.5, 1.5);
    float z = random(-1.5, 1.5);
    translate(x,0,z);
    rotateY(random(360));
    shape(turtle);
    popMatrix();
  }
  colorMode(RGB, 255);
  popMatrix();
  popMatrix();
  translate(0, 0, 0);
  camera(width/2+100, height/2 - 300, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0);
  

}
