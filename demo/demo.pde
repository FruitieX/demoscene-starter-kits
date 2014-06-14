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
float[] y_pos;

void setup() {
	// The P3D parameter enables accelerated 3D rendering.
	size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
	rectMode(CENTER);

	s = createShape();
	s.beginShape();
	for(int y = 0; y < 20; y++) {
		for(int x = 0; x < 20; x++) {
			s.vertex(x * 10, 0, y * 10);
		}
	}
	s.endShape(CLOSE);

	y_pos = new float[s.getVertexCount()];

	for(int i = 0; i < s.getVertexCount(); i++) {
		PVector v = s.getVertex(i);
		y_pos[i] = v.y;
	}
}

void draw() {
	background(0, 0, 0);
	float secs = millis() / 1000.0;

	// Center the view
	translate(width/2, height/2, 0);
	// Move up and backwards - away from the origin
	translate(0, 100, -1000);
	scale(5);
	lights();
	// Rotate the viewport a bit with mouse
	rotateY((mouseX - width/2) * 0.003);
	rotateX((mouseY - height/2) * -0.003);

	for(int i = 0; i < s.getVertexCount(); i++) {
		PVector v = s.getVertex(i);
		v.y = y_pos[i] + 100 * sin(v.x / 100.0 + millis() / 1000.0);
		println(v.y);
		s.setVertex(i, v);
	}

	//fill(255, 255, 255);


	// Draw the ground plane

	//pushMatrix();
	// Rotate the plane by 90 degrees so it's laying on the ground
	// instead of facing the camera. Try to use `secs` instead and
	// see what happens :)
	//rotateX(PI/2);
	//scale(6.0);
	// Draw the plane
	//rect(0, 0, 100, 100);
	//popMatrix();

	//scale(100);
	shape(s);

	//fill(255, 255, 0);
	//stroke(255,0,0);
	/*
	for (float i=0;i<100;i++) {
		for (float j=0;j<100;j++) {
			point(3*i-100,-100+5*sin(i*.5-2*j),3*j+200);
		}
	}
	stroke(0);


	// Draw the bouncing ball

	pushMatrix();
	// Calculate the sphere trajectory
	float sphereY = abs(sin(secs*2.0)) * -400.0;
	float sphereRadius = 100;

	// Move the sphere up so it doesn't intersect with the plane
	translate(0, -sphereRadius);
	// Apply the bouncing motion trajectory
	translate(0, sphereY, 0);

	// Note that this rotation should be considered happening *before* the
	// translations specified above. The transformations are written in the reverse
	// order they are actually applied to the rendered object. Yes, it's confusing.
	rotateY(secs);

	// Draw the sphere
	sphere(sphereRadius);
	popMatrix();
	*/
}
