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
PShape s,b; // s is the ocean,  b is bubble
PShader oceanShader;

void setup() {
	// The P3D parameter enables accelerated 3D rendering.
        moonlander = Moonlander.initWithSoundtrack(this, "graffa.wav", 100, 4);
	size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
	rectMode(CENTER);

	noStroke();
	colorMode(RGB, 1);

	b = loadShape("bubble.obj");

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
	oceanShader.set("color1", 1.0);
	oceanShader.set("color2", 0.9);
	oceanShader.set("color3", 0.8);
	oceanShader.set("color4", 0.7);
	oceanShader.set("color5", 0.6);
	oceanShader.set("color6", 0.5);
	oceanShader.set("color7", 0.4);
	oceanShader.set("color8", 0.3);
	oceanShader.set("color_treshold1", 1.0);
	oceanShader.set("color_treshold2", 0.9);
	oceanShader.set("color_treshold3", 0.8);
	oceanShader.set("color_treshold4", 0.7);
	oceanShader.set("color_treshold5", 0.6);
	oceanShader.set("color_treshold6", 0.5);
	oceanShader.set("color_treshold7", 0.4);

	moonlander.start();
}

void draw() {
	// update moonlander with rocket
	moonlander.update();

	oceanShader.set("baseColor", (float) moonlander.getValue("water_R"), (float) moonlander.getValue("water_G"), (float) moonlander.getValue("water_B"), (float) moonlander.getValue("water_alpha"));
	background(0, 0, 0);

	//directionalLight(255, 255, 255, -(pow(sin(radians((float) moonlander.getCurrentTime())), 2)+300 / float(width) - 0.5) * 2, -(300 / float(height) - 0.5) * 2, -1);
	directionalLight(255, 255, 255, 0, 1, 0);
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

	int scene = (int) moonlander.getValue("scene");

	if(scene == 1 || scene == 2) {
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
	}
	shape(s);

	if (scene == 2) {
		// draw bubbles
		float bx = (float) moonlander.getValue("SphereX");
		float by = (float) moonlander.getValue("SphereY");
		float bz = (float) moonlander.getValue("SphereZ");
		for (int i = 0; i < 1; i++) {
			pushMatrix();
			rotateY(-PI/2); // make the axises correct in a scientific way
			translate(bx, by, bz);
			shape(b);
			popMatrix();
		}
		/*
		for (int i = 0; i < 1; i++) {
			pushMatrix();
			rotateY(-PI/2); // make the axises correct in a scientific way
			translate(bx, by, bz);
			sphereDetail(8, 8);
			sphere(100);
			popMatrix();
		}
		*/
	}

	popMatrix();

	hint(DISABLE_DEPTH_TEST);
	fill((float) moonlander.getValue("fadecolorR"), (float) moonlander.getValue("fadecolorG"), (float) moonlander.getValue("fadecolorB"), (float) moonlander.getValue("fade"));
	rect(0, 0, width * 2, height * 2);
	hint(ENABLE_DEPTH_TEST);
}
