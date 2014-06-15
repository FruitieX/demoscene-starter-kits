float[][] points;
float mindist = 100;
int ptnum = 300;
PShader toonShader;

void setup()
{
  size(600, 600, P3D);
  background(0);
  toonShader = loadShader("/home/jonathan/graffathon-demo/demo/toonFrag.glsl", "/home/jonathan/graffathon-demo/demo/toonVert.glsl");
  toonShader.set("fraction", 1.0);
  toonShader.set("baseColor", 1.0, 1.0, 1.0);
  toonShader.set("color1", 1.0);
  toonShader.set("color2", 0.9);
  toonShader.set("color3", 0.8);
  toonShader.set("color4", 0.7);
  toonShader.set("color5", 0.6);
  toonShader.set("color6", 0.5);
  toonShader.set("color7", 0.4);
  toonShader.set("color8", 0.3);
  toonShader.set("color_treshold1", 1.0);
  toonShader.set("color_treshold2", 0.9);
  toonShader.set("color_treshold3", 0.8);
  toonShader.set("color_treshold4", 0.7);
  toonShader.set("color_treshold5", 0.6);
  toonShader.set("color_treshold6", 0.5);
  toonShader.set("color_treshold7", 0.4);
  points = new float[ptnum][3];
  for (int i=0; i < ptnum; i++){
    points[i][0] = random(20, width);
    points[i][1] = random(20, height);
    points[i][2] = random(20, width);
  }
}

void draw()
{
  hint(DISABLE_DEPTH_TEST);
  fill(0,2);
  rect(0, 0, width * 2, height * 2);
  hint(ENABLE_DEPTH_TEST);
  
  pushMatrix();
  translate(width/2, height/2, 0);
  pushMatrix();
  rotateZ(radians(frameCount*3));
  scale(radians(frameCount*0.1));
  for (int i = 0; i < ptnum; i++){
    points[i][0] += sin(radians(frameCount)*noise(points[i][0]+50))*random(-2, 2);
    points[i][1] += cos(radians(frameCount)*noise(points[i][1]+13))*random(-2, 2);
    points[i][2] += cos(radians(frameCount)*noise(points[i][2]))*random(-2, 2);
  }
  fill(255);
  stroke(255, 15);
  blendMode(BLEND);
  
  for (int i=0; i<ptnum; i++){
    for (int j=0; j<ptnum; j++){
      float d = dist(points[i][0], points[i][1], points[i][2], points[j][0], points[j][1], points[j][2]);     
      if (d < mindist){
        line(points[i][0], points[i][1], points[i][2], points[j][0], points[j][1], points[j][2]);
      }
    }
  }
  popMatrix();
  rotateY(radians(frameCount*4));
  directionalLight(255, 255, 255, 0, 1, 0);
  noStroke();
  fill(155);
  scale(5);
  //scale(radians(frameCount)*0.5);
  sphere(10);
  resetShader();
  popMatrix();
}
