/*
 * An example of how to use
 * Processing's 3D features.
 *
 * Features:
 * - Setting up a 3D viewport
 * - Drawing plane and sphere primitives
 * - 3D-transformations
 */

int CANVAS_WIDTH = 1920;
int CANVAS_HEIGHT = 1080;
PShape s;

void setup() {
	// The P3D parameter enables accelerated 3D rendering.
	size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
	rectMode(CENTER);

	s = createShape();
	s.beginShape(QUAD_STRIP);
	for(int i = 0; i < 20; i++) {
		for(int j = 0; j < 20; j++) {
			s.vertex(i, 0, j);
			s.vertex(i, 0, j + 1);
			s.vertex(i + 1, 0, j);
			s.vertex(i + 1, 0, j + 1);
		}
	}
	s.endShape();
}

void draw() {
	background(0, 0, 0);
	float secs = millis() / 1000.0;

	// Center the view
	translate(width/2, height/2, 0);
	// Move up and backwards - away from the origin
	translate(-500, 100, -100);
	scale(50);
	lights();
	// Rotate the viewport a bit with mouse
	//rotateY((mouseX - width/2) * 0.003);
	//rotateX((mouseY - height/2) * -0.003);

	pushMatrix();
	//rotate(pmouseX / 360.0, 1, 0, 0);
	for(int i = 0; i < s.getVertexCount(); i++) {
		PVector v = s.getVertex(i);
		v.y = 2 * sin(v.x / 10.0 + millis() / 1000.0);
		s.setVertex(i, v);
	}

	shape(s);
	popMatrix();
}
