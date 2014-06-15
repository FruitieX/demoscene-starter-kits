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
import ddf.minim.analysis.*;
import java.util.*;

Moonlander moonlander;

int CANVAS_WIDTH = 1920/2;
int CANVAS_HEIGHT = 1080/2;
PShape s,b; // s is the ocean,  b is bubble
PShader oceanShader;

float currentTime; // = moonlander.getCurrentTime();
float lastTime=0;

class Hexagon {
	PShape h;

	Hexagon(float side, int a) {
		h = createShape();
		h.beginShape();
//		fill(a,0,0,200);
//		stroke(0,0,200);
		//h.fill();
//		h.stroke();
//		float trimid = tan(PI/6)*side/2;
		float trih = cos(PI/6)*side; // height of triangle (hexagon consists of 6 triangles)
		h.vertex(-side,0);
		h.vertex(-side/2, -trih);
		h.vertex(side/2, -trih);
		h.vertex(side,0);
		h.vertex(side/2, trih);
		h.vertex(-side/2, trih);
		h.endShape(CLOSE);
		h.disableStyle();
	}

	PVector getVertex(int index) { return h.getVertex(index); }

	int getVertexCount() { return h.getVertexCount(); }

	void setVertex(int index, PVector v) {
		h.setVertex(index, v);
	}

	void display() { shape(h); }
}
void drawTrail(int a, int r, int g, int b) {
	stroke(a,r,g,b);
	fill(a,r,g,b);

}

void rec(int level, Hexagon h) {
	if (level>0) {
//		resetShader();
//		fill(level*20,200-level*30,200);
//		stroke(0,0,200);
		h.display();
		if (level > 1) {
			for (int i = 0; i < 6; i++) {
				pushMatrix();
//				scale(0.8,0.8);
				PVector v = h.getVertex(i);
				translate(v.x*2.0*sin((float)moonlander.getCurrentTime()),v.y*2.0*sin((float)moonlander.getCurrentTime()));
				rec(level-1,h);
				popMatrix();
			}
		}
	}
}

int windowsize = 1024; // fft-puskurin koko, muutettavissa napeilla a ja s
int rate = 44100; // samplerate

Hexagon hex;
FFT fft;
float[] sampledata;
MultiChannelBuffer buffers;
AudioPlayer audioplayer;
Minim minim;

int player_samplepos() {
	float secs = (float) moonlander.getCurrentTime();
	int samplepos = (int)(secs * rate);
	samplepos -= windowsize/2;
	samplepos = max(samplepos, 0);
	samplepos = min(samplepos, sampledata.length - windowsize);
	return samplepos;
}

void analyze() {
	int samplepos = player_samplepos();
	float[] window = Arrays.copyOfRange(sampledata, samplepos, samplepos + windowsize);
	fft.forward(window);
}

void setup() {
	// fft
	frameRate(60);
	minim = new Minim(this);
	buffers = new MultiChannelBuffer(2, 2);
	minim.loadFileIntoBuffer("graffa.wav", buffers);
	sampledata = buffers.getChannel(0);
	fft = new FFT(windowsize, rate);
	fft.window(FFT.HAMMING);

	// The P3D parameter enables accelerated 3D rendering.
	moonlander = Moonlander.initWithSoundtrack(this, "graffa.wav", 89, 4);
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

	// create hexagon
	hex = new Hexagon(100, 255);

	moonlander.start();
}

void draw() {
	// update moonlander with rocket
	moonlander.update();
	currentTime = (float) moonlander.getCurrentTime();
	analyze();

	int scene = (int) moonlander.getValue("scene");

	if(scene == 1 || scene == 2) {
		float beat1 = fft.getBand((int) moonlander.getValue("beat1_band"));
		float beat2 = fft.getBand((int) moonlander.getValue("beat2_band"));
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

		shader(oceanShader);

		//rotate(pmouseX / 360.0, 1, 0, 0);
		for (int j = 0; j < s.getChildCount(); j++) {
			PShape child = s.getChild(j);

			for(int i = 0; i < child.getVertexCount(); i++) {
				PVector v = child.getVertex(i);
				v.y = (float) moonlander.getValue("wave1") * (sin(v.x * (float) moonlander.getValue("wave1_spd") + (float) moonlander.getCurrentTime()) + cos(v.z * (float) moonlander.getValue("wave1_spd") + (float) moonlander.getCurrentTime()));
				v.y += (float) moonlander.getValue("wave2") * (sin(v.x * (float) moonlander.getValue("wave2_spd") + (float) moonlander.getCurrentTime()) + cos(v.z * (float) moonlander.getValue("wave2_spd") + (float) moonlander.getCurrentTime()));
				v.y += max(0.5, min(beat2 / 10, 1)) * (float) moonlander.getValue("wave3") * (sin(v.x * (float) moonlander.getValue("wave3_spd") + (float) moonlander.getCurrentTime()) + cos(v.z * (float) moonlander.getValue("wave3_spd") + (float) moonlander.getCurrentTime()));
				v.y += max(0.5, min(beat1 / 10, 1)) * (float) moonlander.getValue("wave4") * ((v.x * v.x + v.z * v.z * v.z) % 20);
				child.setVertex(i, v);
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
		}

		resetShader();
		popMatrix();
	}

	int level = (int) moonlander.getValue("Recursion level");
	if (scene == 3) {
		background(255,255,255);

		// make nice background
		int numRect = (int) moonlander.getValue("Rectangel #");
		if (numRect > 1) {
			for (int i = 0; i < numRect; i++) {
				fill(255-random(0,100),50.0*sin(currentTime), 100.0-currentTime%30,200.0-currentTime%30);
				rect(0,CANVAS_HEIGHT/numRect*i,CANVAS_WIDTH*1.5,CANVAS_HEIGHT/(numRect-1));
			}
		}

		pushMatrix();
		translate(CANVAS_WIDTH/2,CANVAS_HEIGHT/2);
		fill(.8,200,100-(100.0*sin((float)moonlander.getCurrentTime())),50);
		stroke(0,0,0);
		strokeWeight(2);
//		hex.display();
		int rotate = (int) moonlander.getValue("Rotate");
		if (rotate == 1 && lastTime != currentTime) {
			for (int i = 0; i < hex.getVertexCount(); i++ ) {
	//			fill(0, 200*i, 255-i*20);
				PVector v = hex.getVertex(i);
				v.x += cos(PI*(float)millis()/1000.0);
				v.y += sin(PI*(float)millis()/1000.0);
				hex.setVertex(i, v);
			}
		}
		rec(level,hex);
//		rect(0,0,100,100);
		popMatrix();
		lastTime = currentTime;
	}

	hint(DISABLE_DEPTH_TEST);
	fill((float) moonlander.getValue("fadecolorR"), (float) moonlander.getValue("fadecolorG"), (float) moonlander.getValue("fadecolorB"), (float) moonlander.getValue("fade"));
	rect(0, 0, width * 2, height * 2);
	hint(ENABLE_DEPTH_TEST);
}
