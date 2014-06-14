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
}

Bubble[] bubbles = new Bubble[3];

void setup() {
	// The P3D parameter enables accelerated 3D rendering.
        moonlander = Moonlander.initWithSoundtrack(this, "graffa.wav", 100, 4);
	size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
	rectMode(CENTER);

	noStroke();
	colorMode(RGB, 1);

	s = loadShape("ocean.obj");
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
	oceanShader.set("fraction", 2.0);
	oceanShader.set("color1", 0.2, 0.4, 1.0);
	oceanShader.set("color2", 0.1, 0.3, 0.8);
	oceanShader.set("color3", 0.1, 0.3, 0.6);
	oceanShader.set("color4", 0.0, 0.3, 0.6);

        float size = 100;
        bubbles[0] = new Bubble(createShape(SPHERE, size, size));
        bubbles[1] = new Bubble(createShape(SPHERE, size*.7, size*.7));
        bubbles[2] = new Bubble(createShape(SPHERE, size*.5, size*.5));

	moonlander.start();
}

void draw() {
        // update moonlander with rocket
	moonlander.update();

	double bg_red = moonlander.getValue("background_red");

	background(0, 0, 0);

	directionalLight(255, 255, 255, -(pow(sin(radians((float) moonlander.getCurrentTime())), 2)+300 / float(width) - 0.5) * 2, -(300 / float(height) - 0.5) * 2, -1);
	// Center the view
	translate(width/2, height/2, 0);
	// Move up and backwards - away from the origin
	translate(-2000, 500, -2000);
	scale(500);
	//lights();
	// Rotate the viewport a bit with mouse
	//rotateY((mouseX - width/2) * 0.003);
	//rotateX((mouseY - height/2) * -0.003);

	pushMatrix();

	shader(oceanShader);

	//rotate(pmouseX / 360.0, 1, 0, 0);
	for (int j = 0; j < s.getChildCount(); j++) {
		PShape child = s.getChild(j);

		for(int i = 0; i < child.getVertexCount(); i++) {
			PVector v = child.getVertex(i);
			v.y = sin(v.x / 2.0 + (float) moonlander.getCurrentTime()) + cos(v.z / 2.0 + (float) moonlander.getCurrentTime());
			v.y += 0.5 * sin(v.x / 5.0 + (float) moonlander.getCurrentTime()) + cos(v.z / 5.0 + (float) moonlander.getCurrentTime());
			v.y += 0.5 * sin(v.x / 7.0 + (float) moonlander.getCurrentTime()) + cos(v.z / 7.0 + (float) moonlander.getCurrentTime());
			v.y += 0.05 * ((v.x * v.x + v.z * v.z * v.z) % 20);
			child.setVertex(i, v);
		}
	}
	shape(s);
	popMatrix();

        for (int i = 0; i < bubbles.length; i++) { println("drawing bubble "+i); bubbles[i].display(); }

	resetShader();
}
