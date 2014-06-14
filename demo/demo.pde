/*
 * An example of how to use
 * Processing's 3D features.
 *
 * Features:
 * - Setting up a 3D viewport
 * - Drawing plane and sphere primitives
 * - 3D-transformations
 */
import moonlander.library.*;

import ddf.minim.*;

Moonlander moonlander;

int scene = 1;

int CANVAS_WIDTH = 1920/2;
int CANVAS_HEIGHT = 1080/2;
PShape s;
PShader oceanShader;

class Bubble {
  PShape b;
  
  Bubble(PShape b_) {
    b = b_; //createShape(SPHERE, x, y, size, size);
//    b.setFill(color(100,100,255);
  }
  
  void display() { shape(b); }

	void disableStyle() { b.disableStyle(); }
//	void setFillColor(int a, int r, int g, int blue) { Fill(a,r,g,blue); }
}

Bubble[] bubbles = new Bubble[3];

void setup() {
	// The P3D parameter enables accelerated 3D rendering.
        moonlander = Moonlander.initWithSoundtrack(this, "graffa.wav", 100, 4);
	size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
	rectMode(CENTER);

	noStroke();
	colorMode(RGB, 1);

	perspective(PI/3.0,(float)width/height,1,100000);
	s = loadShape("flatgrid.obj");
	/*
	s = createShape();
	s.beginShape(TRIANGLE_STRIP);
	int cnt = 90;
	for(int i = 0; i < cnt; i++) {
		for(int j = 0; j < cnt; j++) {
			int y = j;
			if(y >= cnt / 2)
				y = cnt / 2 - (j - cnt / 2);
			//s.fill((float)i / (float)cnt, (float)y / (float)cnt, (float)y / (float)cnt);

			s.vertex(i, 0, y);
			s.vertex(i, 0, y + 1);
			s.vertex(i + 1, 0, y);
			s.vertex(i + 1, 0, y + 1);
		}
	}
	s.endShape();
	*/

	oceanShader = loadShader("toonFrag.glsl", "toonVert.glsl");
	oceanShader.set("fraction", 1.0);
	oceanShader.set("baseColor", 0.2, 0.7, 1.0, 1.0);
	oceanShader.set("color1", 1.0);
	oceanShader.set("color2", 0.9);
	oceanShader.set("color3", 0.8);
	oceanShader.set("color4", 0.7);
	oceanShader.set("color5", 0.5);
	oceanShader.set("color6", 0.4);
	oceanShader.set("color7", 0.2);
	oceanShader.set("color8", 0.1);
	oceanShader.set("color_treshold1", 1.0);
	oceanShader.set("color_treshold2", 0.9);
	oceanShader.set("color_treshold3", 0.8);
	oceanShader.set("color_treshold4", 0.7);
	oceanShader.set("color_treshold5", 0.5);
	oceanShader.set("color_treshold6", 0.4);
	oceanShader.set("color_treshold7", 0.3);

	// create bubbles
        float size = 100;
        bubbles[0] = new Bubble(createShape(SPHERE, size, size));
        bubbles[1] = new Bubble(createShape(SPHERE, size*.7, size*.7));
        bubbles[2] = new Bubble(createShape(SPHERE, size*.5, size*.5));
//	for (int i = 0; i < bubbles.length; i++) bubbles[i].setFillColor(100,100,100,255);

	moonlander.start();
}

void draw() {
	// update moonlander with rocket
	moonlander.update();

	double bg_red = moonlander.getValue("background_red");

	background(0, 0, 0);

	//directionalLight(255, 255, 255, -(pow(sin(radians((float) moonlander.getCurrentTime())), 2)+300 / float(width) - 0.5) * 2, -(300 / float(height) - 0.5) * 2, -1);
	directionalLight(255, 255, 255, 0, -1, 0);
	// Center the view
	pushMatrix();
	translate((float) moonlander.getValue("camera_x"),
			(float) moonlander.getValue("camera_y"),
			(float) moonlander.getValue("camera_z"));
	rotateX(radians((float) moonlander.getValue("rotate_x")));
	rotateZ(radians((float) moonlander.getValue("rotate_z")));
	rotateY(radians((float) moonlander.getValue("rotate_y")));
	// Move up and backwards - away from the origin
	//translate(-2000, 1000, -2000);
	scale(500);
	//lights();
	// Rotate the viewport a bit with mouse
	//rotateY((mouseX - width/2) * 0.003);
	//rotateX((mouseY - height/2) * -0.003);


	shader(oceanShader);

	//rotate(pmouseX / 360.0, 1, 0, 0);
	for (int j = 0; j < s.getChildCount(); j++) {
		PShape child = s.getChild(j);

		for(int i = 0; i < child.getVertexCount(); i++) {
			PVector v = child.getVertex(i);
			v.y = (float) moonlander.getValue("wave1") * (sin(v.x * (float) moonlander.getValue("wave1_spd") + (float) moonlander.getCurrentTime()) + cos(v.z * (float) moonlander.getValue("wave1_spd") + (float) moonlander.getCurrentTime()));
			v.y += (float) moonlander.getValue("wave2") * (sin(v.x * (float) moonlander.getValue("wave2_spd") + (float) moonlander.getCurrentTime()) + cos(v.z * (float) moonlander.getValue("wave2_spd") + (float) moonlander.getCurrentTime()));
			v.y += (float) moonlander.getValue("wave3") * (sin(v.x * (float) moonlander.getValue("wave3_spd") + (float) moonlander.getCurrentTime()) + cos(v.z * (float) moonlander.getValue("wave3_spd") + (float) moonlander.getCurrentTime()));
			v.y += (float) moonlander.getValue("wave4") * ((v.x * v.x + v.z * v.z * v.z) % 20);
			child.setVertex(i, v);
		}
	}
	shape(s);
	popMatrix();

	lights();

	float sx = (float) moonlander.getValue("SphereX");
	float sy = (float) moonlander.getValue("SphereY");
	float sz = (float) moonlander.getValue("SphereZ");
	for (int i = 0; i < bubbles.length; i++) {
		 println("drawing bubble "+i);
		pushMatrix();
		translate(sx+i*100,sy,sz);
		bubbles[i].display();
		popMatrix();
	}

	resetShader();

	if (scene == 2) {
		resetShader();

		fill(100,100,100,255);
//		float sx = (float) moonlander.getValue("SphereX");
//		float sy = (float) moonlander.getValue("SphereY");
//		float sz = (float) moonlander.getValue("SphereZ");
		for (int i = 0; i < bubbles.length; i++) {
			 println("drawing bubble "+i);
			pushMatrix();
			translate(sx+i*100,sy,sz);
			bubbles[i].disableStyle();
			bubbles[i].display();
			popMatrix();
		}
	}
}
